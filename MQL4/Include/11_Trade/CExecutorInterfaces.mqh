//+------------------------------------------------------------------+
//| ファイル名 : CExecutorInterfaces.mqh                             |
//| 概要     : 戦略Executor用のインターフェース定義群               |
//| 役割     : 成行／予約注文・SL変更・条件付き決済などの機能を抽象化 |
//| 用途     : 各Executorクラスが必要な機能だけを実装可能にする     |
//| 出典     : 【実装対応】CExecutorInterfaces.mqhの定義             |
//+------------------------------------------------------------------+

#ifndef __C_EXECUTOR_INTERFACES__
#define __C_EXECUTOR_INTERFACES__

//--------------------------------------------------------------------
// IMarketOrderExecutor
//--------------------------------------------------------------------
// 成行注文や部分決済を行うインターフェース（Entry / Exit 両対応）
//--------------------------------------------------------------------
class IMarketOrderExecutor
{
public:
   virtual bool ExecuteMarketOrder(int type) = 0;
   // type: OP_BUY または OP_SELL
   // 戻り値: 成功時 true、失敗時 false

   virtual bool ClosePartial(int ticket, double lots) = 0;
   // ticket: 対象ポジションのチケット番号
   // lots: 決済するロット数（残ロットが0になると全決済扱い）
   // 戻り値: 成功時 true、失敗時 false

   virtual ~IMarketOrderExecutor() {}
};

//--------------------------------------------------------------------
// ISLModifier
//--------------------------------------------------------------------
// SL価格の変更、またはトレーリング処理の開始を提供するI/F
//--------------------------------------------------------------------
class ISLModifier
{
public:
   virtual bool ModifySLTo(double price) = 0;
   // price: 新しいSL価格
   // 戻り値: 成功時 true、失敗時 false

   virtual bool StartTrailing() = 0;
   // トレーリング処理を開始（設定済みロジックに従って実行）
   // 戻り値: 処理開始に成功すれば true

   virtual ~ISLModifier() {}
};

//--------------------------------------------------------------------
// IExitEvaluator
//--------------------------------------------------------------------
// 即時決済の判断を行うインターフェース（例：TP条件達成、足確定など）
//--------------------------------------------------------------------
class IExitEvaluator
{
public:
   virtual bool ShouldExitNow() = 0;
   // 現在の状態でExitすべきかを判定
   // 戻り値: Exit条件を満たす場合 true

   virtual ~IExitEvaluator() {}
};

//--------------------------------------------------------------------
// IEntryConditionEvaluator
//--------------------------------------------------------------------
// 発注前に条件（スプレッド・時間帯など）を検査するI/F
//--------------------------------------------------------------------
/*class IEntryConditionEvaluator
{
public:
   virtual bool ShouldEnterNow() = 0;
   // 発注条件をすべて満たす場合に true を返す

   virtual ~IEntryConditionEvaluator() {}
};
*/
//--------------------------------------------------------------------
// IPendingOrderPlacer
//--------------------------------------------------------------------
// 予約注文（BuyLimit / SellStopなど）を実行するインターフェース
//--------------------------------------------------------------------
class IPendingOrderPlacer
{
public:
   virtual bool PlaceLimitOrder(int type) = 0;
   // type: OP_BUYLIMIT / OP_SELLLIMIT
   // 戻り値: 発注に成功すれば true

   virtual bool PlaceStopOrder(int type) = 0;
   // type: OP_BUYSTOP / OP_SELLSTOP
   // 戻り値: 発注に成功すれば true

   virtual ~IPendingOrderPlacer() {}
};

//--------------------------------------------------------------------
// IPendingOrderCanceller
//--------------------------------------------------------------------
// 予約注文をキャンセルするI/F（例：有効期限切れ、自動撤退）
//--------------------------------------------------------------------
class IPendingOrderCanceller
{
public:
   virtual bool CancelPendingOrders() = 0;
   // 対象の予約注文をすべてキャンセル
   // 戻り値: 処理成功時 true

   virtual ~IPendingOrderCanceller() {}
};

#endif // __C_EXECUTOR_INTERFACES__
