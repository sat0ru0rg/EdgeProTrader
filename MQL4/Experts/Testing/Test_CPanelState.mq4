#include <Logic/CPanelState.mqh>

int OnInit()
{
    Print("=== CPanelState Test Start ===");

    Test_Equals();
    Test_FromString();
    Test_FromEnum();

    Print("=== CPanelState Test End ===");
    return INIT_SUCCEEDED;
}

//--------------------------------------------------
// 状態比較（equals）テスト
//--------------------------------------------------
void Test_Equals()
{
    CPanelState* s1 = CPanelState::getIdle();
    CPanelState* s2 = CPanelState::getIdle();
    CPanelState* s3 = CPanelState::getReadyToEntry();

    if (s1.equals(s2))
        Print("[PASS] Equals() : Idle == Idle");
    else
        Print("[FAIL] Equals() : Idle != Idle");

    if (!s1.equals(s3))
        Print("[PASS] Equals() : Idle != ReadyToEntry");
    else
        Print("[FAIL] Equals() : Idle == ReadyToEntry");
}

//--------------------------------------------------
// 明示的な状態名から生成（大文字一致でチェック）
//--------------------------------------------------
void Test_FromString()
{
    CPanelState* s1 = CPanelState::fromString("Idle");
    if (s1.equals(CPanelState::getIdle()))
        Print("[PASS] fromString('Idle') == Idle");
    else
        Print("[FAIL] fromString('Idle') != Idle");

    CPanelState* s2 = CPanelState::fromString("BEAvailable");
    if (s2.equals(CPanelState::getBEAvailable()))
        Print("[PASS] fromString('BEAvailable') == BEAvailable");
    else
        Print("[FAIL] fromString('BEAvailable') != BEAvailable");

    CPanelState* s3 = CPanelState::fromString("invalidName");
    if (s3.equals(CPanelState::getInvalid()))
        Print("[PASS] fromString('invalidName') fallback == Invalid");
    else
        Print("[FAIL] fromString('invalidName') fallback != Invalid");
        
    Print("DEBUG: fromString('BEAvailable') = ", CPanelState::fromString("BEAvailable").getName());
    Print("DEBUG: getBEAvailable() = ", CPanelState::getBEAvailable().getName());

}

//--------------------------------------------------
// enum値から生成
//--------------------------------------------------
void Test_FromEnum()
{
    if (CPanelState::fromEnum(0).equals(CPanelState::getIdle()))
        Print("[PASS] fromEnum(0) == Idle");
    else
        Print("[FAIL] fromEnum(0) != Idle");

    if (CPanelState::fromEnum(3).equals(CPanelState::getBEAvailable()))
        Print("[PASS] fromEnum(3) == BEAvailable");
    else
        Print("[FAIL] fromEnum(3) != BEAvailable");

    if (CPanelState::fromEnum(999).equals(CPanelState::getInvalid()))
        Print("[PASS] fromEnum(999) fallback == Invalid");
    else
        Print("[FAIL] fromEnum(999) fallback != Invalid");
}
