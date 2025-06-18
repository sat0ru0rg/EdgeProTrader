//+------------------------------------------------------------------+
//| IPendingOrderPlacer                                              |
//| Interface Type : [ポリモーフィズム抽象I/F]                        |
//| Implemented by : CPendingEntryExecutor（予定）                   |
//| Used by        : EntryController（PLAN戦略時）                   |
//| 概要             : BuyLimit / SellStop など予約注文の発注を行うI/F       |
//+------------------------------------------------------------------+
#ifndef __IPENDING_ORDER_PLACER_MQH__
#define __IPENDING_ORDER_PLACER_MQH__

class IPendingOrderPlacer
{
public:
   /// 指定パラメータで予約注文（BuyLimit / SellStopなど）を発注
   virtual bool PlacePendingOrder(int orderType, double price, double lots, double stopLoss, double takeProfit, datetime expiration, string comment, int magic) = 0;

   /// 最後のエラーメッセージを取得
   virtual string GetLastErrorMessage() = 0;
};

#endif
