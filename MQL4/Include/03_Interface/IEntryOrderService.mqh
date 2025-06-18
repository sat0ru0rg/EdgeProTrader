//+------------------------------------------------------------------+
//| IEntryOrderService                                               |
//| Interface Type : [Mock切替専用]                                  |
//| Implemented by : CEntryOrderService / CMockEntryOrderService     |
//| Used by        : CEntryExecutor                                  |
//| 概要             : 成行エントリーと部分決済の注文処理を抽象化       |
//+------------------------------------------------------------------+
#ifndef __IENTRY_ORDER_SERVICE_MQH__
#define __IENTRY_ORDER_SERVICE_MQH__

class IEntryOrderService
{
public:
   // 成行注文（Buy / Sell）を送信する
   virtual bool SendOrder(int orderType, double price, double lots, int slippage, double stopLoss, double takeProfit, string comment, int magic) = 0;

   // 指定ロット分を部分決済する
   virtual bool ClosePartial(int ticket, double lots, int slippage) = 0;

   // 最後のエラーメッセージを取得
   virtual string GetLastErrorMessage() = 0;
};

#endif
