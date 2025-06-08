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
        m_executor.SetStopLoss(30);
        m_executor.SetTakeProfit(60);
        m_executor.SetStateManager(&m_stateManager);
        m_executor.SetPositionModel(&m_positionModel);

        LOG_LOGIC_INFO_C("CEntryStateController::Initialize 完了");
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
            LOG_LOGIC_ERROR_C("[PanelState] Entry通知はReadyToEntry状態でのみ有効。現在: " + state);
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
        string state = m_stateManager.GetCurrentState();
        LOG_LOGIC_DEBUG_C("OnSLButtonClicked 呼び出し. 現在状態: " + state);
    
        if (state != "Idle")
        {
            LOG_LOGIC_ERROR_C("[PanelState] SL表示はIdle状態でのみ有効。現在: " + state);
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
    void OnCloseButtonClicked()
    {
        string state = m_stateManager.GetCurrentState();
        LOG_LOGIC_DEBUG_C("OnCloseButtonClicked 呼び出し. 現在状態: " + state);
    
        if (state != "PositionOpen")
        {
            LOG_LOGIC_ERROR_C("[PanelState] Close通知はPositionOpen状態でのみ有効。現在: " + state);
            return;
        }
    
        if (m_executor.ClosePartial(currentEntryMode))
        {
            LOG_LOGIC_INFO_C("[PanelState] ポジション決済完了。状態遷移はExecutor→StateManagerにて通知済み");
        }
        else
        {
            LOG_ACTION_ERROR_C("Close失敗: ポジション決済に失敗しました");
        }
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