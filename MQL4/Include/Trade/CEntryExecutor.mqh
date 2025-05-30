//+------------------------------------------------------------------+
//| CEntryExecutor.mqh                                               |
//| - 成行エントリーおよび部分決済を行うExecutor                    |
//| - IMarketOrderExecutor を実装                                   |
//+------------------------------------------------------------------+

#ifndef __CENTRY_EXECUTOR__
#define __CENTRY_EXECUTOR__

#include <Common/CommonDefs.mqh>
#include <Trade/COrderExecutorBase.mqh>
#include <Trade/CExecutorInterfaces.mqh>

// class CEntryExecutor : public COrderExecutorBase, public IMarketOrderExecutor
// CExecutorInterfaces.mqh は単なる「役割のガイド」として維持
// MQL5ではここを正式な interface に再昇格させる
class CEntryExecutor : public COrderExecutorBase
{
protected:
    CPanelStateManager* m_stateManager;

public:
   CEntryExecutor() {}
   virtual ~CEntryExecutor() {}

   // 成行エントリー実行（OP_BUY / OP_SELL）
    bool ExecuteMarketOrder(int type)
    {
        LOG_ACTION_DEBUG("CEntryExecutor::ExecuteMarketOrder START");
    
        RefreshRates();
        double price = (type == OP_BUY) ? MarketInfo(m_symbol, MODE_ASK)
                                        : MarketInfo(m_symbol, MODE_BID);
    
        double sl = (type == OP_BUY) ? price - PipToPrice(m_symbol, m_stopLoss)
                                     : price + PipToPrice(m_symbol, m_stopLoss);
        
        double tp = (type == OP_BUY) ? price + PipToPrice(m_symbol, m_takeProfit)
                                     : price - PipToPrice(m_symbol, m_takeProfit);
    
        LOG_ACTION_INFO("価格: " + DoubleToString(price, 5));
        LOG_ACTION_INFO("SL: " + DoubleToString(sl, 5));
        LOG_ACTION_INFO("TP: " + DoubleToString(tp, 5));
    
        int ticket = OrderSend(
            m_symbol,
            type,
            m_volume,
            price,
            m_slippage,
            sl,
            tp,
            m_comment,
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
        
        // ✅ 状態通知の診断ログ
        if (m_stateManager != NULL)
        {
            LOG_ACTION_DEBUG("[Notify] stateManager.OnEntryExecuted() 呼び出し開始");
            m_stateManager.OnEntryExecuted();
        }
        else
        {
            LOG_ACTION_ERROR("[Notify] m_stateManager が NULL。状態通知できません");
        }

        return true;

    }
    
    
       // 部分決済処理（ClosePartial）
    bool ClosePartial(int ticket, double lots)
    {
        LOG_ACTION_DEBUG("ClosePartial START");
        
        LOG_ACTION_DEBUG("ClosePartial: OrderSelect(ticket=" + IntegerToString(ticket) + ")");
        if (!OrderSelect(ticket, SELECT_BY_TICKET))
        {
            m_lastError = "OrderSelect failed: " + IntegerToString(GetLastError());
            LOG_ACTION_ERROR(m_lastError);
            return false;
        }
        
        double closePrice = (OrderType() == OP_BUY) ? MarketInfo(OrderSymbol(), MODE_BID)
                                                    : MarketInfo(OrderSymbol(), MODE_ASK);
        
        LOG_ACTION_DEBUG("ClosePartial: OrderClose(ticket=" + IntegerToString(ticket) + ", lots=" + DoubleToString(lots, 2) + ")");
        
        bool result = OrderClose(ticket, lots, closePrice, m_slippage, clrRed);
        
        if (!result)
        {
            m_lastError = "OrderClose failed: " + IntegerToString(GetLastError());
            LOG_ACTION_ERROR(m_lastError);
            return false;
        }
        
        LOG_ACTION_INFO("CEntryExecutor::ClosePartial success");
        
        if (m_stateManager != NULL)
        {
            LOG_ACTION_DEBUG("[Notify] stateManager.OnPositionClosed() 呼び出し開始");
            m_stateManager.OnPositionClosed();
        }
        else
        {
            LOG_ACTION_ERROR("[Notify] m_stateManager が NULL。状態通知できません");
        }
    
        return true;

    }
    
    void SetStateManager(CPanelStateManager* manager)
    {
        m_stateManager = manager;
    }
    
};

#endif
