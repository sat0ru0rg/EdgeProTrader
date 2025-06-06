#ifndef __ENTRY_PANEL_CONTROLLER__
#define __ENTRY_PANEL_CONTROLLER__

#include <Common/CommonDefs.mqh>
#include <Logic/CPanelStateManager.mqh>
#include <Logic/CPositionModel.mqh>
#include <Trade/CEntryExecutor.mqh>
#include <View/CPanelVisualizerManager.mqh>

class EntryPanelController
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
    EntryPanelController()
    {
        hasEntry      = false;
        hasSLLine     = false;
        hasTPLine     = false;
        hasBELine     = false;
        currentEntryMode = ENTRY_1;
    }

    void Initialize()
    {
        LOG_LOGIC_INFO("EntryPanelController::Initialize 開始");

        m_executor.SetSymbol(_Symbol);
        m_executor.SetVolume(0.1);
        m_executor.SetSlippage(3);
        m_executor.SetStopLoss(30);
        m_executor.SetTakeProfit(60);
        m_executor.SetStateManager(&m_stateManager);
        m_executor.SetPositionModel(&m_positionModel);

        LOG_LOGIC_INFO("EntryPanelController::Initialize 完了");
    }

    //+------------------------------------------------------------------+
    //| Entryボタン押下処理                                              |
    //+------------------------------------------------------------------+
    void OnEntryButtonClicked()
    {
        string state = m_stateManager.GetCurrentState();
        LOG_LOGIC_DEBUG("OnEntryButtonClicked 呼び出し. 現在状態: " + state);
    
        if (state != "ReadyToEntry")
        {
            LOG_LOGIC_ERROR("[PanelState] Entry通知はReadyToEntry状態でのみ有効。現在: " + state);
            return;
        }
    
        if (m_executor.ExecuteEntry(currentEntryMode))
        {
            LOG_LOGIC_INFO("[PanelState] 成行エントリー成功。状態遷移はExecutor→StateManagerにて通知済み");
        }
        else
        {
            LOG_ACTION_ERROR("OrderSend失敗: エントリーできませんでした");
        }
    }
    
    //+------------------------------------------------------------------+
    //| SLボタン押下処理                                                 |
    //+------------------------------------------------------------------+
    void OnSLButtonClicked()
    {
        string state = m_stateManager.GetCurrentState();
        LOG_LOGIC_DEBUG("OnSLButtonClicked 呼び出し. 現在状態: " + state);
    
        if (state != "Idle")
        {
            LOG_LOGIC_ERROR("[PanelState] SL表示はIdle状態でのみ有効。現在: " + state);
            return;
        }
    
        if (m_visualizerManager.SL().ShowLine())
        {
            m_stateManager.OnSLLineShown();
            LOG_VIEW_INFO("[SLVisualizer] SLラインを表示しました");
        }
        else
        {
            LOG_VIEW_ERROR("SLライン表示に失敗しました");
        }
    }
    
    //+------------------------------------------------------------------+
    //| Closeボタン押下処理                                              |
    //+------------------------------------------------------------------+
    void OnCloseButtonClicked()
    {
        string state = m_stateManager.GetCurrentState();
        LOG_LOGIC_DEBUG("OnCloseButtonClicked 呼び出し. 現在状態: " + state);
    
        if (state != "PositionOpen")
        {
            LOG_LOGIC_ERROR("[PanelState] Close通知はPositionOpen状態でのみ有効。現在: " + state);
            return;
        }
    
        if (m_executor.ClosePartial(currentEntryMode))
        {
            LOG_LOGIC_INFO("[PanelState] ポジション決済完了。状態遷移はExecutor→StateManagerにて通知済み");
        }
        else
        {
            LOG_ACTION_ERROR("Close失敗: ポジション決済に失敗しました");
        }
    }
    
    //+------------------------------------------------------------------+
    //| BEボタン押下処理（トグル表示）                                   |
    //+------------------------------------------------------------------+
    void OnBEButtonClicked()
    {
        string state = m_stateManager.GetCurrentState();
        LOG_LOGIC_DEBUG("OnBEButtonClicked 呼び出し. 現在状態: " + state);
    
        if (state != "PositionOpen")
        {
            LOG_LOGIC_ERROR("[PanelState] BEライン操作はPositionOpen状態でのみ有効。現在: " + state);
            return;
        }
    
        if (m_visualizerManager.BE().IsShown())
        {
            m_visualizerManager.BE().HideLine();
            LOG_VIEW_INFO("[BEVisualizer] BEラインを非表示にしました");
        }
        else
        {
            m_visualizerManager.BE().ShowLine();
            LOG_VIEW_INFO("[BEVisualizer] BEラインを表示しました");
        }
    }
    
    //+------------------------------------------------------------------+
    //| Resetボタン押下処理                                              |
    //+------------------------------------------------------------------+
    void OnResetButtonClicked()
    {
        LOG_LOGIC_INFO("OnResetButtonClicked 実行: ユーザー操作による明示的初期化");
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
    
        LOG_LOGIC_INFO("ResetState 実行：状態および全ラインを初期化");
    }

    string GetCurrentState()
    {
        return m_stateManager.GetCurrentState();
    }

    void DumpInternalState()
    {
        LOG_LOGIC_DEBUG("▼DumpInternalState 開始▼");
        LOG_LOGIC_DEBUG("stateManager        = " + m_stateManager.GetCurrentState());
        LOG_LOGIC_DEBUG("hasEntry            = " + (string)hasEntry);
        LOG_LOGIC_DEBUG("hasSLLine           = " + (string)hasSLLine);
        LOG_LOGIC_DEBUG("hasTPLine           = " + (string)hasTPLine);
        LOG_LOGIC_DEBUG("hasBELine           = " + (string)hasBELine);
        LOG_LOGIC_DEBUG("currentEntryMode    = " + EnumToString(currentEntryMode));
        LOG_LOGIC_DEBUG("▲DumpInternalState 終了▲");
    }
};

#endif // __ENTRY_PANEL_CONTROLLER__
