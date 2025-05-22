//+------------------------------------------------------------------+
//| Test_CPanelState_AllCases.mq4                                    |
//| 状態遷移ロジックを16通りの条件組み合わせで網羅検証             |
//+------------------------------------------------------------------+
#include <Config/EPT_EnvConfig.mqh>
#include <Common/CommonDefs.mqh>
#include <Logic/CPositionModel.mqh>
#include <Logic/CPanelStateManager.mqh>

CPositionModel posModel;
CPanelStateManager stateManager;

struct TestCase
{
    bool slVisible;
    bool hasPosition;
    bool beLine;
    bool beCondition;
    string expected;
};

TestCase cases[] = {
    {false, false, false, false, "Idle"},
    {false, false, false, true , "Idle"},
    {false, false, true , false, "Idle"},
    {false, false, true , true , "Idle"},
    {true , false, false, false, "ReadyToEntry"},
    {true , false, false, true , "ReadyToEntry"},
    {true , false, true , false, "ReadyToEntry"},
    {true , false, true , true , "ReadyToEntry"},
    {false, true , false, false, "Idle"},
    {false, true , false, true , "Idle"},
    {false, true , true , false, "Idle"},
    {false, true , true , true , "Idle"},
    {true , true , false, false, "PositionOpen"},
    {true , true , false, true , "PositionOpen"},
    {true , true , true , false, "PositionOpen"},
    {true , true , true , true , "BEAvailable"}
};

int OnInit()
{
    LOG_TEST_INFO("=== [16通り状態遷移テスト開始] ===");

    posModel.enableMock(true);
    stateManager.setPositionModel(posModel);

    for (int i = 0; i < ArraySize(cases); i++)
    {
        // 条件セット
        stateManager.setSLVisible(cases[i].slVisible);
        stateManager.setBELineVisible(cases[i].beLine);
        posModel.setMockPosition(cases[i].hasPosition);
        posModel.setMockBECondition(cases[i].beCondition);

        // 状態更新
        stateManager.updateState();

        string actual = stateManager.getCurrentState();
        string expected = cases[i].expected;

        if (actual == expected)
        {
            LOG_TEST_INFO("Case#" + IntegerToString(i+1) +
                          " ✅ Passed → state=" + actual);
        }
        else
        {
            LOG_TEST_ERROR("Case#" + IntegerToString(i+1) +
                           " ❌ Failed → actual=" + actual +
                           " / expected=" + expected);
        }
    }

    LOG_TEST_INFO("=== [テスト終了] ===");
    return INIT_SUCCEEDED;
}

void OnTick() {}
