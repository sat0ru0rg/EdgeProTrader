#ifndef __CENTRYCONTROLLER__
#define __CENTRYCONTROLLER__

#include <00_Common/CommonDefs.mqh>
#include <07_Manager/CPanelStateManager.mqh>
#include <08_Model/CPositionModel.mqh>
#include <10_Validator/CEntryValidator.mqh>
#include <09_Logic/CEntryRiskCalculator.mqh>
#include <09_Logic/CEntryPriceCalculator.mqh>
#include <11_Trade/CEntryExecutor.mqh>

#define __CLASS__ "CEntryController"

class CEntryController
{
private:
    CPanelStateManager*     m_stateManager;
    CPositionModel*         m_positionModel;
    CEntryValidator*        m_validator;
    CEntryRiskCalculator*   m_riskCalculator;
    CEntryPriceCalculator*  m_priceCalculator;
    CEntryOrderService*     m_orderService;

public:
    void SetDependencies(
        CPanelStateManager*     stateManager,
        CPositionModel*         positionModel,
        CEntryValidator*        validator,
        CEntryRiskCalculator*   riskCalculator,
        CEntryPriceCalculator*  priceCalculator,
        CEntryOrderService*     orderService
    )
    {
        m_stateManager    = stateManager;
        m_positionModel   = positionModel;
        m_validator       = validator;
        m_riskCalculator  = riskCalculator;
        m_priceCalculator = priceCalculator;
        m_orderService    = orderService;
    }

    bool ExecuteBuy()
    {
        LOG_ACTION_DEBUG_C("START ExecuteBuy");

        if (!m_validator.ShouldEnterNow())
        {
            LOG_ACTION_INFO_C("エントリー条件を満たしていません（Validator）");
            return false;
        }

        EntryMode mode = m_stateManager.GetCurrentEntryMode();
        string symbol = Symbol();
        double slPips = m_stateManager.GetSLPips(mode);
        double riskPercent = m_stateManager.GetRiskPercent(mode);

        double lot = m_riskCalculator.CalculateLot(symbol, slPips, riskPercent);
        if (lot <= 0)
        {
            LOG_ACTION_ERROR_C("ロット計算に失敗しました");
            return false;
        }

        double entryPrice = MarketInfo(symbol, MODE_ASK);
        double slPrice    = m_priceCalculator.CalculateSL(symbol, entryPrice, slPips, OP_BUY);
        double tpPrice    = m_priceCalculator.CalculateTP(symbol, entryPrice, slPips, OP_BUY);

        CEntryExecutor executor;
        executor.SetSymbol(symbol);
        executor.SetVolume(lot);
        executor.SetEntryPrice(entryPrice);
        executor.SetStopLoss(slPrice);
        executor.SetTakeProfit(tpPrice);
        executor.SetSlippage(3); // 固定でもOK、必要なら外部設定
        executor.SetMagic(123456);
        executor.SetComment("EPT_ENTRY_" + EnumToString(mode));
        executor.SetStateManager(m_stateManager);
        executor.SetPositionModel(m_positionModel);
        executor.SetOrderService(m_orderService);

        if (!executor.Send())
        {
            LOG_ACTION_ERROR_C("発注に失敗しました: " + executor.GetLastErrorMessage());
            return false;
        }

        return true;
    }
};

#endif // __CENTRYCONTROLLER__
