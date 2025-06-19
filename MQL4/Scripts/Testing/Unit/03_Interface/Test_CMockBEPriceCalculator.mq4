//+------------------------------------------------------------------+
//| Test_CMockBEPriceCalculator.mq4                                 |
//| 単体テスト：CMockBEPriceCalculator（BUY/SELL 両方向対応）         |
//+------------------------------------------------------------------+
#property strict

#include <99_TestHelper/CMockBEPriceCalculator.mqh>
#include <01_Config/EPT_EnvConfig.mqh>  // ASSERTマクロ

void OnStart()
{
   Print("===== Test Start: CMockBEPriceCalculator =====");

   CMockBEPriceCalculator mock;
   int dummyTicket = 10001;

   // --- BUY テスト
   mock.SetMockOrder(OP_BUY, 1.2345);
   double expectedBuy = 1.2345 + 1.0 * Point;
   double actualBuy = mock.CalculateTrueBEPrice(dummyTicket);
   ASSERT_TRUE(MathAbs(actualBuy - expectedBuy) < Point / 10, "BUY → entry + offset");

   // --- SELL テスト
   mock.SetMockOrder(OP_SELL, 1.2345);
   double expectedSell = 1.2345 - 1.0 * Point;
   double actualSell = mock.CalculateTrueBEPrice(dummyTicket);
   ASSERT_TRUE(MathAbs(actualSell - expectedSell) < Point / 10, "SELL → entry - offset");

   Print("===== Test End: CMockBEPriceCalculator =====");
}
