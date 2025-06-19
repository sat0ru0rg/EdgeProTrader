//+------------------------------------------------------------------+
//| CMockBEPriceCalculator                                           |
//| Implements : IBEPriceCalculator                                  |
//| Purpose    : モック用建値計算クラス（BUY/SELL方向対応）            |
//+------------------------------------------------------------------+
#ifndef __CMOCK_BEPRICE_CALCULATOR_MQH__
#define __CMOCK_BEPRICE_CALCULATOR_MQH__

#include <03_Interface/IBEPriceCalculator.mqh>
#include <01_Config/EPT_EnvConfig.mqh>

#define __CLASS__ "CMockBEPriceCalculator"

class CMockBEPriceCalculator : public IBEPriceCalculator
{
private:
   int m_type;          // OP_BUY or OP_SELL
   double m_entry;      // モック用のエントリー価格

public:
   // 明示的にポジションを設定
   void SetMockOrder(int type, double entryPrice)
   {
      m_type  = type;
      m_entry = entryPrice;

      LOG_ACTION_INFO_C("SetMockOrder: type=" + OrderTypeToString(type) +
                        ", entry=" + DoubleToString(entryPrice, Digits));
   }

   double CalculateTrueBEPrice(int ticket)
   {
      double result = (m_type == OP_BUY)
                      ? m_entry + 1 * Point
                      : m_entry - 1 * Point;

      LOG_ACTION_INFO_C("CalculateTrueBEPrice: ticket=" + IntegerToString(ticket) +
                        ", type=" + OrderTypeToString(m_type) +
                        ", entry=" + DoubleToString(m_entry, Digits) +
                        ", result=" + DoubleToString(result, Digits));
      return result;
   }

   double CalculateTrueBEPriceWithSlippage(int ticket, double slippagePips)
   {
      double base = CalculateTrueBEPrice(ticket);
      double offset = slippagePips * Point;

      double result = (m_type == OP_BUY)
                      ? base + offset
                      : base - offset;

      LOG_ACTION_INFO_C("CalculateTrueBEPriceWithSlippage: ticket=" + IntegerToString(ticket) +
                        ", slippage=" + DoubleToString(slippagePips, 1) +
                        ", offset=" + DoubleToString(offset, Digits) +
                        ", result=" + DoubleToString(result, Digits));
      return result;
   }

private:
   string OrderTypeToString(int type)
   {
      switch (type)
      {
         case OP_BUY:  return "BUY";
         case OP_SELL: return "SELL";
         default:      return "UNKNOWN";
      }
   }
};

#endif
