//===========================
// TradeExecutorTest.mqh
//===========================

#ifndef __TRADE_EXECUTOR_TEST__
#define __TRADE_EXECUTOR_TEST__

#include <Trade/TradeExecutor.mqh>

void PrintTestResult(string label, bool result)
{
    Print(label + " : " + (result ? "[PASS]" : "[FAIL]"));
}

void RunTradeExecutorTest()
{
    TradeExecutor exec(0.1, 2.0);

    Print("===== TradeExecutor 単体テスト開始 =====");

    // --- BUYテスト ---
    bool buyResult = exec.Buy(
        Symbol(),   // symbol
        0.1,        // lot
        0,          // price（= 0で自動取得）
        0,          // SL
        0,          // TP
        3,          // slippage
        12345,      // magic
        clrGreen    // color
    );
    PrintTestResult("Buy() 正常動作確認", buyResult);

    // --- SELLテスト ---
    bool sellResult = exec.Sell(
        Symbol(),   // symbol
        0.1,        // lot
        0,          // price
        0,          // SL
        0,          // TP
        3,          // slippage
        12345,      // magic
        clrRed      // color
    );
    PrintTestResult("Sell() 正常動作確認", sellResult);

    Print("===== TradeExecutor 単体テスト終了 =====");
}

#endif // __TRADE_EXECUTOR_TEST__
