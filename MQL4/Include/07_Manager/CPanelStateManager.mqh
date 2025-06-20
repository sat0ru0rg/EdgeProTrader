#ifndef __CPANELSTATEMANAGER__
#define __CPANELSTATEMANAGER__

#include <00_Common/CommonDefs.mqh>
#include <07_Manager/CPanelState.mqh>
#include <08_Model/CPositionModel.mqh>
#include <10_Validator/CEntryValidator.mqh>
#include <09_Calculator/CBEPriceCalculator.mqh>

class CPanelStateManager
{
private:
    bool showSL;
    CPositionModel* positionModel;
    CEntryValidator* validator;
    CBEPriceCalculator* beCalculator;

    PanelStateCode currentState;             // ← enumに変更
    string m_currentUCComment;
    EntryMode m_entryMode;

public:
    CPanelStateManager()
    {
        showSL = false;
        positionModel = NULL;
        validator = NULL;
        beCalculator = NULL;
        currentState = STATE_Idle;
        m_entryMode = ENTRY_1;
    }

    void setDependencies(CPositionModel &p, CEntryValidator &v, CBEPriceCalculator &b)
    {
        positionModel = &p;
        validator = &v;
        beCalculator = &b;
    }

    void setShowSL(bool val)
    {
        showSL = val;
    }

    int getStateCode()
    {
        if (positionModel == NULL || validator == NULL || beCalculator == NULL)
        {
            LOG_LOGIC_ERROR_C("[getStateCode] 依存オブジェクトがNULL");
            return STATE_Invalid_DependencyNull;
        }

        bool hasPosition = positionModel.HasOpenPosition(_Symbol);
        double bePrice = beCalculator.CalculateTrueBEPrice();
        bool isBEConditionMet = (bePrice > 0.0);

        if (!showSL)
        {
            if (hasPosition)
                return STATE_Invalid_MissingSL;
            if (isBEConditionMet)
                return STATE_Invalid_BEWithNoPosition;
            return STATE_Idle;
        }

        if (!hasPosition)
        {
            if (isBEConditionMet)
                return STATE_Invalid_BEWithNoPosition;
            return STATE_ReadyToEntry;
        }

        if (!isBEConditionMet)
            return STATE_PositionOpen;

        return STATE_BEAvailable;
    }

    PanelStateCode GetCurrentState()
    {
        return currentState;
    }

    void SetState(PanelStateCode newState)
    {
        currentState = newState;
        string name = CPanelState::FromEnum(newState).GetName();
        LOG_LOGIC_INFO_C("SetState 実行：状態を " + name + " に強制設定");
    }

    void UpdateState(PanelStateCode newState)
    {
        currentState = newState;
        string name = CPanelState::FromEnum(newState).GetName();
        LOG_LOGIC_DEBUG_C("UpdateState 実行：内部状態を " + name + " に更新");
    }

    void UpdateButtonStates()
    {
        LOG_VIEW_INFO_C("UpdateButtonStates() 呼び出し");
        // TODO: View更新処理などをMediator経由で連携
    }

    void SetCurrentUC(string comment)
    {
        m_currentUCComment = comment;
        LOG_LOGIC_INFO_C("SetCurrentUC 実行：" + comment + " に設定");
    }

    string GetCurrentUC()
    {
        return m_currentUCComment;
    }

    void OnSLLineShown()
    {
        if (currentState != STATE_Idle)
        {
            LOG_LOGIC_ERROR_C("[PanelState] SL表示はIdle状態でのみ有効。現在: " + CPanelState::FromEnum(currentState).GetName());
            return;
        }

        currentState = STATE_ReadyToEntry;
        LOG_LOGIC_INFO_C("[PanelState] SLライン表示により ReadyToEntry に遷移");
    }

    void OnEntryExecuted()
    {
        if (currentState != STATE_ReadyToEntry)
        {
            LOG_LOGIC_ERROR_C("[PanelState] Entry通知はReadyToEntry状態でのみ有効。現在: " + CPanelState::FromEnum(currentState).GetName());
            return;
        }

        currentState = STATE_PositionOpen;
        LOG_LOGIC_INFO_C("[PanelState] 成行エントリー成功により PositionOpen に遷移");
    }

    void OnPositionClosed()
    {
        if (currentState != STATE_PositionOpen && currentState != STATE_BEAvailable)
        {
            LOG_LOGIC_ERROR_C("[PanelState] 決済通知はPositionOpen/BEAvailable状態でのみ有効。現在: " + CPanelState::FromEnum(currentState).GetName());
            return;
        }

        currentState = STATE_Idle;
        LOG_LOGIC_INFO_C("[PanelState] ポジション決済により Idle に遷移");
    }

    void SetEntryMode(EntryMode mode)
    {
        m_entryMode = mode;
        LOG_LOGIC_INFO_C("SetEntryMode 実行：モード = " + EnumToString(mode));
    }

    EntryMode GetCurrentEntryMode()
    {
        return m_entryMode;
    }

    bool CanEnter()
    {
        return (getStateCode() == STATE_ReadyToEntry);
    }
};

#endif // __CPANELSTATEMANAGER__
