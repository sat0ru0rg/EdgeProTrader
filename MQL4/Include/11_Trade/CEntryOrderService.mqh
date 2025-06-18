#ifndef __CENTRYORDERSERVICE__
#define __CENTRYORDERSERVICE__

#define __CLASS__ "CEntryOrderService"

#include <01_Config/EPT_EnvConfig.mqh>

class CEntryOrderService
{
private:
    string m_lastError;

public:
    string GetLastErrorMessage() { return m_lastError; }

    bool ExecuteOrder(
        string symbol,
        int opType,
        double lot,
        double entryPrice,
        int slippage,
        double stopLoss,
        double takeProfit,
        string comment,
        int magic
    )
    {
        int ticket = OrderSend(
            symbol, opType, lot, entryPrice, slippage,
            stopLoss, takeProfit, comment, magic, 0,
            (opType == OP_BUY ? clrBlue : clrRed)
        );

        if (ticket < 0)
        {
            m_lastError = "OrderSend failed: err=" + IntegerToString(GetLastError());
            LOG_ACTION_ERROR_C(m_lastError);
            return false;
        }

        LOG_ACTION_INFO_C("OrderSend success: ticket=" + IntegerToString(ticket));
        return true;
    }
};

#endif // __CENTRYORDERSERVICE__
