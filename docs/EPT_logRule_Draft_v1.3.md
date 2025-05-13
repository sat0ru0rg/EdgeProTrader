# EPT\_logRule\_Draft\_v1.3.md

---

## 第1章. 目的と適用範囲

このドキュメントは、EdgeProTraderプロジェクトにおけるログ出力ルールを正式に定義するものである。

### 目的

* ログ出力の**カテゴリ（責務）とレベル（重要度）を12種に分類**し、属人的判断を排除する
* `LOG_◯◯_◯◯()` マクロにより、ログ構造を一貫化・標準化する
* 将来的なAI解析・ログビューア開発に対応可能な設計とする

### 適用範囲

* `LOG_◯◯_◯◯()` マクロを使用するすべてのMQL4コード（`.mqh`, `.mq4`）
* View / Logic / Action / Test 各層のモジュール（旧呼称 `DebugPrint()` を全面置換）
* 共通関数／補助ヘルパー、ユニットテスト含む

> 💡 旧 `DebugPrint()` は非推奨。今後は12種のマクロ定義に一本化すること。

---

## 第2章. ログカテゴリ分類（責務ベース）

### カテゴリ一覧（4分類）

| カテゴリ名    | 用途              | 主な対象クラス例                                |
| -------- | --------------- | --------------------------------------- |
| `VIEW`   | UI操作／描画処理       | `CEntryPanel`, `ChartRenderer`          |
| `ACTION` | 発注／建値移動／Close処理 | `CEntryExecutor`, `CBEExecutor`         |
| `LOGIC`  | 状態判定／検証／条件分岐    | `CPanelStateManager`, `CEntryValidator` |
| `TEST`   | テストコード全般        | `EntryExecutorTest.mq4` など              |

> 補足：外部連携（Notion / Pythonなど）は将来的に `ACTION` カテゴリに含める方針。

---

## 第3章. ログ出力マクロ定義（12種）

`LOG_<カテゴリ>_<レベル>(msg)` 形式のマクロを、`EPT_EnvConfig.mqh` にて以下のように定義する。

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


## 第4章. ログレベルの選択基準（INFO / DEBUG / ERROR の判定）

ログ出力におけるメッセージのレベル（INFO / DEBUG / ERROR）を明確に選別するため、以下のルールに従うこと。
レベルの選択は一貫性のある出力と、将来的なログビュー／分析の効率に直結する。

---

### 🎯 ログレベル別の判定基準

| レベル     | 使用条件                             | 出力の目的          | 代表例                             |
| ------- | -------------------------------- | -------------- | ------------------------------- |
| `DEBUG` | 処理の途中経過・詳細情報（内部変数、関数の入出など）       | 開発者用の調査・追跡     | 計算中の中間値、条件分岐の通過確認、ループ処理の進捗など    |
| `INFO`  | 処理が正常に完了し、ユーザー／開発者に知らせるべき状態変化や結果 | 状態ログ、操作確認用     | 発注完了、パネル更新、BE移動、TPライン描画完了など     |
| `ERROR` | 例外的または処理継続不可のエラー状態が発生したとき        | バグ検知・例外処理のトリガー | 発注失敗、描画エラー、Null参照、インジケーター取得失敗など |

---

### 🔁 レベル判定の簡易フローチャート

```text
1. 処理は成功しているか？
   └─ No → ERROR
   └─ Yes →
       2. 出力は「主動作の完了」「重要な状態変化」「ユーザー通知」か？
           └─ Yes → INFO
           └─ No（詳細／中間出力など） → DEBUG
```

> 💡 判定に迷ったら INFO を基準とし、開発中のみ見たい内容は DEBUG に、例外的挙動は必ず ERROR に分類すること。

---

## 第5章. 共通関数・ヘルパーでのログ出力方針

### ✅ 推奨方針：デフォルトは出力なし、必要時のみ明示的にON

* `tag = ""` を引数に追加することで、呼び出し側が責務タグを制御
* 関数内の `DebugPrint()` 呼び出しは、**原則コメントアウト**しておき、必要時に有効化

#### 例：`RiskHelper.mqh`

```mql4
double CalcLotByRisk(double riskMoney, double slPips, string tag = "")
{
    double lot = (riskMoney / slPips) * 0.1;

    // デバッグ時のみ明示的に有効化
    // if (tag != "")
    //     DebugPrint("[" + tag + "][UTIL] CalcLotByRisk: risk=" + DoubleToString(riskMoney, 2) + ", SL=" + DoubleToString(slPips, 1) + ", lot=" + DoubleToString(lot, 2));

    return lot;
}
```

---

## 第6章. 良いログ／悪いログの例（12分類対応）

本章では、2025年5月に導入されたログカテゴリ×レベル分類（全12種）に基づき、
旧来の `DebugPrint()` から `LOG_◯◯_◯◯()` マクロへの置き換え例を提示する。

---

### 🔁 置換パターン例①：Trade層 → `ACTION`

#### 📍Before

```mql4
DebugPrint("[ACTION] Entry order sent successfully.");
```

#### ✅After

```mql4
LOG_ACTION_INFO("Entry order sent successfully.");
```

---

### 🔁 置換パターン例②：Logic層 → `LOGIC`

#### 📍Before

```mql4
DebugPrint("[LOGIC] Spread = 1.2 → OK");
```

#### ✅After

```mql4
LOG_LOGIC_DEBUG("Spread = 1.2 → OK");
```

---

### 🔁 置換パターン例③：描画系 → `VIEW`

#### 📍Before

```mql4
DebugPrint("[VIEW] TPライン描画完了 @ 145.600");
```

#### ✅After

```mql4
LOG_VIEW_INFO("TPライン描画完了 @ 145.600");
```

---

### 🔁 置換パターン例④：テストコード → `TEST`

#### 📍Before

```mql4
DebugPrint("[TEST] EntryExecutor basic test passed.");
```

#### ✅After

```mql4
LOG_TEST_INFO("EntryExecutor basic test passed.");
```

---

## 📌 差し替えルールの補足

| 元のログに含まれる文字列 | マクロ置換対象         | レベル推奨        | 備考                    |
| ------------ | --------------- | ------------ | --------------------- |
| `[ACTION]`   | `LOG_ACTION_◯◯` | INFO / DEBUG | 発注成功→INFO、準備段階→DEBUG  |
| `[LOGIC]`    | `LOG_LOGIC_◯◯`  | DEBUG        | 条件判定・バリデーションなど        |
| `[VIEW]`     | `LOG_VIEW_◯◯`   | INFO / ERROR | 描画完了→INFO、失敗→ERROR    |
| `[TEST]`     | `LOG_TEST_◯◯`   | INFO / DEBUG | テスト成功→INFO、途中出力→DEBUG |

> 💡 クラス名や関数名を付け加えたい場合は、マクロの引数に含めて自由に追記して構わない。

---

## 第7章. 補足：タグ管理と拡張のガイドライン

* タグは将来的に以下のような分類を追加する余地がある（例：`[DRAW]`, `[EXIT]`, `[COMMON]` など）
* ただし、**現在は4タグ（VIEW / ACTION / LOGIC / TEST）に統一し、運用負荷を軽減**
* ログの目的に応じてサブ要素（`[UI]`, `[DRAW]`）をメッセージ内で表現するのは任意

---

## 付録. タグ運用まとめ（呼び出し元での指定例）

```mql4
// Trade処理でのログ出力
LOG_ACTION_INFO("Entry sent: Ticket=123456");

// Logic判定処理でのログ出力
LOG_LOGIC_DEBUG("Spread check passed: 1.2pips");

// View描画処理でのログ出力
LOG_VIEW_INFO("TP line drawn at 145.600");

// テストコード
LOG_TEST_INFO("EntryExecutor basic test passed.");
```
