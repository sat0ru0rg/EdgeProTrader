//+------------------------------------------------------------------+
//| CMockEntryValidator                                              |
//| Implements : IEntryValidator                                     |
//| Purpose    : スプレッドと時間帯チェックのモック                  |
//| ログ規約   : [ACTION] + ASSERT付き                                |
//+------------------------------------------------------------------+
#ifndef __CMOCK_ENTRY_VALIDATOR_MQH__
#define __CMOCK_ENTRY_VALIDATOR_MQH__

#include <03_Interface/IEntryValidator.mqh>
#include <01_Config/EPT_Config.mqh>  // ASSERTマクロ

#define __CLASS__ "CMockEntryValidator"

class CMockEntryValidator : public IEntryValidator
{
private:
   double m_maxSpread;
   datetime m_tradeStart;
   datetime m_tradeEnd;

public:
   CMockEntryValidator()
   {
      m_maxSpread = 1.5;  // デフォルトスプレッド上限
      m_tradeStart = StrToTime("09:00");
      m_tradeEnd   = StrToTime("17:00");
   }

   /// 許容スプレッド以内か？
   bool IsSpreadAcceptable(double spread)
   {
      LOG_ACTION_INFO_C("IsSpreadAcceptable called: spread=" + DoubleToString(spread, 1));
      return (spread <= m_maxSpread);
   }

   /// トレード時間帯内か？
   bool IsTradableTime(datetime now)
   {
      LOG_ACTION_INFO_C("IsTradableTime called: time=" + TimeToString(now, TIME_MINUTES));
      datetime h = StringToTime(TimeToString(now, TIME_MINUTES));  // 日付無視
      return (h >= m_tradeStart && h <= m_tradeEnd);
   }

   /// 総合チェック（スプレッドと時間）
   bool IsEntryPermitted(datetime now, double spread)
   {
      bool s = IsSpreadAcceptable(spread);
      bool t = IsTradableTime(now);
      bool ok = (s && t);
      LOG_ACTION_INFO_C("IsEntryPermitted: result=" + (ok ? "true" : "false"));
      return ok;
   }
};

#endif
