#include <Common/CommonDefs.mqh>
#include <Trade/CEntryExecutor.mqh>


// EA用の最低限の構成
int OnInit()
{
   // テスト関数を呼び出すだけでも可
   RunTest();
   return(INIT_SUCCEEDED);
}

void RunTest()
{
   // ↓ 今の OnStart() の中身を丸ごとここにコピーしてください
   DebugPrint("==== CEntryExecutor 総合テスト START ====");

   string symbol = "BTCUSD";     // 仮想通貨ペア（取引可能なものに変更可）
   double testVolume = 0.1;      // 最小Lotに合わせて調整（BTC系は0.01かも）
   int magic = 20250510;

   CEntryExecutor exec;
   exec.SetSymbol(symbol);
   exec.SetVolume(testVolume);
   exec.SetSlippage(20);
   exec.SetStopLoss(0);          // テスト用にTP/SLなし
   exec.SetTakeProfit(0);
   exec.SetComment("TestOrder");
   exec.SetMagic(magic);

   // --- BUYテスト ---
   DebugPrint("▶ BUYテスト実行中");
   bool buyResult = exec.ExecuteMarketOrder(OP_BUY);
   int buyTicket = -1;

   if (!buyResult)
   {
      Print("❌ BUY失敗: ", exec.GetLastErrorMessage());
   }
   else
   {
      DebugPrint("✅ BUY成功");
      buyTicket = GetLastOpenedTicket(symbol, OP_BUY, magic);
   }

   Sleep(2000); // MT4サーバー反映待ち

   // --- SELLテスト ---
   DebugPrint("▶ SELLテスト実行中");
   bool sellResult = exec.ExecuteMarketOrder(OP_SELL);
   int sellTicket = -1;

   if (!sellResult)
   {
      Print("❌ SELL失敗: ", exec.GetLastErrorMessage());
   }
   else
   {
      DebugPrint("✅ SELL成功");
      sellTicket = GetLastOpenedTicket(symbol, OP_SELL, magic);
   }

   Sleep(2000);

   // --- ClosePartialテスト（BUYポジションを半分決済） ---
   if (buyTicket > 0)
   {
      DebugPrint("▶ BUY部分決済テスト実行中");
      bool closeResult = exec.ClosePartial(buyTicket, testVolume / 2.0);
      if (!closeResult)
         Print("❌ ClosePartial失敗: ", exec.GetLastErrorMessage());
      else
         DebugPrint("✅ ClosePartial成功");
   }

   DebugPrint("==== CEntryExecutor 総合テスト END ====");
}

// 🔧 補助関数：指定チケットを取得（最新の注文）
int GetLastOpenedTicket(string symbol, int type, int magic)
{
   for (int i = OrdersTotal() - 1; i >= 0; i--)
   {
      if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES))
      {
         if (OrderSymbol() == symbol &&
             OrderType() == type &&
             OrderMagicNumber() == magic)
         {
            return OrderTicket();
         }
      }
   }
   return -1;
}
