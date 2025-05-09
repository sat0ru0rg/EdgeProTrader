## 第1章. このドキュメントの目的と適用範囲

本ドキュメントは、EdgeProTraderプロジェクトにおける「クラス設計書」として、Trade / Logic / View 各モジュールに属するクラスの責務・関数・依存関係を明確に定義するものである。

本設計書の目的は以下の通りである：

* v2.0仕様（`EPT_spec_v2.0.md`）に準拠したクラス構成を提示する
* クラスごとの責務とモジュール間の連携構造を明示する
* MQL4を前提としつつ、将来的なMQL5移植を見据えた拡張可能な構造を示す

### 1.1 適用対象

* 対象フェーズ：Entry（取引支援）
* 対象モジュール：View / Logic / Trade
* 対応プラットフォーム：MQL4（将来的にMQL5へ移行）
* 関連ファイル群：`CEntryPanel.mqh`, `CEntryExecutor.mqh`, `CPanelStateManager.mqh` など

---

## 第2章. Viewモジュール設計

### 2.1 CEntryPanel

* **役割**：チャート上のUIパネルを描画し、ボタン操作を受け取る
* **主な関数**：

  * `void CreateButtons()`：初期ボタン群の描画
  * `void OnClick(string buttonName)`：ボタン押下時の処理分岐
  * `void UpdateUIState(string newState)`：状態変化に応じたボタン状態更新
* **依存クラス**：

  * `CPanelStateManager`（状態判定）
  * `CEntryExecutor`, `CBEExecutor`（発注処理）

### 2.2 ChartRenderer

* **役割**：TP/SLライン、損益ラベルなどをチャートに描画・更新する
* **主な関数**：

  * `void DrawTPLine(string symbol, double tpPrice)`
  * `void UpdatePipsLabel(int ticket, double pips, string color)`
  * `void FinalizeTradeDisplay(int ticket)`
* **備考**：最大5件の取引履歴の視覚表示に対応

---

## 第3章. Logicモジュール設計

### 3.1 CPanelStateManager

* **役割**：ボタン状態の可否を判定し、パネルの内部状態を管理する
* **主な関数**：

  * `void UpdateState(string newState)`
  * `string GetCurrentState()`
  * `bool IsActiveState(string checkState)`
* **依存クラス**：

  * `CPositionModel`（ポジション有無）
  * `CEntryValidator`（エントリー条件）

### 3.2 CEntryValidator

* **役割**：スプレッドや取引時間などの発注条件をチェックする
* **主な関数**：

  * `bool IsTradableTime(datetime now)`
  * `bool IsSpreadAcceptable(double spread)`

### 3.3 CPositionModel

* **役割**：保有ポジションの有無やエントリー価格などの情報を取得する
* **主な関数**：

  * `bool HasOpenPosition(string symbol)`
  * `double GetEntryPrice(string symbol)`
  * `int GetTicket(string symbol)`

### 3.4 CRiskManager

* **役割**：リスク許容範囲に応じたロット計算を行う
* **主な関数**：

  * `double CalculateRiskLot(...)`
  * `double GetUsedLot()`
* **依存関数**：`RiskHelper.mqh` の補助関数を使用

---

## 第4章. Tradeモジュール設計（再構成）

### 4.1 COrderExecutorBase

* **役割**：すべてのExecutorクラスが共通して使用するパラメータ群（symbol, lot, SL/TP, commentなど）を一元管理する抽象基底クラス
* **主な関数**：
  * `void SetSymbol(string symbol)`
  * `void SetVolume(double volume)`
  * `string GetLastErrorMessage()`
* **備考**：
  * 他のすべてのExecutorはこのクラスを継承することで、共通のパラメータ初期化が可能

---

### 4.2 Executorインターフェース群（CExecutorInterfaces.mqh）

* **定義済みI/F**（複数継承可能）：
  * `IMarketOrderExecutor`：成行エントリー／部分決済
  * `ISLModifier`：SL変更・トレーリング処理
  * `IPendingOrderPlacer`：予約注文エントリー
  * `IExitEvaluator`：条件付きExit判定
  * `IEntryConditionEvaluator`：スプレッド・時間帯などの事前検証

---

### 4.3 派生Executorクラス群

| クラス名                 | 実装I/F例                          | 主な責務                       |
|--------------------------|-----------------------------------|------------------------------|
| `CEntryExecutor`         | `IMarketOrderExecutor`            | 成行注文（SHORT / LONG）         |
| `CBEExecutor`            | `ISLModifier`                     | 建値移動（SLをBEに変更）         |
| `CPendingEntryExecutor`  | `IPendingOrderPlacer`             | 指値エントリー（PLAN対応）       |
| `CExitExecutor`          | `IExitEvaluator`, `ISLModifier`   | 条件付き撤退 or 分割決済         |
| `CTrailSLExecutor`       | `ISLModifier`                     | トレーリングSL自動処理           |

* **備考**：
  * 各クラスは必要なI/Fのみを実装する
  * View層からは `interface_cast<>` 風の処理で呼び出し機能を判別

---

### 4.4 ファイル構成（Include/Trade）

```plaintext
Include/
└── Trade/
    ├── COrderExecutorBase.mqh
    ├── CEntryExecutor.mqh
    ├── CBEExecutor.mqh
    ├── CPendingEntryExecutor.mqh
    ├── CExitExecutor.mqh
    ├── CTrailSLExecutor.mqh
    └── CExecutorInterfaces.mqh

---

## 第5章. 補助モジュール

### 5.1 RiskHelper.mqh

* **役割**：リスク率に基づくロット数計算、ロット丸め処理など
* **主な関数**：

  * `double CalcLotByRisk(...)`
  * `double RoundLotToStep(double lot)`
* **使用元**：`CRiskManager`

### 5.2 PriceCalculator.mqh

* **役割**：エントリー価格・SL・TP価格の計算
* **主な関数**：

  * `double CalcSLFromEntry(...)`
  * `double CalcTPFromEntry(...)`
* **使用元**：`CEntryExecutor`, `CBEExecutor`

### 5.3 CommonDefs.mqh

* **役割**：定数、色、補助演算関数などを定義
* **主な関数／定義**：

  * `#define EPT_VERSION "v1.5"`
  * `int PipsToPoints(...)`
  * `double NormalizeLot(...)`
* **使用元**：全体共通

---

## 第6章. クラス間依存マトリクスと連携図

```
CEntryPanel ─────▶ CPanelStateManager
             ├──▶ CEntryExecutor
             └──▶ CBEExecutor

CEntryExecutor ──▶ CRiskManager
               ├▶ CEntryValidator
               └▶ PriceCalculator

CBEExecutor ─────▶ CPositionModel
              └▶ PriceCalculator

CPanelStateManager ─▶ CPositionModel
                    └▶ CEntryValidator
```

---

## 第7章. 補足・関連ドキュメント

### 7.1 注意事項

* 各クラスは「1クラス1責務」原則を遵守し、状態やUIへの依存を最小限にする
* View層はMQL4/5の違いを吸収できるよう、今後Baseクラス導入を検討する

### 7.2 参照ドキュメント一覧

* `EPT_spec_v2.0.md`：上位仕様書
* `EPT_Class_v1.5.md`：v1.5旧構成のクラス設計リファレンス
* `EPT_spec_StructureDesign.md`：3層分離の設計思想
* `EPT_spec_ModuleSharedMap_v1.0_Final.md`：MQL4/5共通化評価
* `EPT_spec_MQL_Designs.md`：MQL設計仕様書（#ifdef制御含む）
