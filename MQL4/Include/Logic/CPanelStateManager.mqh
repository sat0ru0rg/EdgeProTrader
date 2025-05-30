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

    void setShowSL(bool val) { showSL = val; }

    void setDependencies(CPositionModel &p, CEntryValidator &v, CBEPriceCalculator &b)
    {
        positionModel = &p;
        validator = &v;
        beCalculator = &b;
    }

    int getStateCode()
    {
        if (positionModel == NULL || validator == NULL || beCalculator == NULL)
            return STATE_Invalid_DependencyNull;
    
        bool hasPosition = positionModel.HasOpenPosition(_Symbol);
        double bePrice = beCalculator.CalculateTrueBEPrice();
        bool isBEConditionMet = (bePrice > 0.0);
    
        if (!showSL)
        {
            if (hasPosition)
                return STATE_Invalid_MissingSL;
            if (isBEConditionMet)
                return STATE_Invalid_BEWithNoPosition;  // ✅ ここも必要
            return STATE_Idle;
        }
    
        if (!hasPosition)
        {
            if (isBEConditionMet)
                return STATE_Invalid_BEWithNoPosition;  // ✅ ここが漏れていると今回のようなMISMATCHが出る
            return STATE_ReadyToEntry;
        }
    
        if (!isBEConditionMet)
            return STATE_PositionOpen;
    
        return STATE_BEAvailable;
    }

    void UpdateState(string newState)
    {
        currentState = newState;
    }

    string GetCurrentState()
    {
        return currentState;
    }
    
    //+------------------------------------------------------------------+
    //| OnSLLineShown()                                                  |
    //| - View層（CEntryPanelなど）でSLラインが表示された際に呼ばれる     |
    //| - Idle状態でなければエラー。ReadyToEntryに遷移する              |
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
    //| OnEntryExecuted()                                               |
    //| - 発注Executor（CEntryExecutor等）で成行エントリーが成功した際に |
    //|   呼び出される通知関数                                           |
    //| - ReadyToEntry 状態でのみ呼び出される前提                       |
    //| - 状態を PositionOpen に遷移させる                              |
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
    //| OnPositionClosed()                                               |
    //| - ポジションが完全決済された際に呼び出される通知関数             |
    //| - PositionOpen または BEAvailable 状態からのみ呼び出される前提   |
    //| - 状態を Idle に遷移させる                                       |
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
