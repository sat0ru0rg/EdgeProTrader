//+------------------------------------------------------------------+
//| CPositionModel.mqh                                               |
//| - 現在保有中のポジションをリアル市場から取得・管理する           |
//| - チケット一覧や保有状態、建値価格の取得などを提供              |
//+------------------------------------------------------------------+
#ifndef __CPOSITION_MODEL__
#define __CPOSITION_MODEL__

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
};

#endif // __CPOSITION_MODEL__
