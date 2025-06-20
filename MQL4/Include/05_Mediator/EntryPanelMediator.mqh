//+------------------------------------------------------------------+
//| EntryPanelMediator.mqh                                          |
//| PanelControllerからのUI操作要求をEntryMediatorに中継する層       |
//+------------------------------------------------------------------+
#ifndef __ENTRY_PANEL_MEDIATOR__
#define __ENTRY_PANEL_MEDIATOR__

#include <05_Mediator/EntryMediator.mqh>
#include <00_Common/CommonDefs.mqh>

class EntryPanelMediator
{
private:
    EntryMediator* m_entryMediator;

public:
    EntryPanelMediator()
    {
        m_entryMediator = NULL;
    }

    void setEntryMediator(EntryMediator* mediator)
    {
        m_entryMediator = mediator;
    }

    void onLongEntryRequested()
    {
        LOG_ACTION_INFO_C("[PanelMediator] LONGリクエスト受信");
        if (m_entryMediator != NULL)
            m_entryMediator.onBuyClicked();
        else
            LOG_ACTION_ERROR_C("EntryMediatorが未設定です");
    }

    void onShortEntryRequested()
    {
        LOG_ACTION_INFO_C("[PanelMediator] SHORTリクエスト受信");
        if (m_entryMediator != NULL)
            m_entryMediator.onSellClicked();
        else
            LOG_ACTION_ERROR_C("EntryMediatorが未設定です");
    }
};

#endif // __ENTRY_PANEL_MEDIATOR__