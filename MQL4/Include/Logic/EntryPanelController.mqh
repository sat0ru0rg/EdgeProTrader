//+------------------------------------------------------------------+
//| EntryPanelController.mqh                                         |
//| - CEntryPanel（View）とLogic層（Executor/StateManager）を接続     |
//| - ユーザー操作に基づく状態管理・発注指示を統括する中間制御層     |
//+------------------------------------------------------------------+

#ifndef __ENTRY_PANEL_CONTROLLER__
#define __ENTRY_PANEL_CONTROLLER__

#include <Logic/CPositionModel.mqh>
#include <Logic/CPanelStateManager.mqh>
#include <Trade/CEntryExecutor.mqh>

class EntryPanelController
{
private:
   CPanelStateManager m_stateManager;
   CEntryExecutor     m_executor;
   CPositionModel     m_positionModel; 

public:
   EntryPanelController() {}

   // 初期化処理（ユースケース用の固定値）
   void Initialize()
   {
      m_executor.SetSymbol(_Symbol);
      m_executor.SetVolume(0.1);
      m_executor.SetSlippage(3);
      m_executor.SetStopLoss(30);   // 30 pips
      m_executor.SetTakeProfit(60); // 60 pips
      m_executor.SetStateManager(&m_stateManager);
   }

   // SLライン表示（View層ボタン押下想定）
   void OnSLButtonClicked()
   {
      m_stateManager.OnSLLineShown();
   }

   // エントリーボタン押下
   void OnEntryButtonClicked()
   {
      m_executor.ExecuteMarketOrder(OP_BUY);
   }

   // 決済ボタン押下（固定チケットを前提）
    void OnCloseButtonClicked()
    {
        int tickets[1];
        if (m_positionModel.GetPositionTickets(_Symbol, tickets))
            m_executor.ClosePartial(tickets[0], 0.1);
    }


   // 状態取得（テスト用）
   string GetCurrentState()
   {
      return m_stateManager.GetCurrentState();
   }
};

#endif // __ENTRY_PANEL_CONTROLLER__
