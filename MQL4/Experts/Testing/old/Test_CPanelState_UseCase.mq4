#include <Logic/CEntryStateController.mqh>

CEntryStateController stateController;

//+------------------------------------------------------------------+
//| OnInit に追記                                                    |
//+------------------------------------------------------------------+
void OnInit()
{
    LOG_TEST_INFO("==== Test_CPanelState_UseCase 開始 ====");
    stateController.Initialize();

    RunTest_UC01();
    RunTest_UC02();
    RunTest_UC03();
    RunTest_UC04();
    RunTest_UC05();
    RunTest_UC06();
    RunTest_UC07();
    RunTest_UC08();

    LOG_TEST_INFO("==== Test_CPanelState_UseCase 終了 ====");
}

void OnDeinit(const int reason)
{
    int total = OrdersTotal();
    if (total == 0)
        LOG_TEST_INFO("✅ テスト完了時点で保有ポジションは 0 件です");
    else
        LOG_TEST_ERROR("❌ テスト後に未決済ポジションが残っています: " + (string)total);

    LOG_TEST_INFO("==== テストEA終了時の状態 ====");     
    TraceOpenPositions("OnDeinit");
}

//+------------------------------------------------------------------+
//| 状態確認用ユーティリティ                                        |
//+------------------------------------------------------------------+
void AssertState(string expected)
{
    string actual = Trim(stateController.GetCurrentState());
    expected = Trim(expected);

    if (actual != expected)
        LOG_TEST_ERROR(">>>>>>>>>>>>>>>  状態不一致: 期待=" + expected + ", 実際=" + actual + "  <<<<<<<<<<<<<<<");
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

//+------------------------------------------------------------------+
//| UC01: SL表示 → エントリー → クローズ                            |
//+------------------------------------------------------------------+
void RunTest_UC01()
{
    //ユースケースの初期化関数
    InitTestUC(UC_COMMENT_UC01);

    // ▼ ログと処理開始
    LOG_TEST_INFO("▼▼ UC01 開始 ▼▼  (SL表示 → エントリー → クローズ)");

    stateController.OnSLButtonClicked();
    AssertState("ReadyToEntry");

    stateController.OnEntryButtonClicked();
    AssertState("PositionOpen");

    stateController.OnCloseButtonClicked();
    AssertState("Idle");

    TraceOpenPositions("UC01", true);

    LOG_TEST_INFO("▲▲ UC01 終了 ▲▲");
}


//+------------------------------------------------------------------+
//| UC02: SL表示のみして終了                                        |
//+------------------------------------------------------------------+
void RunTest_UC02()
{

    //ユースケースの初期化関数
    InitTestUC(UC_COMMENT_UC02);

    LOG_TEST_INFO("▼▼ UC02 開始 ▼▼  (SL表示のみして終了)");

    stateController.OnSLButtonClicked();
    AssertState("ReadyToEntry");

    TraceOpenPositions("UC02", true);
    LOG_TEST_INFO("▲▲ UC02 終了 ▲▲");
}

//+------------------------------------------------------------------+
//| UC03: SL表示 → エントリーのみ（クローズしない）                |
//+------------------------------------------------------------------+
void RunTest_UC03()
{
    //ユースケースの初期化関数
    InitTestUC(UC_COMMENT_UC03);

    LOG_TEST_INFO("▼▼ UC03 開始 ▼▼  (SL表示 → エントリーのみ、クローズなし)");

    stateController.OnSLButtonClicked(); // → ReadyToEntry
    LOG_TEST_INFO("現在状態（SL後）: " + stateController.GetCurrentState());

    AssertState("ReadyToEntry");

    stateController.OnEntryButtonClicked(); // → PositionOpen
    LOG_TEST_INFO("現在状態（Entry後）: " + stateController.GetCurrentState());

    AssertState("PositionOpen");

    TraceOpenPositions("UC03", true);
    LOG_TEST_INFO("▲▲ UC03 終了 ▲▲");
}


//+------------------------------------------------------------------+
//| UC04: SL無しでエントリー試行（発注不可）                        |
//+------------------------------------------------------------------+
void RunTest_UC04()
{

    //ユースケースの初期化関数
    InitTestUC(UC_COMMENT_UC04);

    LOG_TEST_INFO("▼▼ UC04 開始 ▼▼  (SL無しでエントリー試行 → 発注不可)");

    stateController.OnEntryButtonClicked();
    if (stateController.GetCurrentState() == "Idle")
        LOG_TEST_INFO("状態維持: Idle（正しい）");
    else
        LOG_TEST_ERROR("状態異常: Idle以外の状態に遷移");

    TraceOpenPositions("UC04", true);
    LOG_TEST_INFO("▲▲ UC04 終了 ▲▲");
}

//+------------------------------------------------------------------+
//| UC05: ポジ保有中にSLライン表示（無効）                          |
//+------------------------------------------------------------------+
void RunTest_UC05()
{
    //ユースケースの初期化関数
    InitTestUC(UC_COMMENT_UC05);

    LOG_TEST_INFO("▼▼ UC05 開始 ▼▼  (ポジ保有中にSL表示試行 → 無効)");

    stateController.OnSLButtonClicked();
    stateController.OnEntryButtonClicked();
    AssertState("PositionOpen");

    stateController.OnSLButtonClicked(); // 無効なはず
    AssertState("PositionOpen");

    TraceOpenPositions("UC05", true);
    LOG_TEST_INFO("▲▲ UC05 終了 ▲▲");
}

//+------------------------------------------------------------------+
//| UC06: 連続でエントリー試行（2回目は無効）                        |
//+------------------------------------------------------------------+
void RunTest_UC06()
{
    //ユースケースの初期化関数
    InitTestUC(UC_COMMENT_UC06);

    LOG_TEST_INFO("▼▼ UC06 開始 ▼▼  (連続エントリー試行 → 2回目は無効)");

    stateController.OnSLButtonClicked();
    stateController.OnEntryButtonClicked();
    AssertState("PositionOpen");

    stateController.OnEntryButtonClicked(); // 2回目は無効
    AssertState("PositionOpen");

    TraceOpenPositions("UC06", true);
    LOG_TEST_INFO("▲▲ UC06 終了 ▲▲");
}

//+------------------------------------------------------------------+
//| UC07: 1セット完了後に2回繰り返し                                 |
//+------------------------------------------------------------------+
void RunTest_UC07()
{
    //ユースケースの初期化関数
    InitTestUC(UC_COMMENT_UC07);

    LOG_TEST_INFO("▼▼ UC07 開始 ▼▼  (1セット完了後に2回繰り返し)");

    for (int i = 1; i <= 2; i++)
    {
        stateController.ResetState();
        stateController.OnSLButtonClicked();
        stateController.OnEntryButtonClicked();
        AssertState("PositionOpen");

        stateController.OnCloseButtonClicked();
        AssertState("Idle");

        LOG_TEST_INFO("ループ " + (string)i + " 回目完了");
    }

    TraceOpenPositions("UC07", true);
    LOG_TEST_INFO("▲▲ UC07 終了 ▲▲");
}

//+------------------------------------------------------------------+
//| UC08: 任意状態から ResetState() で強制初期化                    |
//+------------------------------------------------------------------+
void RunTest_UC08()
{
    //ユースケースの初期化関数
    InitTestUC(UC_COMMENT_UC08);

    LOG_TEST_INFO("▼▼ UC08 開始 ▼▼  (任意状態からResetStateで強制初期化)");

    stateController.OnSLButtonClicked();
    stateController.OnEntryButtonClicked();
    AssertState("PositionOpen");

    stateController.ResetState();
    AssertState("Idle");

    TraceOpenPositions("UC08", true);
    LOG_TEST_INFO("▲▲ UC08 終了 ▲▲");
}

void InitTestUC(string uc)
{
    stateController.ResetState();
    stateController.SetCurrentUC(uc); 
    stateController.GetExecutor().SetComment(uc);
}

//+------------------------------------------------------------------+
//| 保有ポジションの詳細トレース                                     |
//+------------------------------------------------------------------+
void TraceOpenPositions(string ucTag = "", bool markNew = false)
{
    int total = OrdersTotal();
    LOG_TEST_INFO("[" + ucTag + "] オープンポジション数: " + (string)total);

    for (int i = 0; i < total; i++)
    {
        if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES))
        {
            string comment = OrderComment();
            string info = "ticket=" + (string)OrderTicket()
                        + " | type=" + (string)OrderType()
                        + " | lots=" + DoubleToString(OrderLots(), 2)
                        + " | price=" + DoubleToString(OrderOpenPrice(), 3)
                        + " | comment=" + comment;

            if (markNew && TimeCurrent() - OrderOpenTime() < 10)
                info += " [!NEW]";

            LOG_TEST_INFO("[" + ucTag + "] → 保有: " + info);
        }
    }
}

