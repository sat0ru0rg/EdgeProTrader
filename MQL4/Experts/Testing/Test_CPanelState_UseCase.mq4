#include <Logic/EntryPanelController.mqh>

EntryPanelController controller;

void OnInit()
{
    LOG_TEST_INFO("==== Test_CPanelState_UseCase 開始 ====");
    controller.Initialize();
    RunTest_UC01();
    LOG_TEST_INFO("==== Test_CPanelState_UseCase 終了 ====");
}

//+------------------------------------------------------------------+
//| UC01: SL表示 → エントリー → クローズ                            |
//+------------------------------------------------------------------+
void RunTest_UC01()
{
    LOG_TEST_INFO("UC01: SL表示 → 成行エントリー → Close");

    // ① 初期状態 → SL表示
    controller.OnSLButtonClicked();
    AssertState("ReadyToEntry");

    // ② 成行エントリー
    controller.OnEntryButtonClicked();
    AssertState("PositionOpen");

    // ③ 成行決済
    controller.OnCloseButtonClicked();
    AssertState("Idle");

    LOG_TEST_INFO("UC01 終了");
}

//+------------------------------------------------------------------+
//| 状態確認用ユーティリティ                                        |
//+------------------------------------------------------------------+
void AssertState(string expected)
{
    string actual = Trim(controller.GetCurrentState());
    expected = Trim(expected);

    if (actual != expected)
        LOG_TEST_ERROR("状態不一致: 期待=" + expected + ", 実際=" + actual);
    else
        LOG_TEST_INFO("状態一致: " + actual);
}

string Trim(string str)
{
    int start = 0;
    int end = StringLen(str) - 1;

    while (start <= end && StringGetCharacter(str, start) <= ' ')
        start++;

    while (end >= start && StringGetCharacter(str, end) <= ' ')
        end--;

    return StringSubstr(str, start, end - start + 1);
}
