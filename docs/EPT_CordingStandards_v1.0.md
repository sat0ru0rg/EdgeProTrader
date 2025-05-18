## 第1章. 命名規則（Naming Conventions）

命名規則は、コードの可読性と保守性を高めるため、すべての識別子に一貫性を持たせることを目的とします。

* **クラス名**：`C`プレフィックス + UpperCamelCase（例：`CEntryExecutor`）
* **関数名**：lowerCamelCase（例：`calculateLotSize`）
* **変数名**：lowerCamelCase（例：`riskPercent`）。関数スコープでは簡潔に。
* **定数名**：すべて大文字＋アンダースコア区切り（例：`MAX_POSITION_COUNT`）
* **マクロ名**：定数と同様に全大文字（例：`LOG_ACTION_DEBUG`）
* **ファイル名**：定義するクラスと一致させる（例：クラス`CEntryExecutor` → `CEntryExecutor.mqh`）

> 🔖 本規則は `EPT_operationalGuide_v2.0.md` 第3章と整合します。

---

## 第2章. コード構文とスタイル（Syntax & Style）

EdgeProTraderプロジェクトでは、読みやすさと誤解のない記述を最優先に以下のスタイルルールを採用します。

* **インデント**：半角スペース4つ（Tabは禁止）
* **波括弧 `{}` の配置**：常に改行して明示（K\&Rスタイルは禁止）

```mql4
void SomeFunction()
{
    if (condition)
    {
        DoSomething();
    }
}
```

* **1関数1責務**：関数は明確な単一目的に限定し、長文化した場合は分割を検討
* **改行と空行**：処理ブロックごとに空行を入れ、論理構造を明示
* **コメント形式**：

  * 関数冒頭に簡潔な目的と引数の説明
  * 処理中は `//` を使用。複数行は段落風に記述

> 🔖 詳細なコメント構文は第4章を参照。

---

## 第3章. ファイル構成と役割（File Structure）

本プロジェクトでは、View/Logic/Trade/共通部の責務ごとにディレクトリを分離し、構造的な保守性を担保します。

* **ディレクトリ構造**（`/Include/` 配下）

  * `/View/`：チャート描画やUI制御（例：`CEntryPanel.mqh`）
  * `/Logic/`：状態判定や検証処理（例：`CPanelStateManager.mqh`）
  * `/Trade/`：エントリー／建値移動／決済などの注文処理
  * `/Common/`：共通定義／定数／色など（例：`CommonDefs.mqh`）

* **ファイル単位の原則**：

  * 原則：1ファイル = 1クラス（補助関数は例外）
  * クラス名とファイル名は一致（例：`CEntryExecutor` → `CEntryExecutor.mqh`）

> ✅ `EPT_spec_MQL_Designs_v2.0.md` に準拠した責務分離を維持

---

## 第4章. コメントとドキュメンテーション（Documentation）

読み手の理解を助け、将来的な修正時のトレース容易化のため、以下のコメント形式を標準とします。

* **ファイル冒頭**：

  * 概要：このファイルの責務（1行）
  * 呼び出し元：このファイルを参照する主なクラス／モジュール
  * 補足：他ファイルとの依存や将来の拡張に関する注記

* **クラス定義直上**：

```mql4
//+------------------------------------------------------------------+
//| CEntryExecutor                                                    |
//| 発注処理（成行・指値）の実行クラス。CPanelStateManagerから呼び出される。    |
//+------------------------------------------------------------------+
```

* **関数定義前**：簡潔なJavadoc風

```mql4
/// @brief リスクに応じたロット数を計算
/// @param riskPercent 許容リスク（％）
/// @param slPips 損切り距離（pips）
/// @return ロットサイズ
```

* **補足コメント**：重要な設計判断／制限事項／仮実装箇所などは `///` で記述し、通常コメントと明確に区別

---

## 第5章. 条件分岐とプラットフォーム制御（Conditional Design）

MQL4/MQL5両対応の拡張性を確保するため、条件付きプリプロセッサの使用ルールを以下の通り統一します。

* **原則**：`#ifdef __MQL5__` は**クラス・関数内部に閉じ込める**

```mql4
#ifdef __MQL5__
   // MQL5専用処理
#else
   // MQL4互換処理
#endif
```

* **呼び出し元では差異を意識させない**：View/Logic/Trade層の外部インターフェースは共通化する
* **条件分岐が多岐に渡る場合**：`MQLWrapper.mqh` 等のラッパー関数で吸収して複雑性を局所化する

> 🔖 詳細な設計方針は `EPT_spec_MQL_Designs_v2.0.md` 第3章を参照

---

## 第6章. ログ出力ルール（Logging Standards）

### 6.1 目的と適用範囲

本章では、EdgeProTraderプロジェクトにおけるログ出力ルールを定義し、すべてのログをカテゴリ（責務）×レベル（重要度）で明確に分類・標準化します。

#### 対象範囲：

* MQL4における `.mq4` / `.mqh` 全コード
* DebugPrint の全面廃止、12種マクロ（`LOG_◯◯_◯◯()`）への一本化
* View / Logic / Action / Test 層の各クラス・共通関数・テストコード

---

### 6.2 ログカテゴリ分類（責務ベース）

| カテゴリ   | 用途                  | 主な対象クラス例                                |
| ------ | ------------------- | --------------------------------------- |
| VIEW   | UI描画／チャートオブジェクト制御   | `CEntryPanel`, `ChartRenderer`          |
| LOGIC  | 判定・状態管理・条件分岐ロジック    | `CPanelStateManager`, `CEntryValidator` |
| ACTION | 実行系（発注／建値移動／Close等） | `CEntryExecutor`, `CBEExecutor`         |
| TEST   | 単体テスト／シナリオテスト出力     | `EntryExecutorTest.mq4` など              |

---

### 6.3 ログ出力マクロ定義（12分類）

```mql4
#define LOG_VIEW_DEBUG(msg)     if(DebugMode) Print("[VIEW][DEBUG] ", msg)
#define LOG_VIEW_INFO(msg)      if(DebugMode) Print("[VIEW][INFO] ", msg)
#define LOG_VIEW_ERROR(msg)     if(DebugMode) Print("[VIEW][ERROR] ", msg)

#define LOG_LOGIC_DEBUG(msg)    if(DebugMode) Print("[LOGIC][DEBUG] ", msg)
#define LOG_LOGIC_INFO(msg)     if(DebugMode) Print("[LOGIC][INFO] ", msg)
#define LOG_LOGIC_ERROR(msg)    if(DebugMode) Print("[LOGIC][ERROR] ", msg)

#define LOG_ACTION_DEBUG(msg)   if(DebugMode) Print("[ACTION][DEBUG] ", msg)
#define LOG_ACTION_INFO(msg)    if(DebugMode) Print("[ACTION][INFO] ", msg)
#define LOG_ACTION_ERROR(msg)   if(DebugMode) Print("[ACTION][ERROR] ", msg)

#define LOG_TEST_DEBUG(msg)     if(DebugMode) Print("[TEST][DEBUG] ", msg)
#define LOG_TEST_INFO(msg)      if(DebugMode) Print("[TEST][INFO] ", msg)
#define LOG_TEST_ERROR(msg)     if(DebugMode) Print("[TEST][ERROR] ", msg)
```

---

### 6.4 ログレベル選定基準（INFO / DEBUG / ERROR）

| レベル   | 出力目的           | 適用例                      |
| ----- | -------------- | ------------------------ |
| DEBUG | 処理途中の詳細（中間値など） | 計算ステップ、フラグ判定、ループ進捗       |
| INFO  | 正常系の結果・操作ログ    | 発注完了、描画完了、状態遷移、条件成立      |
| ERROR | 異常系・例外発生時      | 発注失敗、描画エラー、Null参照、APIエラー |

---

### 6.5 ヘルパー関数での出力指針

```mql4
double CalcLotByRisk(double riskMoney, double slPips, string tag = "")
{
    double lot = (riskMoney / slPips) * 0.1;

    // 明示ログ出力（必要時のみ有効化）
    // if (tag != "")
    //     LOG_LOGIC_DEBUG("[" + tag + "] Lot計算: risk=" + riskMoney + ", SL=" + slPips + ", lot=" + lot);

    return lot;
}
```

---

### 6.6 置換例とベストプラクティス

| Before（旧DebugPrint）                 | After（置換後マクロ）                        |
| ----------------------------------- | ------------------------------------ |
| `DebugPrint("[ACTION] Entry sent")` | `LOG_ACTION_INFO("Entry sent")`      |
| `DebugPrint("[LOGIC] Spread OK")`   | `LOG_LOGIC_DEBUG("Spread OK")`       |
| `DebugPrint("[VIEW] TP描画完了")`       | `LOG_VIEW_INFO("TP描画完了")`            |
| `DebugPrint("[TEST] passed")`       | `LOG_TEST_INFO("basic test passed")` |

> ❌ `DebugPrint()`は禁止。必ず `LOG_◯◯_◯◯()` に統一すること。

---

### 6.7 拡張と今後のガイドライン

* 現行は4カテゴリ × 3レベル（計12種）を標準構成とする
* 今後の拡張候補：`LOG_COMMON_DEBUG()`、`LOG_DRAW_INFO()` など
* ログの一貫構造は将来的なビューア／CSV出力／AI解析との接続を見据えて設計すること

---
