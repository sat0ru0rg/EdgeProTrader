//+------------------------------------------------------------------+
//| Test_CMockBEPriceSimulator.mq4                                  |
//| 単体テスト：CMockBEPriceSimulator（BUY/SELL方向の確認）           |
//+------------------------------------------------------------------+
#property strict

#include <99_TestHelper/CMockBEPriceSimulator.mqh>
#include <01_Config/EPT_EnvConfig.mqh>  // ASSERTマクロ

void OnStart()
{
   Print("===== Test Start: CMockBEPriceSimulator =====");

   CMockBEPriceSimulator sim;

   double entry = 1.2345;
   double offset = 1.0;
   double expectedBUY  = entry + offset * Point;
   double expectedSELL = entry - offset * Point;

   // --- BUY方向のBE計算
   double resultBUY = sim.CalculateBEPrice(entry, offset, BUY);
   ASSERT_TRUE(MathAbs(resultBUY - expectedBUY) < Point / 10,
               "BUY direction → BE = entry + offset");

   // --- SELL方向のBE計算
   double resultSELL = sim.CalculateBEPrice(entry, offset, SELL);
   ASSERT_TRUE(MathAbs(resultSELL - expectedSELL) < Point / 10,
               "SELL direction → BE = entry - offset");

   Print("===== Test End: CMockBEPriceSimulator =====");
}
