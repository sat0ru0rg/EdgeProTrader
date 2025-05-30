#include <Common/CommonDefs.mqh>
#include <Logic/CBEPriceCalculator.mqh>  // ← クラス定義ファイルへのパス

CBEPriceCalculator beCalc;

int OnInit()
{
   LOG_TEST_INFO("[TEST] OnInit() called");
   RunTest();
   return INIT_SUCCEEDED;
}

void RunTest()
{
   LOG_TEST_INFO("[TEST] RunTest() begin");

   int ticket = GetTestTicket();

   if (ticket == -1)
   {
      LOG_TEST_ERROR("[TEST] No valid ticket found.");
      return;
   }

   LOG_TEST_INFO("[TEST] Testing ticket = " + IntegerToString(ticket));

   double bePrice = beCalc.CalculateTrueBEPrice(ticket);
   LOG_TEST_INFO("[TEST] BE price = " + DoubleToString(bePrice, Digits));

   double entryPrice = OrderOpenPrice();
   LOG_TEST_INFO("[TEST] Entry price = " + DoubleToString(entryPrice, Digits));
   LOG_TEST_INFO("[TEST] BE offset = " + DoubleToString(bePrice - entryPrice, Digits));

   LOG_TEST_INFO("[TEST] RunTest() end");
}

int GetTestTicket()
{
   for (int i = OrdersTotal() - 1; i >= 0; i--)
   {
      if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES))
      {
         if (OrderSymbol() == Symbol())  // 同一通貨ペア
            return OrderTicket();
      }
   }
   return -1;
}
