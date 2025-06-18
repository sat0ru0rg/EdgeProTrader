//+------------------------------------------------------------------+
//| CMockEntryOrderService                                           |
//| Implements : IEntryOrderService                                  |
//| Purpose    : 成行注文・決済処理のモック（MQL4制約に対応）            |
//| ログ規約   : ACTIONカテゴリに準拠（INFO / ERROR）                  |
//| 特記事項   : ロット数はMQL4では制御対象。部分決済はUIで禁止前提     |
//+------------------------------------------------------------------+
#ifndef __CMOCK_ENTRY_ORDER_SERVICE_MQH__
#define __CMOCK_ENTRY_ORDER_SERVICE_MQH__

#include <03_Interface/IEntryOrderService.mqh>

#define __CLASS__ "CMockEntryOrderService"

class CMockEntryOrderService : public IEntryOrderService
{
private:
   string m_lastError;

public:
   CMockEntryOrderService() { m_lastError = ""; }

   /// 成行注文モック：常に成功（ログ出力あり）
   bool SendOrder(int orderType, double price, double lots, int slippage, double stopLoss, double takeProfit, string comment, int magic)
   {
      LOG_ACTION_INFO_C("SendOrder called: type=" + IntegerToString(orderType) +
                        ", price=" + DoubleToString(price, 5) +
                        ", lots=" + DoubleToString(lots, 2) +
                        ", slippage=" + IntegerToString(slippage));
      return true;
   }

   /// クローズ処理（MQL4では部分決済は非対応 → 全決済処理に集約）
   bool ClosePartial(int ticket, double lots, int slippage)
   {
      double orderLots = 1.00; // ※ 本番では OrderLots() などで取得

      if (lots <= 0.0)
      {
         LOG_ACTION_ERROR_C("Invalid lots specified: " + DoubleToString(lots, 2) +
                            ". Must be positive. Ignoring call.");
         return false;
      }

      if (lots > orderLots)
      {
         LOG_ACTION_ERROR_C("Requested lots (" + DoubleToString(lots, 2) +
                            ") exceed position lots (" + DoubleToString(orderLots, 2) +
                            "). Interpreted as full close.");
         lots = orderLots;
      }

      if (lots > 0.0 && lots < orderLots)
      {
         LOG_ACTION_ERROR_C("Partial close detected (lots=" + DoubleToString(lots, 2) +
                            "). MQL4 does not support partial close. Proceeding with full-close simulation.");
      }

      LOG_ACTION_INFO_C("Executing full-close. ticket=" + IntegerToString(ticket));
      return true;
   }

   /// 最後のエラーメッセージ（常に空）
   string GetLastErrorMessage()
   {
      return m_lastError;
   }
};

#endif
