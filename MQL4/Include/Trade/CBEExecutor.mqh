#ifndef __CBEEXECUTOR__
#define __CBEEXECUTOR__

#include "../Common/CommonDefs.mqh"
#include "../Logic/CPositionModel.mqh"
#include "../Logic/CPriceCalculator.mqh"
#include "COrderExecutorBase.mqh"

class CBEExecutor : public COrderExecutorBase
  {
private:
   CPositionModel     m_positionModel;
   CPriceCalculator   m_priceCalc;

public:
   CBEExecutor();
   ~CBEExecutor();

   bool MoveSLToBE(string symbol);
   bool MoveSLToBEForTicket(int ticket);

   double CalculateTrueBEPrice(int ticket);
   double CalculateOffsetBEPrice(int ticket, double offsetPips);
   double CalculateTrueBEPriceWithSlippage(int ticket, double slippagePips);

   double GetEntryPrice(int ticket);
   string GetLastErrorMessage();
  };

CBEExecutor::CBEExecutor() {}
CBEExecutor::~CBEExecutor() {}

double CBEExecutor::GetEntryPrice(int ticket)
{
   return m_positionModel.GetEntryPrice(ticket);
}

string CBEExecutor::GetLastErrorMessage()
{
   return m_lastError;
}

bool CBEExecutor::MoveSLToBE(string symbol)
{
   LOG_ACTION_DEBUG("[ENTER] MoveSLToBE(): symbol = " + symbol);

   LOG_ACTION_INFO("MoveSLToBE start: symbol = " + symbol);

   int tickets[];
   int total = m_positionModel.GetPositionTickets(symbol, tickets);

   LOG_ACTION_INFO("ticket count = " + IntegerToString(total));

   if (total == 0)
   {
      m_lastError = "No positions found for symbol: " + symbol;
      LOG_ACTION_ERROR("No tickets found. Aborting.");
      LOG_ACTION_DEBUG("[EXIT] MoveSLToBE(): result = false");
      return false;
   }

   bool success = false;
   for (int i = 0; i < total; i++)
   {
      int ticket = tickets[i];
      LOG_ACTION_DEBUG("Processing ticket = " + IntegerToString(ticket));

      if (MoveSLToBEForTicket(ticket))
      {
         LOG_ACTION_INFO("✅ BE move success for ticket = " + IntegerToString(ticket));
         success = true;
      }
      else
      {
         LOG_ACTION_ERROR("❌ BE move failed for ticket = " + IntegerToString(ticket));
      }
   }

   LOG_ACTION_INFO("MoveSLToBE end.");
   LOG_ACTION_DEBUG("[EXIT] MoveSLToBE(): result = " + (success ? "true" : "false"));
   return success;
}

bool CBEExecutor::MoveSLToBEForTicket(int ticket)
{
    LOG_ACTION_DEBUG("[ENTER] MoveSLToBEForTicket(): ticket = " + IntegerToString(ticket));

    if (!OrderSelect(ticket, SELECT_BY_TICKET))
    {
        m_lastError = "OrderSelect failed";
        LOG_ACTION_ERROR("OrderSelect failed for ticket = " + IntegerToString(ticket));
        LOG_ACTION_DEBUG("[EXIT] MoveSLToBEForTicket(): result = false");
        return false;
    }

    double entryPrice = OrderOpenPrice();
    double currentSL  = OrderStopLoss();
    bool hasSL        = (currentSL > 0.0);

    int type = OrderType();
    string typeLabel = (type == OP_BUY ? "BUY" : type == OP_SELL ? "SELL" : "OTHER");
    LOG_ACTION_DEBUG("OrderType = " + IntegerToString(type) + " [" + typeLabel + "]");

   double minProfit = PipsToPrice(0.1, OrderSymbol());
    double bePrice = CalculateTrueBEPrice(ticket);
    double offset  = PipsToPrice(SL_BEOffsetPips);
    double newSL;

   if (type == OP_BUY)
   {
       newSL = bePrice + offset;
       newSL = MathMax(newSL, entryPrice + minProfit);
       LOG_ACTION_DEBUG("OP_BUY: adjusted newSL = " + DoubleToString(newSL, Digits));
   }
   else if (type == OP_SELL)
   {
       newSL = bePrice - offset;
       newSL = MathMin(newSL, entryPrice - minProfit);
       LOG_ACTION_DEBUG("OP_SELL: adjusted newSL = " + DoubleToString(newSL, Digits));
   }
    else
    {
        LOG_ACTION_ERROR("Unsupported OrderType = " + IntegerToString(type));
        LOG_ACTION_DEBUG("[EXIT] MoveSLToBEForTicket(): result = false (invalid type)");
        return false;
    }

    LOG_ACTION_DEBUG("entryPrice = " + DoubleToString(entryPrice, Digits));
    LOG_ACTION_DEBUG("bePrice    = " + DoubleToString(bePrice, Digits));
    LOG_ACTION_DEBUG("offset     = " + DoubleToString(offset, Digits));
    LOG_ACTION_DEBUG("newSL      = " + DoubleToString(newSL, Digits));

    // ✅ ② BEトレーリング：SLが既にある場合でも「より有利方向」なら更新
    if (hasSL)
    {
        bool isImprovement = (type == OP_BUY && newSL > currentSL) ||
                             (type == OP_SELL && newSL < currentSL);

        if (!isImprovement)
        {
            LOG_ACTION_INFO("Current SL is already better or equal. Skip BE move.");
            LOG_ACTION_DEBUG("[EXIT] MoveSLToBEForTicket(): result = false (no improvement)");
            return false;
        }
    }

    newSL = NormalizeDouble(newSL, Digits);

    double minDistance  = MarketInfo(OrderSymbol(), MODE_STOPLEVEL) * Point;
    double currentPrice = (type == OP_BUY) ? Bid : Ask;

    LOG_ACTION_DEBUG("currentPrice = " + DoubleToString(currentPrice, Digits));
    LOG_ACTION_DEBUG("minDistance  = " + DoubleToString(minDistance, Digits));

    if ((type == OP_BUY  && newSL >= currentPrice - minDistance) ||
        (type == OP_SELL && newSL <= currentPrice + minDistance))
    {
        LOG_ACTION_ERROR("Invalid SL: too close or in wrong direction");
        LOG_ACTION_DEBUG("newSL        = " + DoubleToString(newSL, Digits));
        LOG_ACTION_DEBUG("currentPrice = " + DoubleToString(currentPrice, Digits));
        LOG_ACTION_DEBUG("minDistance  = " + DoubleToString(minDistance, Digits));
        LOG_ACTION_DEBUG("[EXIT] MoveSLToBEForTicket(): result = false (SL invalid)");
        return false;
    }

    bool modified = OrderModify(ticket, OrderOpenPrice(), newSL, OrderTakeProfit(), 0, clrAqua);

    if (modified)
        LOG_ACTION_INFO("✅ SL moved to BE+offset: newSL = " + DoubleToString(newSL, Digits));
    else
        LOG_ACTION_ERROR("❌ OrderModify failed: " + GetLastError());

    LOG_ACTION_DEBUG("[EXIT] MoveSLToBEForTicket(): result = " + (modified ? "true" : "false"));
    return modified;
}

double CBEExecutor::CalculateTrueBEPriceWithSlippage(int ticket, double slippagePips)
{
    LOG_ACTION_DEBUG("[ENTER] CalculateTrueBEPriceWithSlippage(): ticket = " + IntegerToString(ticket));

    if (!OrderSelect(ticket, SELECT_BY_TICKET))
    {
        m_lastError = "OrderSelect failed";
        LOG_ACTION_ERROR("OrderSelect failed in CalculateTrueBEPriceWithSlippage");
        LOG_ACTION_DEBUG("[EXIT] CalculateTrueBEPriceWithSlippage(): result = 0.0");
        return 0.0;
    }

    double entryPrice = OrderOpenPrice();
    double lotSize    = OrderLots();
    LOG_ACTION_DEBUG("  entryPrice = " + DoubleToString(entryPrice, Digits));
    LOG_ACTION_DEBUG("  lotSize    = " + DoubleToString(lotSize, 2));

    if (lotSize <= 0.0)
    {
        LOG_ACTION_ERROR("Lot size is zero or invalid. Use entryPrice as fallback.");
        LOG_ACTION_DEBUG("[EXIT] CalculateTrueBEPriceWithSlippage(): result = entryPrice");
        return entryPrice;
    }

    double pipValue      = MarketInfo(OrderSymbol(), MODE_TICKVALUE);
    if (pipValue <= 0.0)
    {
        LOG_ACTION_ERROR("Invalid pipValue (MODE_TICKVALUE) = " + DoubleToString(pipValue, 3));
        LOG_ACTION_DEBUG("[EXIT] CalculateTrueBEPriceWithSlippage(): result = entryPrice");
        return entryPrice;
    }

    // ==== 各コスト構成要素（すべて price単位に変換） ====
    double spreadPrice       = MarketInfo(OrderSymbol(), MODE_SPREAD) * MarketInfo(OrderSymbol(), MODE_POINT);
    double slippagePrice     = PipsToPrice(slippagePips, OrderSymbol());

    double commissionJPY     = GetCommissionInAccountCurrency(lotSize);
    double commissionPips    = commissionJPY / pipValue;
    double commissionPrice   = PipsToPrice(commissionPips, OrderSymbol());

    double swapJPY           = OrderSwap();
    double swapPips          = swapJPY / pipValue;
    double swapPrice         = PipsToPrice(swapPips, OrderSymbol());

    double offsetPrice       = PipsToPrice(SL_BEOffsetPips, OrderSymbol());

    // ==== 総コスト（BUY/SELLで方向を変える） ====
    double totalCost;
    int orderType = OrderType();

    if (orderType == OP_BUY)
        totalCost = spreadPrice + commissionPrice + slippagePrice - swapPrice + offsetPrice;
    else if (orderType == OP_SELL)
        totalCost = spreadPrice + commissionPrice + slippagePrice + swapPrice + offsetPrice;
    else
    {
        LOG_ACTION_ERROR("Unsupported OrderType: " + IntegerToString(orderType));
        LOG_ACTION_DEBUG("[EXIT] CalculateTrueBEPriceWithSlippage(): result = entryPrice");
        return entryPrice;
    }

    // ==== ログ出力 ====
    LOG_ACTION_DEBUG("  spreadPrice      = " + DoubleToString(spreadPrice, Digits));
    LOG_ACTION_DEBUG("  slippagePrice    = " + DoubleToString(slippagePrice, Digits));
    LOG_ACTION_DEBUG("  commissionJPY    = " + DoubleToString(commissionJPY, 2));
    LOG_ACTION_DEBUG("  commissionPips   = " + DoubleToString(commissionPips, 2));
    LOG_ACTION_DEBUG("  commissionPrice  = " + DoubleToString(commissionPrice, Digits));
    LOG_ACTION_DEBUG("  swapJPY          = " + DoubleToString(swapJPY, 2));
    LOG_ACTION_DEBUG("  swapPips         = " + DoubleToString(swapPips, 2));
    LOG_ACTION_DEBUG("  swapPrice        = " + DoubleToString(swapPrice, Digits));
    LOG_ACTION_DEBUG("  offsetPrice      = " + DoubleToString(offsetPrice, Digits));
    LOG_ACTION_DEBUG("  totalCost        = " + DoubleToString(totalCost, Digits));

    // ==== BE価格算出 ====
    double bePrice = (orderType == OP_BUY)
                     ? entryPrice + totalCost
                     : entryPrice - totalCost;

    if (MathAbs(bePrice) < 1.0 || MathAbs(bePrice) > 1000.0)
    {
        LOG_ACTION_ERROR("Abnormal BE price detected: " + DoubleToString(bePrice, Digits));
        LOG_ACTION_DEBUG("[EXIT] CalculateTrueBEPriceWithSlippage(): result = entryPrice (fallback)");
        return entryPrice;
    }

    LOG_ACTION_DEBUG("Calculated BE with slippage = " + DoubleToString(bePrice, Digits));
    LOG_ACTION_DEBUG("[EXIT] CalculateTrueBEPriceWithSlippage(): result = " + DoubleToString(bePrice, Digits));
    return bePrice;
}


double CBEExecutor::CalculateTrueBEPrice(int ticket)
{
    LOG_ACTION_DEBUG("[ENTER] CalculateTrueBEPrice(): ticket = " + IntegerToString(ticket));

    if (!OrderSelect(ticket, SELECT_BY_TICKET))
    {
        m_lastError = "OrderSelect failed";
        LOG_ACTION_ERROR("OrderSelect failed in CalculateTrueBEPrice");
        LOG_ACTION_DEBUG("[EXIT] CalculateTrueBEPrice(): result = 0.0");
        return 0.0;
    }

    // 外部設定から取得（pips単位）
    double slippagePips = SL_BE_SlippagePips;

    double be = CalculateTrueBEPriceWithSlippage(ticket, slippagePips);
    LOG_ACTION_DEBUG("[EXIT] CalculateTrueBEPrice(): result = " + DoubleToString(be, Digits));
    return be;
}


double CBEExecutor::CalculateOffsetBEPrice(int ticket, double offsetPips)
{
    LOG_ACTION_DEBUG("[ENTER] CalculateOffsetBEPrice(): ticket = " + IntegerToString(ticket));

    double baseBE = CalculateTrueBEPrice(ticket);
    double offset = PipsToPrice(offsetPips, Symbol());

    double result;
    if (OrderType() == OP_BUY)
        result = baseBE + offset;
    else if (OrderType() == OP_SELL)
        result = baseBE - offset;
    else
        result = baseBE;

    LOG_ACTION_DEBUG("[EXIT] CalculateOffsetBEPrice(): result = " + DoubleToString(result, Digits));
    return result;
}

#endif // __CBEEXECUTOR__
