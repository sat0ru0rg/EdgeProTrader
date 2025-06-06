#ifndef __CENTRY_EXECUTOR__
#define __CENTRY_EXECUTOR__

#include <Common/CommonDefs.mqh>
#include <Trade/COrderExecutorBase.mqh>
#include <Trade/CExecutorInterfaces.mqh>
#include <Logic/CPanelStateManager.mqh>
#include <Logic/CPositionModel.mqh>

class CEntryExecutor : public COrderExecutorBase
{
protected:
    CPanelStateManager* m_stateManager;
    CPositionModel*     m_positionModel;

public:
    CEntryExecutor()
    {
        m_stateManager = NULL;
        m_positionModel = NULL;
    }
    virtual ~CEntryExecutor() {}

    //+------------------------------------------------------------------+
    //| 成行エントリー（EntryMode指定）                                 |
    //+------------------------------------------------------------------+
    bool ExecuteEntry(EntryMode mode)
    {
        LOG_ACTION_DEBUG("CEntryExecutor::ExecuteEntry START");

        RefreshRates();
        double price = MarketInfo(m_symbol, MODE_ASK);  // 現状 BUY 固定

        double sl = price - PipToPrice(m_symbol, m_stopLoss);
        double tp = price + PipToPrice(m_symbol, m_takeProfit);

        LOG_ACTION_INFO("価格: " + DoubleToString(price, 5));
        LOG_ACTION_INFO("SL: "   + DoubleToString(sl, 5));
        LOG_ACTION_INFO("TP: "   + DoubleToString(tp, 5));

        int ticket = OrderSend(
            m_symbol,
            OP_BUY,
            m_volume,
            price,
            m_slippage,
            sl,
            tp,
            "ENTRY_" + EnumToString(mode),
            m_magic,
            0,
            clrBlue
        );

        if (ticket < 0)
        {
            int err = GetLastError();
            m_lastError = "OrderSend failed: err=" + IntegerToString(err);
            LOG_ACTION_ERROR(m_lastError);
            return false;
        }

        LOG_ACTION_INFO("OrderSend success: ticket=" + IntegerToString(ticket));

        if (m_stateManager != NULL)
        {
            LOG_ACTION_DEBUG("[Notify] stateManager.OnEntryExecuted() 呼び出し");
            m_stateManager.OnEntryExecuted();
        }
        else
        {
            LOG_ACTION_ERROR("[Notify] m_stateManager が NULL。状態通知できません");
        }

        return true;
    }

    //+------------------------------------------------------------------+
    //| EntryMode指定の保有ポジションを部分決済                         |
    //+------------------------------------------------------------------+
    bool ClosePartial(EntryMode mode)
    {
        if (m_positionModel == NULL)
        {
            LOG_ACTION_ERROR("PositionModel が未設定です（ClosePartial）");
            return false;
        }

        int ticket = m_positionModel.GetOpenTicket(mode);
        if (ticket == -1)
        {
            LOG_ACTION_ERROR("指定モード(" + EnumToString(mode) + ")の保有ポジションが存在しません");
            return false;
        }

        return ClosePartial(ticket, m_volume);
    }

    //+------------------------------------------------------------------+
    //| 指定チケット＆ロットで部分決済                                  |
    //+------------------------------------------------------------------+
    bool ClosePartial(int ticket, double lots)
    {
        LOG_ACTION_DEBUG("CEntryExecutor::ClosePartial START");

        if (!OrderSelect(ticket, SELECT_BY_TICKET))
        {
            m_lastError = "OrderSelect failed: " + IntegerToString(GetLastError());
            LOG_ACTION_ERROR(m_lastError);
            return false;
        }

        double closePrice = (OrderType() == OP_BUY)
                            ? MarketInfo(OrderSymbol(), MODE_BID)
                            : MarketInfo(OrderSymbol(), MODE_ASK);

        LOG_ACTION_INFO("OrderClose ticket=" + IntegerToString(ticket) +
                        ", lots=" + DoubleToString(lots, 2));

        bool result = OrderClose(ticket, lots, closePrice, m_slippage, clrRed);

        if (!result)
        {
            m_lastError = "OrderClose failed: " + IntegerToString(GetLastError());
            LOG_ACTION_ERROR(m_lastError);
            return false;
        }

        LOG_ACTION_INFO("ClosePartial success: ticket=" + IntegerToString(ticket));

        // 保有ポジション数で判断して状態通知
        if (m_positionModel != NULL)
        {
            int remain = m_positionModel.CountOpenPositions(m_symbol);
            LOG_ACTION_INFO("Open position count after close: " + IntegerToString(remain));

            if (remain == 0 && m_stateManager != NULL)
            {
                LOG_ACTION_DEBUG("[Notify] stateManager.OnPositionClosed() 呼び出し");
                m_stateManager.OnPositionClosed();
            }
        }

        return true;
    }

    //+------------------------------------------------------------------+
    //| 状態通知先の StateManager を設定                                |
    //+------------------------------------------------------------------+
    void SetStateManager(CPanelStateManager* manager)
    {
        m_stateManager = manager;
    }

    //+------------------------------------------------------------------+
    //| ポジション情報参照用の Model を設定                             |
    //+------------------------------------------------------------------+
    void SetPositionModel(CPositionModel* model)
    {
        m_positionModel = model;
    }
};

#endif // __CENTRY_EXECUTOR__
