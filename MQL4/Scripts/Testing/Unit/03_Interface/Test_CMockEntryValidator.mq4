//+------------------------------------------------------------------+
//| Test_CMockEntryValidator.mq4                                    |
//| 単体テスト：CMockEntryValidator                                  |
//+------------------------------------------------------------------+
#property strict

#include <99_TestHelper/CMockEntryValidator.mqh>
#include <01_Config/EPT_EnvConfig.mqh>  // ASSERTマクロ

void OnStart()
{
   Print("===== Test Start: CMockEntryValidator =====");
   CMockEntryValidator validator;

   // --- スプレッドテスト
   ASSERT_TRUE(validator.IsSpreadAcceptable(1.2),  "Spread=1.2 → 許容内");
   ASSERT_TRUE(validator.IsSpreadAcceptable(0.5),  "Spread=0.5 → 許容内");
   ASSERT_FALSE(validator.IsSpreadAcceptable(2.0), "Spread=2.0 → 許容外");

   // --- 時間テスト（09:30はOK、08:59はNG）
   datetime t_ok  = StringToTime(TimeToString(TimeCurrent(), TIME_DATE) + " 09:30");
   datetime t_ng1 = StringToTime(TimeToString(TimeCurrent(), TIME_DATE) + " 08:59");
   datetime t_ng2 = StringToTime(TimeToString(TimeCurrent(), TIME_DATE) + " 17:01");

   ASSERT_TRUE(validator.IsTradableTime(t_ok),     "09:30 → 時間内");
   ASSERT_FALSE(validator.IsTradableTime(t_ng1),   "08:59 → 時間外（前）");
   ASSERT_FALSE(validator.IsTradableTime(t_ng2),   "17:01 → 時間外（後）");

   // --- 総合チェック
   ASSERT_TRUE(validator.IsEntryPermitted(t_ok, 1.2),   "OK: 時間+スプレッド");
   ASSERT_FALSE(validator.IsEntryPermitted(t_ok, 2.0),  "NG: 時間OKでもスプレッドNG");
   ASSERT_FALSE(validator.IsEntryPermitted(t_ng1, 1.2), "NG: スプレッドOKでも時間NG");

   Print("===== Test End: CMockEntryValidator =====");
}
