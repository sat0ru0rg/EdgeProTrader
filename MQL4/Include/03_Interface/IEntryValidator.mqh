//+------------------------------------------------------------------+
//| IEntryValidator                                                  |
//| Interface Type : [ポリモーフィズム抽象I/F]                        |
//| Implemented by : CEntryValidator                                 |
//| Used by        : CEntryController, CPanelStateManager            |
//| 概要             : エントリー前にスプレッドや時間帯などをチェックするI/F |
//+------------------------------------------------------------------+
#ifndef __IENTRY_VALIDATOR_MQH__
#define __IENTRY_VALIDATOR_MQH__

class IEntryValidator
{
public:
   /// スプレッドが許容範囲かどうかを判定する
   virtual bool IsSpreadAcceptable(double spread) = 0;

   /// エントリー可能な時間帯であるかを判定する
   virtual bool IsTradableTime(datetime now) = 0;

   /// 他条件（将来拡張用）すべて満たしているかを統合チェック
   virtual bool IsEntryPermitted(datetime now, double spread) = 0;
};

#endif
