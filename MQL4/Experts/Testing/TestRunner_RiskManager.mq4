#include "..\..\Include\Test\RiskManagerTest.mqh"

int OnInit()
{
    RunRiskManagerTest(); // ← 単体テスト実行
    return INIT_SUCCEEDED;
}
