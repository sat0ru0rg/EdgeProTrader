//+------------------------------------------------------------------+
//| CPanelStateTest.mq4                                              |
//| CPanelStateManager の状態遷移検証用テストEA                      |
//+------------------------------------------------------------------+
#include <Config/EPT_EnvConfig.mqh>
#include <Common/CommonDefs.mqh>
#include <Logic/CPositionModel.mqh>
#include <Logic/CPanelStateManager.mqh>

CPositionModel posModel;
CPanelStateManager stateManager;

//+------------------------------------------------------------------+
int OnInit()
{
    LOG_TEST_INFO("=== [テスト開始] 状態遷移検証を開始します ===");

    // モック設定と注入
    posModel.enableMock(true);
    stateManager.setPositionModel(posModel);

    // ① 初期状態：SL OFF, ポジションなし → Idle
    posModel.setMockPosition(false);
    posModel.setMockBECondition(false);
    stateManager.setSLVisible(false);
    stateManager.setBELineVisible(false);
    stateManager.updateState();
    stateManager.logState();

    // ② SL表示 → ReadyToEntry
    stateManager.setSLVisible(true);
    stateManager.updateState();
    stateManager.logState();

    // ③ ポジション保有 → PositionOpen
    posModel.setMockPosition(true);
    stateManager.updateState();
    stateManager.logState();

    // ④ BEライン表示（条件未成立） → stay at PositionOpen
    stateManager.setBELineVisible(true);
    posModel.setMockBECondition(false);
    stateManager.updateState();
    stateManager.logState();

    // ⑤ BE条件成立 → BEAvailable
    posModel.setMockBECondition(true);
    stateManager.updateState();
    stateManager.logState();

    LOG_TEST_INFO("=== [テスト終了] 状態遷移検証完了 ===");

    return INIT_SUCCEEDED;
}

//+------------------------------------------------------------------+
void OnTick()
{
    // 状態変化なしでもログ確認用に使用可能（省略）
}
