#ifndef __CPOSITION_MODEL__
#define __CPOSITION_MODEL__

#include <00_Common/CommonDefs.mqh>  // EntryMode 定義用

class CPositionModel
{
public:
   CPositionModel() {}

   //+------------------------------------------------------------+
   //| 現在保有中の全ポジションのチケット一覧を取得               |
   //| symbol: 通貨ペアフィルター                                  |
   //| tickets[]: 出力配列（事前に十分なサイズが必要）             |
   //+------------------------------------------------------------+
   bool GetPositionTickets(string symbol, int &tickets[])
   {
      int count = 0;
      ArrayInitialize(tickets, -1);

      for (int i = OrdersTotal() - 1; i >= 0; i--)
      {
         if (!OrderSelect(i, SELECT_BY_POS, MODE_TRADES))
            continue;

         if (OrderSymbol() != symbol)
            continue;

         int type = OrderType();
         if (type != OP_BUY && type != OP_SELL)
            continue;

         tickets[count++] = OrderTicket();
      }

      return (count > 0);
   }

    //+------------------------------------------------------------------+
    //| 指定コメント付きでポジションが存在するか                         |
    //+------------------------------------------------------------------+
    bool HasOpenPosition(string symbol, string comment)
    {
        for (int i = OrdersTotal() - 1; i >= 0; i--)
        {
            if (!OrderSelect(i, SELECT_BY_POS, MODE_TRADES))
                continue;
    
            if (OrderSymbol() != symbol)
                continue;
    
            if (StringFind(OrderComment(), comment) != 0)  // 先頭一致
                continue;
    
            if (OrderType() == OP_BUY || OrderType() == OP_SELL)
                return true;
        }
        return false;
    }

   //+------------------------------------------------------------+
   //| 保有ポジションが存在するか                                  |
   //| symbol: 通貨ペアフィルター                                  |
   //+------------------------------------------------------------+
   bool HasOpenPosition(string symbol)
   {
      int dummy[1];
      return GetPositionTickets(symbol, dummy);
   }

   //+------------------------------------------------------------+
   //| 指定チケットの建値価格を取得                                |
   //+------------------------------------------------------------+
   double GetEntryPrice(int ticket)
   {
      if (OrderSelect(ticket, SELECT_BY_TICKET))
         return OrderOpenPrice();

      return -1;
   }

   //+------------------------------------------------------------+
   //| チケットが有効なBUYポジションか判定                         |
   //+------------------------------------------------------------+
   bool IsBuy(int ticket)
   {
      if (!OrderSelect(ticket, SELECT_BY_TICKET))
         return false;

      return (OrderType() == OP_BUY);
   }

   //+------------------------------------------------------------+
   //| チケットが有効なSELLポジションか判定                        |
   //+------------------------------------------------------------+
   bool IsSell(int ticket)
   {
      if (!OrderSelect(ticket, SELECT_BY_TICKET))
         return false;

      return (OrderType() == OP_SELL);
   }

    //+------------------------------------------------------------------+
    //| 指定コメント付きのチケット番号を返す（最初に見つかったもの）   |
    //+------------------------------------------------------------------+
    int GetOpenTicket(string symbol, string comment)
    {
        for (int i = OrdersTotal() - 1; i >= 0; i--)
        {
            if (!OrderSelect(i, SELECT_BY_POS, MODE_TRADES))
                continue;
    
            if (OrderSymbol() != symbol)
                continue;
    
            if (StringFind(OrderComment(), comment) != 0)
                continue;
    
            if (OrderType() == OP_BUY || OrderType() == OP_SELL)
                return OrderTicket();
        }
        return -1;
    }


   //+------------------------------------------------------------+
   //| EntryModeに対応した保有チケットを1件取得（現状BUY固定）     |
   //| ※拡張時は OrderComment に ENTRY_1 等を記録し判別            |
   //+------------------------------------------------------------+
   int GetOpenTicket(EntryMode mode)
   {
      int tickets[10];
      if (!GetPositionTickets(_Symbol, tickets))
         return -1;

      for (int i = 0; i < ArraySize(tickets); i++)
      {
         if (tickets[i] == -1) continue;

         if (OrderSelect(tickets[i], SELECT_BY_TICKET) &&
             OrderType() == OP_BUY)  // 今後は mode に応じて分岐予定
         {
            return tickets[i];
         }
      }
      return -1;
   }
   
   int CountOpenPositions(string symbol, string comment)
    {
        int count = 0;
        for (int i = 0; i < OrdersTotal(); i++)
        {
            if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES))
            {
                if (OrderSymbol() == symbol && StringFind(OrderComment(), comment) == 0)
                    count++;
            }
        }
        return count;
    }

   
    //+------------------------------------------------------------------+
    //| 保有中のポジション数を返す（symbol単位）                        |
    //+------------------------------------------------------------------+
    int CountOpenPositions(string symbol)
    {
        int count = 0;
        for (int i = OrdersTotal() - 1; i >= 0; i--)
        {
            if (!OrderSelect(i, SELECT_BY_POS, MODE_TRADES))
                continue;
    
            if (OrderSymbol() != symbol)
                continue;
    
            int type = OrderType();
            if (type != OP_BUY && type != OP_SELL)
                continue;
    
            count++;
        }
    
        return count;
    }

};

#endif // __CPOSITION_MODEL__
