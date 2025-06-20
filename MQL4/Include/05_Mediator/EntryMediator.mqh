//+------------------------------------------------------------------+
//| EntryMediator.mqh                                               |
//| ViewとEntryControllerを仲介するMediatorクラス                    |
//| 呼び出し元：CEntryPanelなどのView層                             |
//+------------------------------------------------------------------+
#ifndef __ENTRY_MEDIATOR__
#define __ENTRY_MEDIATOR__

#include <06_Controller/EntryController.mqh>
#include <00_Common/CommonDefs.mqh>
#include <01_Config/EPT_EnvConfig.mqh>

class EntryMediator
{
private:
    EntryController* m_entryController;

public:
    EntryMediator()
    {
        m_entryController = NULL;
    }

    void setEntryController(EntryController* controller)
    {
        m_entryController = controller;
    }

    /// @brief BUYボタン押下時の処理
    void onBuyClicked()
    {
        LOG_ACTION_INFO_C("[Mediator] BUYクリック受信");

        if (m_entryController == NULL)
        {
            LOG_ACTION_ERROR_C("EntryControllerが未設定です");
            return;
        }

        m_entryController.executeEntry("BUY");
        m_entryController.updateEntryUI();
    }

    /// @brief SELLボタン押下時の処理
    void onSellClicked()
    {
        LOG_ACTION_INFO_C("[Mediator] SELLクリック受信");

        if (m_entryController == NULL)
        {
            LOG_ACTION_ERROR_C("EntryControllerが未設定です");
            return;
        }

        m_entryController.executeEntry("SELL");
        m_entryController.updateEntryUI();
    }

    /// @brief エントリー可能かどうかの問い合わせ
    bool canEnter()
    {
        if (m_entryController == NULL)
        {
            LOG_ACTION_ERROR_C("EntryControllerが未設定です");
            return false;
        }

        return m_entryController.canEnter();
    }
};

#endif // __ENTRY_MEDIATOR__
