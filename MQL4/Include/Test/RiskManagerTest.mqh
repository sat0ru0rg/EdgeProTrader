#ifndef __RISK_MANAGER_TEST__
#define __RISK_MANAGER_TEST__

#include <Logic\RiskManager.mqh>

// テスト結果を出力
void PrintTestResult(string testName, bool result) {
    string status = result ? "[PASS] " : "[FAIL] ";
    Print(status + testName);
}

// RiskManager クラスの動作確認
void RunRiskManagerTest() {
    Print("---- RiskManager 単体テスト開始 ----");

    // ✅ ケース1：FixedLotがリスク内 → そのまま使用される
    RiskManager rm1(1.0, 2.0);  // 固定1.0ロット, リスク2%
    double lot1 = rm1.Calculate(30); // SL30pips
    Print("  -> 計算結果 lot1 = ", DoubleToString(lot1, 2));
    PrintTestResult("FixedLot使用（リスク内）", lot1 == 1.0);

    // ✅ ケース2：FixedLotがリスク超過 → 自動補正される
    RiskManager rm2(5.0, 1.0);  // 固定5.0ロット, リスク1%
    double lot2 = rm2.Calculate(100); // SL100pips
    Print("  -> 計算結果 lot2 = ", DoubleToString(lot2, 2));
    PrintTestResult("RiskLimitLotに補正", lot2 < 5.0);

    // ✅ ケース3：極端なSLでロットが限界近くに
    RiskManager rm3(0.01, 100.0);  // リスク100%（極端）
    double lot3 = rm3.Calculate(1); // SL1pips
    Print("  -> 計算結果 lot3 = ", DoubleToString(lot3, 2));
    PrintTestResult("ロット極大化（理論上）", lot3 > 0.1);

    Print("---- RiskManager 単体テスト終了 ----");
}

#endif
