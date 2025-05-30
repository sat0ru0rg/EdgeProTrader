//==============================
// 共通関数・環境設定・パラメータ定義（順に）
//==============================
#include <Common/CommonDefs.mqh>              
#include <Config/EPT_EnvConfig.mqh>           
#include <ParamDefs/EPT_BE_ExternParams.mqh>  

//==============================
// テスト対象クラス・モデル
//==============================
#include <Trade/CBEExecutor.mqh>              
#include <Logic/CPositionModel_mock.mqh>      

CBEExecutor beExecutor;
CPositionModel posModel;

//+------------------------------------------------------------------+
//| EA初期化関数：ここでテストを実行                                |
//+------------------------------------------------------------------+
int OnInit()
  {
   LOG_TEST_INFO("OnInit() called");
   RunTest();
   return INIT_SUCCEEDED;
  }

//+------------------------------------------------------------------+
//| テスト実行関数                                                  |
//+------------------------------------------------------------------+
void RunTest()
  {
   LOG_TEST_INFO("RunTest() begin");

   int ticket = GetTestTicket();

   if (ticket == -1)
     {
      LOG_TEST_ERROR("No valid ticket found. Aborting.");
      ExpertRemove();
      return;
     }

   LOG_TEST_INFO("Target ticket = " + IntegerToString(ticket));

   if (!OrderSelect(ticket, SELECT_BY_TICKET))
     {
      LOG_TEST_ERROR("OrderSelect failed for ticket " + IntegerToString(ticket));
      ExpertRemove();
      return;
     }

   int type = OrderType();
   string typeStr = (type == OP_BUY ? "BUY" : type == OP_SELL ? "SELL" : "OTHER");

   LOG_TEST_DEBUG("Order info:");
   LOG_TEST_DEBUG("  Symbol    = " + OrderSymbol());
   LOG_TEST_DEBUG("  Type      = " + typeStr);
   LOG_TEST_DEBUG("  Entry     = " + DoubleToString(OrderOpenPrice(), Digits));
   LOG_TEST_DEBUG("  SL        = " + DoubleToString(OrderStopLoss(), Digits));
   LOG_TEST_DEBUG("  Ticket    = " + IntegerToString(OrderTicket()));

   bool result = beExecutor.MoveSLToBEForTicket(ticket);

   if (result)
     {
      LOG_TEST_INFO("✅ BE実行成功");
     }
   else
     {
      LOG_TEST_ERROR("❌ BE実行失敗: " + beExecutor.GetLastErrorMessage());
     }

   LOG_TEST_INFO("RunTest() end");
   ExpertRemove();
  }

//+------------------------------------------------------------------+
//| 通貨ペア一致する最初のポジションを返す                          |
//+------------------------------------------------------------------+
int GetTestTicket()
  {
   for (int i = OrdersTotal() - 1; i >= 0; i--)
     {
      if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES))
        {
         if (OrderSymbol() == Symbol()) // Magic番号チェックなし
            return OrderTicket();
        }
     }
   return -1;
  }
