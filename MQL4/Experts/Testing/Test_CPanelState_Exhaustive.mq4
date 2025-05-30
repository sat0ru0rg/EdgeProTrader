//+------------------------------------------------------------------+
//| Test_CPanelState_Exhaustive.mq4                                  |
//| 総当たりテスト：3条件（SL表示 / ポジ保有 / BE成立）に対する状態判定検証 |
//+------------------------------------------------------------------+
#include <Test/TestBootstrap.mqh>          // MockConfig定義とSetMockConfig()含む
#include <Logic/CPanelStateManager.mqh>    // テスト対象：状態判定ロジック
#include <Common/CommonDefs.mqh>           // 状態コードの定義（STATE_〇〇）
#include <Logic/CPositionModel.mqh>
#include <Logic/CEntryValidator.mqh>
#include <Logic/CBEPriceCalculator.mqh>

//+------------------------------------------------------------------+
//| OnInitで8通りの入力条件をテスト                                  |
//| 各条件が仕様通りの状態コードに分類されるかを検証                 |
//+------------------------------------------------------------------+
int OnInit()
{
    // 各RunTestは：isSLShown, hasPosition, isBEConditionMet, 期待状態コード, ラベル
    RunTest(false, false, false, STATE_Idle,                     "000: 初期状態");
    RunTest(false, false, true,  STATE_Invalid_BEWithNoPosition, "001: ポジなしでBE成立 → Invalid");
    RunTest(false, true,  false, STATE_Invalid_MissingSL,        "010: ポジありSL非表示 → Invalid");
    RunTest(false, true,  true,  STATE_Invalid_MissingSL,        "011: SL非表示のままBE成立 → Invalid");
    RunTest(true,  false, false, STATE_ReadyToEntry,             "100: SL表示・発注準備");
    RunTest(true,  false, true,  STATE_Invalid_BEWithNoPosition, "101: BE成立だがポジなし → Invalid");
    RunTest(true,  true,  false, STATE_PositionOpen,             "110: 保有中・BE未成立");
    RunTest(true,  true,  true,  STATE_BEAvailable,              "111: BE到達状態");

    return INIT_SUCCEEDED;
}

//+------------------------------------------------------------------+
//| RunTest：1ケースの条件設定＆検証                                |
//| isSLShown         → 状態管理クラスに直接セット                 |
//| hasPosition       → MockConfig.hasPosition                      |
//| isBEConditionMet  → MockConfig.bePrice（0でfalse、>0でtrue）    |
//| 残りのMock値は常にtrueで固定（本テストでは影響しない）         |
//+------------------------------------------------------------------+
void RunTest(bool isSLShown, bool hasPosition, bool isBEConditionMet, int expectedState, string label)
{
    LOG_TEST_DEBUG("━━━━━━━━━━━━━━━━━━━━━━━");
    LOG_TEST_DEBUG("[START] RunTest: " + label);

    // 1. 条件構築
    bool isSpreadOK = true;
    bool isTradable = true;
    double bePrice = isBEConditionMet ? 1.234 : 0.0;

    LOG_TEST_DEBUG(StringFormat("入力条件: isSLShown=%s, hasPosition=%s, isBEConditionMet=%s",
        (isSLShown ? "true" : "false"),
        (hasPosition ? "true" : "false"),
        (isBEConditionMet ? "true" : "false")));

    MockConfig cfg;
    cfg.hasPosition = hasPosition;
    cfg.isSpreadOK = isSpreadOK;
    cfg.isTradable = isTradable;
    cfg.bePrice = bePrice;

    SetMockConfig(cfg);
    LOG_TEST_DEBUG("MockConfig 設定完了:");
    LOG_TEST_DEBUG("  hasPosition = " + (cfg.hasPosition ? "true" : "false"));
    LOG_TEST_DEBUG("  isSpreadOK  = " + (cfg.isSpreadOK ? "true" : "false"));
    LOG_TEST_DEBUG("  isTradable  = " + (cfg.isTradable ? "true" : "false"));
    LOG_TEST_DEBUG("  bePrice     = " + DoubleToString(cfg.bePrice, 5));

    // 2. 依存クラスの初期化とモック注入
    CPositionModel positionModel;
    CEntryValidator validator;
    CBEPriceCalculator beCalculator;

    OnInit_TestBootstrap(positionModel, validator, beCalculator, true, cfg);
    LOG_TEST_DEBUG("OnInit_TestBootstrap() → 依存オブジェクトにモック値反映");

    // 3. 状態管理クラス初期化
    CPanelStateManager manager;
    manager.setShowSL(isSLShown);
    manager.setDependencies(positionModel, validator, beCalculator);

    LOG_TEST_DEBUG("CPanelStateManager 初期化完了:");
    LOG_TEST_DEBUG("  showSL      = " + (isSLShown ? "true" : "false"));

    // 4. 状態取得
    LOG_TEST_DEBUG("getStateCode() 呼び出し開始");
    int actualState = manager.getStateCode();
    LOG_TEST_DEBUG("getStateCode() 呼び出し完了 → 戻り値: " + IntegerToString(actualState));

    // 状態名対応（視認性向上用）
    string stateName;
    switch(actualState)
    {
        case STATE_Idle: stateName = "STATE_Idle"; break;
        case STATE_ReadyToEntry: stateName = "STATE_ReadyToEntry"; break;
        case STATE_PositionOpen: stateName = "STATE_PositionOpen"; break;
        case STATE_BEAvailable: stateName = "STATE_BEAvailable"; break;
        case STATE_Invalid_DependencyNull: stateName = "STATE_Invalid_DependencyNull"; break;
        case STATE_Invalid_MissingSL: stateName = "STATE_Invalid_MissingSL"; break;
        case STATE_Invalid_BEWithNoPosition: stateName = "STATE_Invalid_BEWithNoPosition"; break;
        default: stateName = "UNKNOWN_STATE(" + IntegerToString(actualState) + ")"; break;
    }

    LOG_TEST_DEBUG("  判定された状態名: " + stateName);

    // 5. 結果比較と出力
    string resultText = StringFormat("[Test %s] Expected=%d, Actual=%d", label, expectedState, actualState);

    if (actualState == expectedState)
        LOG_TEST_INFO("[PASS]  " + resultText);
    else
        LOG_TEST_ERROR("[FAIL] >>>>> " + resultText + " <<<<<< MISMATCH");

    LOG_TEST_DEBUG("[END] RunTest: " + label);
    LOG_TEST_DEBUG("━━━━━━━━━━━━━━━━━━━━━━━");
}

