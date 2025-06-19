//+------------------------------------------------------------------+
//| Test_CMockBEPriceCalculator.mq4                                 |
//| 単体テスト：CMockBEPriceCalculator                              |
//| 検証対象  ：インタフェース関数（CalculateTrueBEPrice など）      |
//+------------------------------------------------------------------+
#property strict

#include <99_TestHelper/CMockBEPriceCalculator.mqh>
#include <01_Config/EPT_EnvConfig.mqh>  // ASSERT & LOG

void OnStart()
{
   Print("===== Test Start: CMockBEPriceCalculator =====");

   CMockBEPriceCalculator mock;

   // --- ダミーエントリー価格と期待値
   double entryPrice = 1.23450;
   double offsetPips = 1.0;
   double expectedBE = entryPrice + offsetPips * Point;

   // --- インタフェース関数のテスト①：CalculateTrueBEPrice()
   double result1 = mock.CalculateTrueBEPrice(0);
   ASSERT_TRUE(MathAbs(result1 - expectedBE) < Point / 10,
               "CalculateTrueBEPrice() returns correct BE price");

   // --- インタフェース関数のテスト②：CalculateTrueBEPriceWithSlippage()
   double result2 = mock.CalculateTrueBEPriceWithSlippage(0, 0.5);
   double expectedBE_slip = entryPrice + (offsetPips + 0.5) * Point;
   ASSERT_TRUE(MathAbs(result2 - expectedBE_slip) < Point / 10,
               "CalculateTrueBEPriceWithSlippage() returns correct BE with slippage");

   Print("===== Test End: CMockBEPriceCalculator =====");
}
