//+------------------------------------------------------------------+
//| COrderExecutorBase.mqh                                          |
//| 共通パラメータ管理用 抽象基底クラス（全Executorの親クラス）         |
//| Modules: Include/Trade/                                         |
//| - symbol, lot, SL/TP, magic, slippage, comment等を集中管理           |
//| - 派生クラス：CEntryExecutor, CBEExecutor など                  |
//+------------------------------------------------------------------+
#ifndef __CORDEREXECUTORBASE__
#define __CORDEREXECUTORBASE__

// 共通のパラメータを定義したベースクラス（UI/ロジックからの初期化対象）
class COrderExecutorBase {
protected:
   string   m_symbol;      // 通貨ペアシンボル（例："USDJPY"）
   double   m_volume;      // ロットサイズ（発注数量）
   double   m_entryPrice;  // 想定エントリー価格（※参考値）
   double   m_stopLoss;    // ストップロス価格（損切）
   double   m_takeProfit;  // テイクプロフィット価格（利確）
   int      m_slippage;    // 許容スリッページ（ピップス）
   int      m_magic;       // マジックナンバー（EA識別用）
   string   m_comment;     // 発注コメント（ログ識別用）
   datetime m_expiration;  // 予約注文などの有効期限（使用される場合）
   string   m_lastError;   // 直近のエラー内容記録（ログ・UI表示用）

public:
   // コンストラクタ（特に初期処理なし）
   COrderExecutorBase() {}

   // 仮想デストラクタ（将来の派生クラスで適切に動作させるため）
   virtual ~COrderExecutorBase() {}

   //----------------------------
   // Getter系関数（外部から取得）
   //----------------------------
   string   GetSymbol()        const { return m_symbol; }
   double   GetVolume()        const { return m_volume; }
   double   GetEntryPrice()    const { return m_entryPrice; }
   double   GetStopLoss()      const { return m_stopLoss; }
   double   GetTakeProfit()    const { return m_takeProfit; }
   int      GetSlippage()      const { return m_slippage; }
   int      GetMagic()         const { return m_magic; }
   string   GetComment()       const { return m_comment; }
   datetime GetExpiration()    const { return m_expiration; }
   string   GetLastErrorMessage() const { return m_lastError; }

   //----------------------------
   // Setter系関数（初期化・更新）
   //----------------------------
   void SetSymbol(string s)       { m_symbol = s; }
   void SetVolume(double v)       { m_volume = v; }
   void SetEntryPrice(double p)   { m_entryPrice = p; }
   void SetStopLoss(double sl)    { m_stopLoss = sl; }
   void SetTakeProfit(double tp)  { m_takeProfit = tp; }
   void SetSlippage(int slip)     { m_slippage = slip; }
   void SetMagic(int m)           { m_magic = m; }
   void SetComment(string c)      { m_comment = c; }
   void SetExpiration(datetime e) { m_expiration = e; }
};

#endif // __CORDEREXECUTORBASE__
