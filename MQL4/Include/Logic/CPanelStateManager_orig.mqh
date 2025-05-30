#include <Common/CommonDefs.mqh>
#include <Logic/CPanelState.mqh>
#include <Logic/CPositionModel.mqh>
#include <Logic/CEntryValidator.mqh>
#include <Logic/CBEPriceCalculator.mqh>

class CPanelStateManager
{
private:
    CPanelState*        m_currentState;
    CPositionModel*     m_positionModel;
    CEntryValidator*    m_entryValidator;
    CBEPriceCalculator* m_calculator;

public:
    CPanelStateManager(CPositionModel* model, CEntryValidator* validator, CBEPriceCalculator* calculator)
    {
        m_currentState   = CPanelState::getIdle();
        m_positionModel  = model;
        m_entryValidator = validator;
        m_calculator     = calculator;
    }

    CPanelState* GetCurrentState()       { return m_currentState; }
    string GetCurrentStateName()         { return m_currentState.getName(); }
    PanelStateCode GetCurrentStateCode() { return m_currentState.getCode(); }

    void UpdateState(CPanelState* state)
    {
        m_currentState = state;

        LOG_LOGIC_DEBUG("[STATE] → Code: " +
                        IntegerToString(state.getCode()) +
                        ", Name: " + state.getName());
    }

    bool IsActiveState(CPanelState* s)   { return m_currentState.equals(s); }

    bool IsIdle()            { return IsActiveState(CPanelState::getIdle()); }
    bool IsReadyToEntry()    { return IsActiveState(CPanelState::getReadyToEntry()); }
    bool IsPositionOpen()    { return IsActiveState(CPanelState::getPositionOpen()); }
    bool IsBEAvailable()     { return IsActiveState(CPanelState::getBEAvailable()); }
    bool IsInvalid()         { return GetCurrentStateCode() >= 100; }

    void EvaluateState()
    {
        if (m_positionModel == NULL || m_entryValidator == NULL || m_calculator == NULL)
        {
            LOG_LOGIC_ERROR("[STATE] Invalid: Dependency null");
            UpdateState(CPanelState::getInvalid_DependencyNull());
            return;
        }

        bool hasSL     = IsSLVisible();
        bool hasPos    = m_positionModel.HasAnyOpenPosition();
        bool isBEValid = hasPos && IsBEConditionMet();

        if (!hasSL && hasPos)
        {
            LOG_LOGIC_INFO("[STATE] Invalid: Missing SL with position held");
            UpdateState(CPanelState::getInvalid_MissingSL());
            return;
        }

        if (!hasPos && isBEValid)
        {
            LOG_LOGIC_INFO("[STATE] Invalid: BE condition met but no position");
            UpdateState(CPanelState::getInvalid_BEWithNoPosition());
            return;
        }

        if (!hasSL)
        {
            UpdateState(CPanelState::getIdle());
            return;
        }

        if (hasSL && !hasPos)
        {
            UpdateState(CPanelState::getReadyToEntry());
            return;
        }

        if (hasPos && !isBEValid)
        {
            UpdateState(CPanelState::getPositionOpen());
            return;
        }

        if (hasPos && isBEValid)
        {
            UpdateState(CPanelState::getBEAvailable());
            return;
        }

        LOG_LOGIC_ERROR("[STATE] Unexpected fallback reached");
        UpdateState(CPanelState::getInvalid());
    }

    bool CanExecuteBE()
    {
        return IsBEVisible() && IsBEConditionMet();
    }

private:
    bool IsBEConditionMet()
    {
        int ticket = m_positionModel.GetLatestOpenTicket();
        if (ticket <= 0) return false;

        double bePrice = m_calculator.CalculateTrueBEPrice(ticket);
        int type = m_positionModel.GetOrderType(ticket);
        double price = (type == OP_BUY) ? MarketInfo(Symbol(), MODE_BID)
                                        : MarketInfo(Symbol(), MODE_ASK);

        double pipDiff = (type == OP_BUY) ? (price - bePrice) : (bePrice - price);
        return pipDiff * GetPipFactor() >= 0.1;
    }

    double GetPipFactor()
    {
        double point = MarketInfo(Symbol(), MODE_POINT);
        int digits   = (int)MarketInfo(Symbol(), MODE_DIGITS);
        return (digits == 3 || digits == 5) ? point * 10 : point;
    }

    bool IsSLVisible()
    {
        return ObjectFind(0, "EPT_SL_LINE") != -1;
    }

    bool IsBEVisible()
    {
        return ObjectFind(0, "EPT_BE_LINE") != -1;
    }
};
