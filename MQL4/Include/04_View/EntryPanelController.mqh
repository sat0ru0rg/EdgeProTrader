//+------------------------------------------------------------------+
//| EntryPanelController.mqh                                         |
//| View層（TestPanel）のUI操作を受け取るControllerクラス             |
//| 呼び出し元：TestPanelなど                                        |
//+------------------------------------------------------------------+
#ifndef __ENTRY_PANEL_CONTROLLER__
#define __ENTRY_PANEL_CONTROLLER__

#include <05_Mediator/EntryPanelMediator.mqh>
#include <00_Common/CommonDefs.mqh>

class EntryPanelController
{
private:
    EntryPanelMediator* m_panelMediator;

public:
    EntryPanelController()
    {
        m_panelMediator = NULL;
    }

    void setPanelMediator(EntryPanelMediator* mediator)
    {
        m_panelMediator = mediator;
    }

    void onLongButtonClick()
    {
        LOG_ACTION_INFO_C("[PanelController] LONGボタン受信");
        if (m_panelMediator != NULL)
            m_panelMediator.onLongEntryRequested();
        else
            LOG_ACTION_ERROR_C("PanelMediatorが未設定です");
    }

    void onShortButtonClick()
    {
        LOG_ACTION_INFO_C("[PanelController] SHORTボタン受信");
        if (m_panelMediator != NULL)
            m_panelMediator.onShortEntryRequested();
        else
            LOG_ACTION_ERROR_C("PanelMediatorが未設定です");
    }
};

#endif // __ENTRY_PANEL_CONTROLLER__