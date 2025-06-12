#ifndef __CENTRY_STATE_CONTROLLER__
#define __CENTRY_STATE_CONTROLLER__

#include <Common/CommonDefs.mqh>
#include <Logic/CPanelStateManager.mqh>
#include <Logic/CPositionModel.mqh>
#include <Trade/CEntryExecutor.mqh>
#include <View/CPanelVisualizerManager.mqh>

class CEntryStateController
{
private:
    CPanelStateManager       m_stateManager;
    CEntryExecutor           m_executor;
    CPositionModel           m_positionModel;
    CPanelVisualizerManager  m_visualizerManager;

    bool hasEntry;
    bool hasSLLine;
    bool hasTPLine;
    bool hasBELine;

    string m_currentUC;  // ← ユースケース識別子を保持
    EntryMode currentEntryMode;

public:
    CEntryStateController()
    {
        hasEntry      = false;
        hasSLLine     = false;
        hasTPLine     = false;
        hasBELine     = false;
        currentEntryMode = ENTRY_1;
    }

    void Initialize()
    {
        LOG_LOGIC_INFO_C("CEntryStateController::Initialize 開始");

        m_executor.SetSymbol(_Symbol);
        m_executor.SetVolume(0.1);
        m_executor.SetSlippage(3);
        m_executor.SetStopLoss(300);
        m_executor.SetTakeProfit(600);
        m_executor.SetStateManager(&m_stateManager);
        m_executor.SetPositionModel(&m_positionModel);

        LOG_LOGIC_INFO_C("CEntryStateController::Initialize 完了");
    }
    
    // Getter for Executor
    CEntryExecutor* GetExecutor()
    {
        return &m_executor;
    }
    
    // Getter for StateManager
    CPanelStateManager* GetStateManager()
    {
        return &m_stateManager;
    }

void SetCurrentUC(string uc)
{
    m_currentUC = uc;
    m_stateManager.SetCurrentUC(uc);  // Managerにも転送（任意）
    LOG_LOGIC_INFO_C("SetCurrentUC 実行：UC=" + uc + " に設定");
}


    //+------------------------------------------------------------------+
    //| Entryボタン押下処理                                              |
    //+------------------------------------------------------------------+
    void OnEntryButtonClicked()
    {
        string state = m_stateManager.GetCurrentState();
        LOG_LOGIC_DEBUG_C("OnEntryButtonClicked 呼び出し. 現在状態: " + state);
    
        if (state != "ReadyToEntry")
        {
            LOG_LOGIC_ERROR_C("[PanelState] Entry通知はReadyToEntry状態でのみ有効。現在: " + state +
                              " ※このログはUI未実装のため発生していますが、将来はUI側でEntryボタンを無効化することで回避される想定です。");
            return;
        }
    
        if (m_executor.ExecuteEntry(currentEntryMode))
        {
            LOG_LOGIC_INFO_C("[PanelState] 成行エントリー成功。状態遷移はExecutor→StateManagerにて通知済み");
        }
        else
        {
            LOG_ACTION_ERROR_C("OrderSend失敗: エントリーできませんでした");
        }
    }
    
    //+------------------------------------------------------------------+
    //| SLボタン押下処理                                                 |
    //+------------------------------------------------------------------+
    void OnSLButtonClicked()
    {
        string currentState = m_stateManager.GetCurrentState();
        LOG_LOGIC_DEBUG_C("OnSLButtonClicked 呼び出し. 現在状態: " + currentState);
    
        if (currentState != "Idle")
        {
            LOG_LOGIC_ERROR_C("[PanelState] SL表示はIdle状態でのみ有効。現在: " + currentState + 
                                " ※これはUI未実装により一時的に通過しているが、将来はUIで制御予定のためWARNING的意味合い");
            return;
        }
    
        if (m_visualizerManager.SL().ShowLine())
        {
            m_stateManager.OnSLLineShown();
            LOG_VIEW_INFO_C("[SLVisualizer] SLラインを表示しました");
        }
        else
        {
            LOG_VIEW_ERROR_C("SLライン表示に失敗しました");
        }
    }
    
    //+------------------------------------------------------------------+
    //| Closeボタン押下処理                                              |
    //+------------------------------------------------------------------+
/*    void OnCloseButtonClicked()
    {
        // ユースケース識別コメントを取得し、Executorへ伝達
        string ucComment = m_stateManager.GetCurrentUC();             // ← 追加
        m_executor.SetComment(ucComment);                             // ← 追加
        
        // Close前のポジション情報を取得・ログ出力
        int before[10];
        m_positionModel.GetPositionTickets(_Symbol, before);
        for (int i = 0; i < ArraySize(before); i++)
        {
            if (before[i] != -1)
                LOG_LOGIC_INFO_C("Close前: OpenTicket = " + IntegerToString(before[i]));
        }
    
        // 現在のオープンチケット取得（ユースケース識別付き）
        int ticket = m_positionModel.GetOpenTicket(_Symbol, ucComment);  // ← 修正
        if (ticket == -1)
        {
            LOG_LOGIC_ERROR_C("GetOpenTicket 失敗：ポジションが存在しません");
            return;
        }
    
        // ロット数取得（OrderSelect 必須）
        if (!OrderSelect(ticket, SELECT_BY_TICKET))
        {
            LOG_LOGIC_ERROR_C("OrderSelect に失敗しました");
            return;
        }
        double lots = OrderLots();
    
        // クローズ処理
        bool closed = m_executor.ClosePartial(ticket, lots);
        if (!closed)
        {
            LOG_LOGIC_ERROR_C("ClosePartial に失敗しました");
            return;
        }
    
        LOG_LOGIC_INFO_C("ClosePartial を実行しました");
    
        // Close後のポジション情報を取得・ログ出力
        int after[10];
        m_positionModel.GetPositionTickets(_Symbol, after);
        for (int ii = 0; ii < ArraySize(after); ii++)
        {
            if (after[ii] != -1)
                LOG_LOGIC_INFO_C("Close後: OpenTicket = " + IntegerToString(after[ii]));
        }
    
        // 状態遷移判定
        int remaining = m_positionModel.CountOpenPositions(_Symbol);
        LOG_LOGIC_INFO_C("OnCloseButtonClicked 内部確認: OpenPositionCount = " + IntegerToString(remaining));
    
        if (remaining == 0)
        {
//            m_stateManager.OnPositionClosed();  // ← 正しいメンバ呼び出し
        }
        else
        {
            LOG_LOGIC_INFO_C("ポジション残ありのため Idle 遷移は行わない");
        }
    }*/
void OnCloseButtonClicked()
{
    string uc = m_currentUC;

    // Close前のポジション情報を取得・ログ出力
    int before[10];
    m_positionModel.GetPositionTickets(_Symbol, before);
    for (int i = 0; i < ArraySize(before); i++)
    {
        if (before[i] != -1)
            LOG_LOGIC_INFO_C("Close前: OpenTicket = " + IntegerToString(before[i]));
    }

    // 現在UCに一致するオープンチケットを取得
    int ticket = m_positionModel.GetOpenTicket(_Symbol, uc);
    if (ticket == -1)
    {
        LOG_LOGIC_ERROR_C("GetOpenTicket 失敗：UC=" + uc + " に該当するポジションが存在しません");
        return;
    }

    // ロット数取得（OrderSelect 必須）
    if (!OrderSelect(ticket, SELECT_BY_TICKET))
    {
        LOG_LOGIC_ERROR_C("OrderSelect に失敗しました");
        return;
    }
    double lots = OrderLots();

    // クローズ処理
    bool closed = m_executor.ClosePartial(ticket, lots);
    if (!closed)
    {
        LOG_LOGIC_ERROR_C("ClosePartial に失敗しました");
        return;
    }

    LOG_LOGIC_INFO_C("ClosePartial を実行しました");

    // Close後のポジション情報を取得・ログ出力
    int after[10];
    m_positionModel.GetPositionTickets(_Symbol, after);
    for (int ii = 0; ii < ArraySize(after); ii++)
    {
        if (after[ii] != -1)
            LOG_LOGIC_INFO_C("Close後: OpenTicket = " + IntegerToString(after[ii]));
    }

    // 現在UCに属するポジション数を確認
    int remaining = m_positionModel.CountOpenPositions(_Symbol, uc);
    LOG_LOGIC_INFO_C("OnCloseButtonClicked: CountOpenPositions (UC=" + uc + ") = " + IntegerToString(remaining));

    if (remaining == 0)
    {
        m_stateManager.OnPositionClosed();  // 状態通知
    }
    else
    {
        LOG_LOGIC_INFO_C("ポジション残ありのため Idle 遷移は行わない");
    }
}



    int CountOpenPositions(string symbol, string comment)
    {
        int count = 0;
        for (int i = 0; i < OrdersTotal(); i++)
        {
            if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES))
            {
                if (OrderSymbol() == symbol && StringFind(OrderComment(), comment) == 0)
                    count++;
            }
        }
        return count;
    }


    
    //+------------------------------------------------------------------+
    //| BEボタン押下処理（トグル表示）                                   |
    //+------------------------------------------------------------------+
    void OnBEButtonClicked()
    {
        string state = m_stateManager.GetCurrentState();
        LOG_LOGIC_DEBUG_C("OnBEButtonClicked 呼び出し. 現在状態: " + state);
    
        if (state != "PositionOpen")
        {
            LOG_LOGIC_ERROR_C("[PanelState] BEライン操作はPositionOpen状態でのみ有効。現在: " + state);
            return;
        }
    
        if (m_visualizerManager.BE().IsShown())
        {
            m_visualizerManager.BE().HideLine();
            LOG_VIEW_INFO_C("[BEVisualizer] BEラインを非表示にしました");
        }
        else
        {
            m_visualizerManager.BE().ShowLine();
            LOG_VIEW_INFO_C("[BEVisualizer] BEラインを表示しました");
        }
    }
    
    //+------------------------------------------------------------------+
    //| Resetボタン押下処理                                              |
    //+------------------------------------------------------------------+
    void OnResetButtonClicked()
    {
        LOG_LOGIC_INFO_C("OnResetButtonClicked 実行: ユーザー操作による明示的初期化");
        ResetState();
    }
    
    //+------------------------------------------------------------------+
    //| 状態・内部フラグの初期化                                         |
    //+------------------------------------------------------------------+
    void ResetState()
    {
        m_stateManager.SetState("Idle");  // ← テスト・明示初期化用途としてはOK
    
        hasEntry = false;
        hasSLLine = false;
        hasTPLine = false;
        hasBELine = false;
        currentEntryMode = ENTRY_1;
    
        m_visualizerManager.HideAll();
    
        LOG_LOGIC_INFO_C("ResetState 実行：状態および全ラインを初期化");
    }

    string GetCurrentState()
    {
        return m_stateManager.GetCurrentState();
    }

    void DumpInternalState()
    {
        LOG_LOGIC_DEBUG_C("▼DumpInternalState 開始▼");
        LOG_LOGIC_DEBUG_C("stateManager        = " + m_stateManager.GetCurrentState());
        LOG_LOGIC_DEBUG_C("hasEntry            = " + (string)hasEntry);
        LOG_LOGIC_DEBUG_C("hasSLLine           = " + (string)hasSLLine);
        LOG_LOGIC_DEBUG_C("hasTPLine           = " + (string)hasTPLine);
        LOG_LOGIC_DEBUG_C("hasBELine           = " + (string)hasBELine);
        LOG_LOGIC_DEBUG_C("currentEntryMode    = " + EnumToString(currentEntryMode));
        LOG_LOGIC_DEBUG_C("▲DumpInternalState 終了▲");
    }
};

#endif // __CENTRY_STATE_CONTROLLER__