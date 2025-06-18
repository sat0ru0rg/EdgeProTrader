//+------------------------------------------------------------------+
//| IPendingOrderCanceller                                           |
//| Interface Type : [ポリモーフィズム抽象I/F]                        |
//| Implemented by : CPendingOrderManager（予定）                   |
//| Used by        : ExitController（予定）                          |
//| 概要             : 時間経過・価格条件などによる予約注文の自動キャンセルを担当 |
//+------------------------------------------------------------------+
#ifndef __IPENDING_ORDER_CANCELLER_MQH__
#define __IPENDING_ORDER_CANCELLER_MQH__

class IPendingOrderCanceller
{
public:
   /// 指定チケットの予約注文をキャンセル（条件問わず明示的に）
   virtual bool CancelOrder(int ticket) = 0;

   /// 一定条件（期限超過、価格到達失敗）で自動キャンセルを実行
   virtual bool CheckAndCancelPendingOrders() = 0;

   /// 最後のエラーメッセージを取得
   virtual string GetLastErrorMessage() = 0;
};

#endif
