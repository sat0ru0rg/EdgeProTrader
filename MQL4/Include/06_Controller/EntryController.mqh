//+------------------------------------------------------------------+
//| EntryController.mqh                                             |
//| 成行エントリーに関するロジックを担当するControllerクラス               |
//| 呼び出し元：EntryMediator                                        |
//+------------------------------------------------------------------+
//#pragma once
#include <00_Common/CommonDefs.mqh>
#include <01_Config/EPT_EnvConfig.mqh>
#include <07_Manager/CPanelStateManager.mqh>
#include <08_Model/CPositionModel.mqh>
#include <11_Trade/CEntryExecutor.mqh>
#include <10_Validator/CEntryValidator.mqh>

class EntryController
{
private:
    CPanelStateManager* m_stateManager;
    CEntryValidator*    m_validator;
    CEntryExecutor*     m_executor;
    CPositionModel*     m_positionModel;

public:
    EntryController() {}
    ~EntryController() {}

    void setDependencies(CPanelStateManager* stateMgr,
                         CEntryValidator* validator,
                         CEntryExecutor* executor,
                         CPositionModel* posModel)
    {
        m_stateManager   = stateMgr;
        m_validator      = validator;
        m_executor       = executor;
        m_positionModel  = posModel;
    }

    /// @brief 現在の状態でエントリー可能かを判定
    bool canEnter()
    {
        if (m_stateManager == NULL)
        {
            LOG_ACTION_ERROR_C("StateManagerが未設定です");
            return false;
        }
        return m_stateManager.CanEnter();
    }

    /// @brief エントリーボタン押下時の実行処理（BUY/SELL）
    void executeEntry(string direction)
    {
        LOG_ACTION_INFO_C("エントリー処理開始 direction=" + direction);

        if (!canEnter())
        {
            LOG_ACTION_ERROR_C("エントリー不可状態：UIまたはSL未設定");
            return;
        }

        if (!m_validator.IsTradableTime(TimeCurrent()))
        {
            LOG_ACTION_ERROR_C("取引時間外です");
            return;
        }

        if (!m_validator.IsSpreadAcceptable(MarketInfo(Symbol(), MODE_SPREAD)))
        {
            LOG_ACTION_ERROR_C("スプレッドが許容範囲外です");
            return;
        }

        m_executor.SetSymbol(Symbol());
        m_executor.SetVolume(0.1); // TODO: RiskManagerと連携して自動ロット計算
        m_executor.SendOrder(direction);
    }

    /// @brief エントリー後のUI更新（ボタン・ラインなど）
    void updateEntryUI()
    {
        LOG_VIEW_INFO_C("エントリー後のUI更新を実行");

        if (m_stateManager != NULL)
            m_stateManager.UpdateButtonStates();
    }
};
