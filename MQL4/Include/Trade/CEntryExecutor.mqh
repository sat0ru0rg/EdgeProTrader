//+------------------------------------------------------------------+
//| CEntryExecutor.mqh                                               |
//| - 成行エントリーおよび部分決済を行うExecutor                    |
//| - IMarketOrderExecutor を実装                                   |
//+------------------------------------------------------------------+

#ifndef __CENTRY_EXECUTOR__
#define __CENTRY_EXECUTOR__

#include <Common/CommonDefs.mqh>
#include <Trade/COrderExecutorBase.mqh>
#include <Trade/CExecutorInterfaces.mqh>

// class CEntryExecutor : public COrderExecutorBase, public IMarketOrderExecutor
// CExecutorInterfaces.mqh は単なる「役割のガイド」として維持
// MQL5ではここを正式な interface に再昇格させる
class CEntryExecutor : public COrderExecutorBase
{
public:
   CEntryExecutor() {}
   virtual ~CEntryExecutor() {}

   // 成行エントリー実行（OP_BUY / OP_SELL）
   bool ExecuteMarketOrder(int type)
   {
      DebugPrint("CEntryExecutor::ExecuteMarketOrder START");

      double price = (type == OP_BUY) ? MarketInfo(m_symbol, MODE_ASK)
                                      : MarketInfo(m_symbol, MODE_BID);

      int ticket = OrderSend(
         m_symbol,
         type,
         m_volume,
         price,
         m_slippage,
         m_stopLoss,
         m_takeProfit,
         m_comment,
         m_magic,
         m_expiration,
         clrBlue
      );

      if (ticket < 0)
      {
         m_lastError = "OrderSend failed: " + IntegerToString(GetLastError());
         DebugPrint(m_lastError);
         return false;
      }

      DebugPrint("CEntryExecutor::ExecuteMarketOrder success: ticket=" + IntegerToString(ticket));
      return true;
   }

   // 部分決済処理（ClosePartial）
   bool ClosePartial(int ticket, double lots)
   {
      DebugPrint("CEntryExecutor::ClosePartial START");

      if (!OrderSelect(ticket, SELECT_BY_TICKET))
      {
         m_lastError = "OrderSelect failed: " + IntegerToString(GetLastError());
         DebugPrint(m_lastError);
         return false;
      }

      double closePrice = (OrderType() == OP_BUY) ? MarketInfo(OrderSymbol(), MODE_BID)
                                                  : MarketInfo(OrderSymbol(), MODE_ASK);

      bool result = OrderClose(ticket, lots, closePrice, m_slippage, clrRed);

      if (!result)
      {
         m_lastError = "OrderClose failed: " + IntegerToString(GetLastError());
         DebugPrint(m_lastError);
         return false;
      }

      DebugPrint("CEntryExecutor::ClosePartial success");
      return true;
   }
};

#endif
