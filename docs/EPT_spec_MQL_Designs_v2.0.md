# EPT_spec_MQL_Designs_v2.0.md

---

## 第1章. ドキュメントの目的と適用範囲

本ドキュメントは、EdgeProTraderプロジェクトにおける **MQL4 / MQL5 対応を前提とした実装設計仕様**を定義するものであり、以下の目的を持つ：

- プラットフォーム差異の影響を最小限に抑えた統一構造の設計指針を提示
- 各クラス・モジュールの共通化／分離方針を明文化し、保守性と拡張性を両立
- MQL5移行時にも参照可能な「構造リファレンス」として機能

### 1.1 適用対象

- 対象フェーズ：Entry（計画・記録・分析は別設計書にて管理）
- 対象モジュール：View / Logic / Trade 層
- 対象プラットフォーム：MQL4（初期実装） / MQL5（段階移行）
- 対象ファイル：`Experts/`, `Include/` 配下のクラス・ヘッダー構造

---

## 第2章. MQL構造と設計思想

EdgeProTraderにおけるMQL実装は、「View / Logic / Trade」の**三層構造アーキテクチャ**を基本として構成される。

### 2.1 モジュール構成（役割分離）

| 層名    | 主な責務 | 含まれる代表クラス例 |
|--------|----------|----------------------|
| View   | ユーザー操作／チャートUI | `CEntryPanel`, `ChartRenderer` |
| Logic  | 状態管理／判定処理 | `CPanelStateManager`, `CEntryValidator`, `CPositionModel`, `CRiskManager` |
| Trade  | 発注・決済の実行処理 | `CEntryExecutor`, `CBEExecutor` |

> 各層は1クラス1責務を原則とし、OOP構造に基づく明確な分離を行う。

### 2.2 プラットフォーム非依存戦略

- **View層**はUI方式の違いにより**分離実装**
- **Logic/Trade層**は条件付きプリプロセッサによる**統一クラス化**
- 全モジュールは `/Include/` 配下に配置し、役割別ディレクトリで再利用性と保守性を確保する

### 2.3 移植・再利用における設計方針

- MQL4/5間のAPI差分をクラス内部で吸収（`#ifdef`使用）
- ロジック層は Exit, Journal など他フェーズにも流用可能な構造で設計
- 将来的には `CEntryPanelBase`, `CPositionModelBase` などの共通I/Fを導入予定

---

## 第3章. クラス別設計指針と分岐対応

本章では、EdgeProTraderのMQL4/5両対応を前提としたクラス設計において、View/Logic/Trade層の各クラスに関する**差異・共通化方針**を整理する。

### 3.1 クラスごとの実装比較表

| クラス名              | モジュール | 主な責務                             | MQL4実装           | MQL5実装            | 共通化評価 | 今後の指針 |
|-----------------------|------------|--------------------------------------|---------------------|----------------------|-------------|------------|
| `CEntryPanel`         | View       | パネルUI描画＋操作受信               | OBJ_LABEL系         | CDialog派生          | ❌ UI別実装 | 将来 `CEntryPanelBase` 導入予定 |
| `ChartRenderer`       | View       | TP/SL/ラベル描画                     | ObjectCreate        | 同左（共通）         | ✅ 共通API  | 完全共通化済み               |
| `CPanelStateManager`  | Logic      | UI状態の判定・遷移                   | 実装中              | 実装中               | ✅ ロジック共通 | `/Logic/` 配置で共通管理     |
| `CEntryValidator`     | Logic      | スプレッド／時間帯など事前条件の判定 | 未実装              | 未実装               | ✅ ロジック共通 | `/Logic/` 配置で共通管理     |
| `CPositionModel`      | Logic      | 保有ポジション抽象化                 | OrderSelect         | PositionGet          | 🟡 API差異  | API吸収構造で共通化可       |
| `CRiskManager`        | Logic      | 許容ロットサイズの計算               | 実装済              | 実装済               | ✅ 完全共通  | 共通ヘッダー `Logic/` に配置 |
| `CPriceCalculator`     | Logic      | SL/TP価格計算                        | 実装済              | 実装済               | ✅ 完全共通  | 補助クラスとして活用         |
| `COrderExecutorBase`      | Trade      | パラメータ共通基底クラス               | 実装済            | 同左（共通）         | ✅ 完全共通  | すべてのExecutorの基盤 |
| `CEntryExecutor`          | Trade      | 成行発注の実装                         | `OrderSend`      | `CTrade.Buy/Sell`   | ✅ 条件分岐  | `IMarketOrderExecutor` 実装 |
| `CBEExecutor`             | Trade      | 建値移動の実装                         | `OrderModify`    | `CTrade.PositionModify` | ✅ 条件分岐  | `ISLModifier` 実装 |
| `CPendingEntryExecutor`   | Trade      | 予約エントリー                         | OrderSend+type   | CTrade.BuyLimit等   | ✅ 条件分岐  | `IPendingOrderPlacer` 実装 |
| `CExitExecutor`           | Trade      | 条件付き撤退                           | OrderCloseなど    | CTrade.PositionClose | ✅ 条件分岐  | `IExitEvaluator` 実装予定 |
markdown
コピーする
編集する
## 第5章. 実装ディレクトリ構成と再利用戦略（追記）

---

### 3.2 層別の共通化方針

#### ■ View層
- **唯一非互換クラス：`CEntryPanel`**
  - MQL4：OBJ_描画による擬似UI
  - MQL5：CDialog＋CButton による標準UI
  - → 当面は分離実装。将来的に `CEntryPanelBase` による共通I/F抽象化を検討

#### ■ Logic層
- **すべてのクラスが共通化可能**
  - `CEntryValidator`, `CPanelStateManager` は MQL非依存ロジック
  - `CPositionModel` のみ内部API抽象化が必要だが、共通構造で管理可能
  - → `/Include/Logic/` にて統一実装

#### ■ Trade層
- **API差異は条件付きプリプロセッサで吸収**
  - `CEntryExecutor`, `CBEExecutor` は `#ifdef __MQL5__` による分岐で1ファイル共通実装
  - 抽象ベース：`COrderExecutorBase` によって I/F 統一
  - → `/Include/Trade/` 配下に格納し、構造分離と共通管理を両立

---

### 3.3 共通設計の要点

- 共通化範囲はView以外に集中しており、**ロジック・実行処理の8割以上は1ソースで対応可能**
- MQL5移行を見据えた設計のため、**今後の保守コスト・移植負荷を大幅に軽減**
- すべてのクラスにおいて「責務明確・役割分離・MQL吸収」の3原則を徹底

---

> 参考ドキュメント：  
> `EPT_spec_ModuleSharedMap_v1.0_Final.md`,  
> `EPT_Class_v1.5.md`,  
> `EPT_spec_StructureDesign.md`,  
> `EPT_transitionPack.md`

---

## 第4章. API差分一覧と統合マッピング

本章では、MQL4とMQL5間における主要APIの差異を明示し、それぞれの機能をクラス内部でどのように統一するかの方針を整理する。対象は主に**発注・決済・ポジション取得・GUI操作**など、実装上の分岐が生じる箇所である。

---

### 4.1 発注系API（エントリー・建値移動）

| 機能             | MQL4 API         | MQL5 API              | 使用クラス        | 対応方針 |
|------------------|------------------|------------------------|-------------------|----------|
| 成行エントリー       | `OrderSend()`      | `CTrade.Buy()` / `.Sell()` | `CEntryExecutor`   | `#ifdef` による条件分岐 |
| 指値・逆指値エントリー | `OrderSend()` + type | `CTrade.BuyLimit()` 等     | `CEntryExecutor`   | 分岐＋ラッピング関数で吸収 |
| SLの建値移動      | `OrderModify()`     | `CTrade.PositionModify()` | `CBEExecutor`      | 条件付きI/Fで共通化 |

---

### 4.2 ポジション管理系API

| 機能             | MQL4 API                     | MQL5 API                        | 使用クラス         | 対応方針 |
|------------------|------------------------------|----------------------------------|--------------------|----------|
| ポジションの選択     | `OrderSelect()`               | `PositionSelect()`              | `CPositionModel`   | I/F吸収によるラップ構造 |
| エントリー価格取得   | `OrderOpenPrice()`            | `PositionGetDouble(POSITION_PRICE_OPEN)` | `CPositionModel`   | 条件分岐または抽象I/F |
| チケット番号取得    | `OrderTicket()`               | `HistoryDealGetTicket()` 等      | `CPositionModel`   | MQL5側は実装手法再検討中 |

---

### 4.3 UI描画系API

| 機能            | MQL4 API                        | MQL5 API                  | 使用クラス      | 対応方針 |
|-----------------|----------------------------------|---------------------------|------------------|----------|
| ボタン描画         | `ObjectCreate(OBJ_RECTANGLE_LABEL)` | `CDialog`, `CButton`      | `CEntryPanel`    | 完全分離設計（将来共通I/F化） |
| ラベル／ライン描画 | `ObjectCreate(OBJ_LABEL / OBJ_TREND)` | 同上                     | `ChartRenderer`  | 共通APIで統一済み       |

---

### 4.4 システム情報取得・補助関数

| 機能          | MQL4 API                  | MQL5 API                     | 使用クラス         | 対応方針 |
|---------------|----------------------------|-------------------------------|--------------------|----------|
| スプレッド取得     | `Ask - Bid` または `MarketInfo()` | `SymbolInfoDouble(SYMBOL_SPREAD)` | `CEntryValidator`  | 条件分岐なしで共通実装可 |
| 時間帯の取得     | `TimeHour(TimeCurrent())` | `TimeLocal()` / `TimeGMT()` | `CEntryValidator`  | ローカル時刻で統一可能     |

---

### 4.5 共通化戦略の要点

- **Trade層**：ほぼ全て `#ifdef __MQL5__` による条件付きラッパーで吸収可能
- **Logic層**：`CPositionModel` のみAPI差あり。他は条件分岐不要
- **View層**：描画APIは一部共通だが、UI操作は完全分離が必須（`CEntryPanel`）

> すべての条件分岐はクラス内に閉じ込め、**呼び出し側からは共通I/Fで使用可能**とすることが設計の原則である。

---

> 補足資料：  
> `EPT_spec_ModuleSharedMap_v1.0_Final.md` セクション3, 4  
> `EPT_transitionPack.md` コードマッピング表  
> `EPT_Class_v1.5.md` 関数I/F定義一覧

---

## 第5章. 実装ディレクトリ構成と再利用戦略

本章では、EdgeProTraderプロジェクトにおけるMQL実装ファイルの構成方針と、各モジュールの再利用戦略を明確にする。すべてのヘッダーファイルは役割に応じて `/Include/` 配下の適切なサブディレクトリに整理され、共通化／分離の基準を明示する。

---

### 5.1 ディレクトリ構成（最新版）

```plaintext
Include/
├── Common/
│   └── CommonDefs.mqh          # 共通定数・色・補助関数など
├── Logic/
│   ├── CPanelStateManager.mqh  # UI状態制御ロジック（共通）
│   ├── CEntryValidator.mqh     # 時間帯・スプレッド判定（共通）
│   ├── CPositionModel.mqh      # ポジション抽象取得（条件分岐あり）
│   ├── RiskHelper.mqh          # ロット計算補助関数
│   ├── RiskManager.mqh         # 許容ロット算出クラス
│   └── CPriceCalculator.mqh     # TP/SL価格計算補助クラス
├── Trade/
│   ├── COrderExecutorBase.mqh  # 共通パラメータ管理（抽象クラス）
│   ├── CEntryExecutor.mqh      # 成行注文（IMarketOrderExecutor 実装）
│   ├── CBEExecutor.mqh         # BE移動（ISLModifier 実装）
│   ├── CPendingEntryExecutor.mqh   # 予約注文（IPendingOrderPlacer 実装）
│   ├── CExitExecutor.mqh           # 条件付き撤退（IExitEvaluator 実装）
│   ├── CTrailSLExecutor.mqh        # トレーリングSL（ISLModifier 実装）
│   └── CExecutorInterfaces.mqh     # Executor戦略用インターフェース定義群
├── View/
│   ├── CEntryPanel.mqh         # UIパネル（MQL依存で別実装）
│   └── ChartRenderer.mqh       # ライン・ラベル描画（共通）
```

---

### 5.2 再利用戦略と設計原則

#### ✅ 共通化前提の分類ルール

| ディレクトリ | 概要 | 共通化可否 | 備考 |
|--------------|------|------------|------|
| `Common/`     | 定数／補助関数類 | ✅ 完全共通 | 全層から参照される |
| `Logic/`      | ロジック判定群   | ✅ MQL非依存 | MQL4/5共通前提で構築 |
| `Trade/`      | 発注系処理群     | ✅ 条件付き共通 | `#ifdef` による切替で吸収 |
| `View/`       | チャートUI       | ❌ UI依存分離 | 将来的に共通I/F化を検討 |

---

### 5.3 ライブラリ構造設計の方針

- **クラスベース構成**：各ファイルは原則として1クラス＝1ファイルとし、クラス責務の明確化と再利用性を両立
- **依存方向の明確化**：
  - `Common` → すべての層から参照可
  - `Logic` → `Trade`, `View` から参照される（上位層からの一方向）
  - `Trade` ↔ `Logic`：Tradeは計算補助や判定にLogicを使用
  - `View` → 他層参照のみ（View自身は受け口）

---

### 5.4 ビルド構成上の注意点

- 各 `mq4` ファイルの冒頭で必要ヘッダーのみを `#include` し、循環参照を避ける
- `CommonDefs.mqh` のインクルードは原則として全ファイル共通（色・ラベル名・定義一元管理のため）
- 条件分岐による MQL4/5 切替はクラス内部に閉じ、外部ファイル構成は極力共通を維持

---

> 補足資料：  
> `EPT_spec_ModuleSharedMap_v1.0_Final.md` セクション6  
> `EPT_Class_v1.5.md` のクラス分類  
> 現行 `Experts/`, `Include/` のソース構造（2025/05時点）


### 5.5 ファイル命名規則と構造設計補足

- 本設計仕様では「1クラス＝1ファイル」の構成を採用しており、各クラスのファイル名はそのクラス名と同一に揃える。
- クラス名が `CEntryExecutor` の場合は `CEntryExecutor.mqh` と命名し、プロジェクト全体の**構造一貫性と再利用性**を担保する。

> 本ルールは `EPT_guidelines_v2.0.md` のコーディング規約とも連動し、将来のMQL5移行やIDE支援にも適合する。

---

## 第6章. 今後の展開とMQL5移植方針

本章では、EdgeProTraderプロジェクトにおけるMQL5対応の展望と、それに伴う実装・設計上の拡張方針を記述する。

---

### 6.1 View層の抽象化とUI共通I/F化

現在、MQL4とMQL5のUI構造は完全に異なり、`CEntryPanel` などのViewクラスは分離実装が必要である。

#### 🛠 今後の対応方針：
- `CEntryPanelBase` を導入し、`CEntryPanel_MQL4`, `CEntryPanel_MQL5` を派生実装
- `CreateButtons()`, `OnClick()`, `UpdateUIState()` などのUI操作関数を共通I/Fとして規定
- これにより、呼び出し元ロジックはViewの実装差を意識せずに制御可能となる

---

### 6.2 Logic層のモジュール汎用化（他フェーズ活用）

既に共通化済みの `CPanelStateManager`, `CEntryValidator`, `CRiskManager` などは、
以下のフェーズでもそのまま流用可能である：

| 活用フェーズ | 使用候補クラス | 備考 |
|--------------|----------------|------|
| Exit          | `CPanelStateManager`, `CPositionModel` | 状態制御・建値判定など |
| Journal       | `CPositionModel` | 記録対象ポジション抽出に利用 |
| Planning      | `CEntryValidator`, `RiskManager` | 戦略許容リスク計算等 |

---

### 6.3 Trade層のI/F統一と抽象ベース導入

現在 `CEntryExecutor`, `CBEExecutor` は `#ifdef` 方式で条件分岐しているが、
今後は以下のように**抽象インターフェース設計を強化**する：

- `COrderExecutorBase` を明確な純粋仮想クラスとして再整理
- TradeExecutor系の新ロジック（例：トレーリングSL, 複数TP）にも派生で対応
- `BEExecutor`, `PendingExecutor`, `ExitExecutor` などの将来拡張も視野に設計

---

### 6.4 汎用性強化に向けた将来オプション

#### 🚀 計画中の追加機能群

| 分類 | 拡張項目 | 補足 |
|------|----------|------|
| TP/SL戦略 | 第一TP / 第二TP / トレーリング機能 | `CPriceCalculator`, `PanelStateManager` と連携 |
| BE戦略 | 足確定 or pips条件による自動BE実行 | `CBEExecutor` にトリガー条件を追加予定 |
| 決済戦略 | 条件付きClose（建値以上, 直近のみなど） | `CExitExecutor` の新規設計で対応 |

---

### 6.5 MQL5移行ステップ計画（中長期）

| ステージ | 対応内容 | 影響範囲 |
|----------|----------|----------|
| Step 1 | Logic/Trade層の共通I/F完成 | Viewを除くモジュール全体 |
| Step 2 | `CEntryPanelBase` 導入・2系統構築 | View完全分離 |
| Step 3 | MQL5専用UI設計（CDialog拡張） | ユーザー操作性の刷新 |
| Step 4 | Exit / Journal / Planning機能の統合 | モジュール増加による拡張性確認 |
| Step 5 | MQL5版フル統合ビルドの切り替え | `Experts_MQL5/` ディレクトリ分離 |

---

> 参考ドキュメント：  
> `EPT_project_v2.0.md`（フェーズ戦略）  
> `EPT_transitionPack.md`（構造・コード移行）  
> `EPT_spec_ModuleSharedMap_v1.0_Final.md`（分岐対応）

---

## 第7章. 補足・関連資料一覧

本章では、本ドキュメントの設計指針を補完する補足情報および参照すべき関連ドキュメント群をまとめる。

---

### 7.1 補足事項

- **ファイル命名規則**：
  - クラス名と同一に揃える（例：`CEntryExecutor.mqh`）
  - 接頭辞は `C` を原則とし、モジュール単位で分類する（例：`Logic/`, `Trade/`）

- **オブジェクトIDの構成**：
  - `"EPT_" + 機能種別 + 個別ID`（例：`EPT_BE_LINE_1`）で統一

- **デバッグ用出力規約**：
  - `DebugPrint()` 関数を共通ヘッダーに定義
  - 全クラスで `DebugMode` により切り替え可能な構成とする

- **OnDeinit() の基本方針**：
  - View系クラス（特に `CEntryPanel`, `ChartRenderer`）は生成オブジェクトの**明示的な削除処理**を実装すること

---

### 7.2 関連ドキュメント一覧

| ドキュメント名                                  | 役割・内容                                 |
|-------------------------------------------------|--------------------------------------------|
| `EPT_spec_v2.0.md`                              | UI設計・ボタン定義・状態遷移の仕様書                   |
| `EPT_Class_v1.5.md`                             | 全クラスの責務・関数構成・依存関係の詳細定義              |
| `EPT_spec_StructureDesign.md`                  | 三層アーキテクチャの構造設計定義                         |
| `EPT_spec_ModuleSharedMap_v1.0_Final.md`       | MQL4/5差分と共通化可能性のマッピング                    |
| `EPT_spec_template_v1.0.md`                    | 本仕様書に準拠した記述テンプレート                       |
| `EPT_project_v2.0.md`                          | プロジェクト全体構想、MQL5移行計画、AI支援ビジョン          |
| `EPT_transitionPack.md`                        | コード移行マップと設計引き継ぎテンプレート                 |
| `EPT_operationalGuide_v2.0.md`                 | スレッド運用・タスク・ChangeLog記録の運用ルール集             |
| `EPT_guidelines_v2.0.md`                       | Coding/PFMガイドラインの統合版                           |
| `EPT_prompt_v5.0.md`                           | GPT支援設計・出力ルール仕様書                             |
| `EPT_taskTable_v1.0_20250504.md`               | 全タスクの登録・進行・完了管理記録                        |
| `EPT_ChangeLog.md`                             | ドキュメント全体の構造更新履歴記録                         |

---

### 7.3 今後の補助資料リンク（予定）

- `EPT_transition_F2Entry_v1.0.md`：Entry機能への引き継ぎ事例記録（テンプレ展開用）
- `EPT_MQL5_UXPrototype.md`：MQL5でのUI試作・Dialog構成案
- `EPT_TestScaffold.md`：テスト用EA／ダミーデータ用の最小テンプレート集

> 補助資料は `EPT_transitionPack.md` や `EPT_guidelines_v2.0.md` にて管理され、必要に応じて追加リンクされる。

---

以上が `EPT_spec_MQL_Designs_v2.0.md` の全構成である。
