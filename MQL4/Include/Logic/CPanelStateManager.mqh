#ifndef __CPANELSTATEMANAGER__
#define __CPANELSTATEMANAGER__

#include "../Common/CommonDefs.mqh"
#include "CPositionModel.mqh"
#include "CEntryValidator.mqh"
#include "CBEPriceCalculator.mqh"

class CPanelStateManager
{
private:
    bool showSL;
    CPositionModel* positionModel;
    CEntryValidator* validator;
    CBEPriceCalculator* beCalculator;
    string currentState;

public:
    CPanelStateManager()
    {
        showSL = false;
        positionModel = NULL;
        validator = NULL;
        beCalculator = NULL;
        currentState = "Idle";
    }

    //+------------------------------------------------------------------+
    //| @brief 依存コンポーネントの初期化（テストや実行前に必須）       |
    //+------------------------------------------------------------------+
    void setDependencies(CPositionModel &p, CEntryValidator &v, CBEPriceCalculator &b)
    {
        positionModel = &p;
        validator = &v;
        beCalculator = &b;
    }

    //+------------------------------------------------------------------+
    //| @brief View層からのSL表示状態を更新（Ready判定に使用）          |
    //+------------------------------------------------------------------+
    void setShowSL(bool val)
    {
        showSL = val;
    }

    //+------------------------------------------------------------------+
    //| @brief 現在の状態コードを判定（診断・検証用）                   |
    //+------------------------------------------------------------------+
    int getStateCode()
    {
        if (positionModel == NULL || validator == NULL || beCalculator == NULL)
        {
            LOG_LOGIC_ERROR("[getStateCode] 依存オブジェクトがNULL");
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

    //+------------------------------------------------------------------+
    //| @brief 現在の状態を取得（正常運用用）                           |
    //+------------------------------------------------------------------+
    string GetCurrentState()
    {
        return currentState;
    }

    //+------------------------------------------------------------------+
    //| @brief テスト用に状態を明示的に強制セット                       |
    //+------------------------------------------------------------------+
    void SetState(string newState)
    {
        currentState = newState;
        LOG_LOGIC_INFO("SetState 実行：状態を " + newState + " に強制設定");
    }

    //+------------------------------------------------------------------+
    //| @brief 内部通知による状態更新（外部SetStateとは分離）           |
    //+------------------------------------------------------------------+
    void UpdateState(string newState)
    {
        currentState = newState;
        LOG_LOGIC_DEBUG("UpdateState 実行：内部状態を " + newState + " に更新");
    }

    //+------------------------------------------------------------------+
    //| @brief SLライン表示通知（View→Logic）                           |
    //+------------------------------------------------------------------+
    void OnSLLineShown()
    {
        if (currentState != "Idle")
        {
            LOG_LOGIC_ERROR("[PanelState] SL表示はIdle状態でのみ有効。現在: " + currentState);
            return;
        }

        currentState = "ReadyToEntry";
        LOG_LOGIC_INFO("[PanelState] SLライン表示により ReadyToEntry に遷移");
    }

    //+------------------------------------------------------------------+
    //| @brief 成行エントリー成功通知（Executor→Logic）                 |
    //+------------------------------------------------------------------+
    void OnEntryExecuted()
    {
        if (currentState != "ReadyToEntry")
        {
            LOG_LOGIC_ERROR("[PanelState] Entry通知はReadyToEntry状態でのみ有効。現在: " + currentState);
            return;
        }

        currentState = "PositionOpen";
        LOG_LOGIC_INFO("[PanelState] 成行エントリー成功により PositionOpen に遷移");
    }

    //+------------------------------------------------------------------+
    //| @brief ポジション決済通知（Executor→Logic）                     |
    //+------------------------------------------------------------------+
    void OnPositionClosed()
    {
        if (currentState != "PositionOpen" && currentState != "BEAvailable")
        {
            LOG_LOGIC_ERROR("[PanelState] 決済通知はPositionOpen/BEAvailable状態でのみ有効。現在: " + currentState);
            return;
        }

        currentState = "Idle";
        LOG_LOGIC_INFO("[PanelState] ポジション決済により Idle に遷移");
    }
};

#endif // __CPANELSTATEMANAGER__
