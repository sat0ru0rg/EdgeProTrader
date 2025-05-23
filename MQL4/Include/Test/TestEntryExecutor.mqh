#ifndef __CENTRY_EXECUTOR_TEST__
#define __CENTRY_EXECUTOR_TEST__

#include <Common/CommonDefs.mqh>
#include <Trade/CEntryExecutor.mqh>

// 単純なテスト関数：読み込みとSendOrder()の仮呼び出しを行う
void RunEntryExecutorTest()
{
    DebugPrint("=== RunEntryExecutorTest START ===");

   CRiskManager riskManager;
   CEntryValidator validator;
   CPriceCalculator priceCalc;

   CEntryExecutor executor(&riskManager, &validator, &priceCalc);  // ← これで認識されればOK

    executor.SetSymbol(Symbol());
    executor.SetVolume(0.1);
    executor.SetStopLoss(Ask - 300 * Point);
    executor.SetTakeProfit(Ask + 600 * Point);
    executor.SetSlippage(3);
    executor.SetComment("TestOrder");

    bool result = executor.SendMarketOrder(OP_BUY);
    DebugPrint("SendMarketOrder result: " + (result ? "true" : "false"));

    DebugPrint("=== RunTestEntryExecutor END ===");
}
#endif  // __CENTRY_EXECUTOR_TEST__
