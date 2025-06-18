# EPT_interfaceMap.md

---

## 第1章. 概要

本ドキュメントは、EdgeProTraderプロジェクトにおける戦略Executor構造の基盤として設計された  
中間インターフェース（I/F）および共通ベースクラス `COrderExecutorBase` の定義集である。

本資料は主に以下の目的で使用される：

- 各Executorクラスが実装すべき機能インターフェースの一覧提示
- 責務ごとに分離されたI/Fの責任範囲の明確化
- 戦略の柔軟な組み合わせ・比較・切替を可能にする設計方針の保持
- `COrderExecutorBase` による共通パラメータ構造の一元管理

> 本ファイルは「戦略の中核エンジン構造」として、将来的な自動戦略生成・テンプレート構築にも再利用されることを想定している。

---

## 第2章. 中間インターフェース定義一覧

各インターフェースは、それぞれ明確な責務に基づいて定義されており、必要に応じてExecutorクラスが多重継承で機能統合する。

| I/F名                        | 主な責務                                      | 戦略分類           |
|------------------------------|-----------------------------------------------|--------------------|
| `IEntryOrderService`         | 成行発注／決済実行処理の抽象化（SendOrder, ClosePartial） | Entry（モック切替）|
| `IBEPriceCalculator`         | 建値（BreakEven）計算処理の抽象化              | 補助（BE）        |
| `IEntryValidator`            | エントリー条件の成立判定（ShouldEnterNow）      | Entry（可否判定） |
| `ISLModifier`                | SLの変更およびトレーリング処理                | Exit / 補助       |
| `IExitEvaluator`             | 即時決済の条件判定（ShouldExitNow）           | Exit              |
| `IPendingOrderPlacer`        | 指値・逆指値の発注（PlaceLimitOrder）         | Entry（予約系）   |
| `IPendingOrderCanceller`     | 予約注文の自動キャンセル                     | 補助              |

> ☑️ `IMarketOrderExecutor` は `IEntryOrderService` に統合されたため、削除済み。

---

## 第3章. COrderExecutorBase の構造

`COrderExecutorBase` は、すべてのExecutorクラスが共通して使用する基本パラメータ（symbol, lot, SL/TPなど）を一元管理する抽象ベースクラスである。

```cpp
class COrderExecutorBase
{
protected:
   string   m_symbol;
   double   m_volume;
   double   m_entryPrice;
   double   m_stopLoss;
   double   m_takeProfit;
   int      m_slippage;
   int      m_magic;
   string   m_comment;
   datetime m_expiration;
   string   m_lastError;

public:
   COrderExecutorBase() {}
   virtual ~COrderExecutorBase() {}

   string GetLastErrorMessage() { return m_lastError; }

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
```

本クラスを継承し、さらに必要なI/F（例：`IMarketOrderExecutor`, `ISLModifier` など）を多重継承して戦略クラスを構成する。

---

## 第4章. 今後の拡張指針

- インターフェースは、Exit戦略・トレーリング・条件付き撤退などに応じて順次追加される
- 将来的に `interface_cast<T>()` のようなView層からの呼び出し補助関数を導入し、動的な戦略切替が可能なUIと連携
- I/Fベース設計をテンプレート化することで、戦略テンプレとの構造的互換を実現する

> 本設計は、将来的なGPT提案戦略の自動生成や、エントリープラン選択UIとの統合基盤としても活用される予定である

---

以上
