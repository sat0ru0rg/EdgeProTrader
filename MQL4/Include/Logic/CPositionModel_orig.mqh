#ifndef __CPOSITIONMODEL_MOCK__
#define __CPOSITIONMODEL_MOCK__

class CPositionModel
{
private:
    // モック用フラグとデータ
    bool useMock;
    bool mockHasPosition;
    bool mockBECondition;

public:
    CPositionModel()
    {
       useMock = false;
       mockHasPosition = false;
       mockBECondition = false;

    }

    // ▼ モック切替と設定
    void enableMock(bool enable)              { useMock = enable; }
    void setMockPosition(bool on)             { mockHasPosition = on; }
    void setMockBECondition(bool on)          { mockBECondition = on; }

    // ▼ モック利用：保有ポジションの有無（CPanelStateManager用）
    bool HasOpenPosition(string symbol)
    {
        if (useMock)
            return mockHasPosition;

        int tickets[];
        return GetPositionTickets(symbol, tickets) > 0;
    }

    // ▼ モック利用：BE条件成立判定
    bool IsBEConditionSatisfied()
    {
        return useMock ? mockBECondition : false; // 実装未定義のためfalse
    }

    // ▼ 共通処理：チケット配列取得
    int GetPositionTickets(string symbol, int& tickets[])
    {
        int count = 0;
        for (int i = OrdersTotal() - 1; i >= 0; i--)
        {
            if (!OrderSelect(i, SELECT_BY_POS, MODE_TRADES)) continue;
            if (OrderSymbol() != symbol) continue;

            int type = OrderType();
            if (type != OP_BUY && type != OP_SELL) continue;

            ArrayResize(tickets, count + 1);
            tickets[count++] = OrderTicket();
        }
        return count;
    }

    // ▼ スロット操作系（CPanelStateManager連携用）
    bool hasOpenPosition(int slot)
    {
        int tickets[];
        if (GetPositionTickets(Symbol(), tickets) <= slot)
            return false;
        return true;
    }

    int getOpenPositionCount()
    {
        int tickets[];
        return GetPositionTickets(Symbol(), tickets);
    }

    int getTicket(int slot)
    {
        int tickets[];
        if (GetPositionTickets(Symbol(), tickets) <= slot)
            return -1;
        return tickets[slot];
    }

    double getEntryPrice(int slot)
    {
        int ticket = getTicket(slot);
        if (ticket < 0 || !OrderSelect(ticket, SELECT_BY_TICKET))
            return 0.0;
        return OrderOpenPrice();
    }

    int getOrderType(int ticket)
    {
        if (!OrderSelect(ticket, SELECT_BY_TICKET))
            return -1;
        return OrderType();
    }

    double getSL(int ticket)
    {
        if (!OrderSelect(ticket, SELECT_BY_TICKET)) return 0.0;
        return OrderStopLoss();
    }
    
    bool HasAnyOpenPosition()
    {
        return HasOpenPosition(Symbol());
    }
    
    int GetLatestOpenTicket()
    {
        int tickets[];
        if (GetPositionTickets(Symbol(), tickets) > 0)
            return tickets[0];
        return -1;
    }
    
    int GetOrderType(int ticket)
    {
        return getOrderType(ticket);
    }

};

#endif
