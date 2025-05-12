# EPT_logRule_Draft_v1.2.md

---

## 第1章. 目的と適用範囲

このドキュメントは、EdgeProTraderプロジェクトにおけるデバッグログ出力の規則を暫定的に定義するものである。

### 目的

- ログ出力の責任と分類を統一し、混在・誤用を防止する
- 本体／テスト／描画出力を明確に区別できるログタグを整備する
- 将来的なAI解析やログビューア開発に備え、ログ構造を整える

### 適用範囲

- `DebugPrint()` を使用するすべてのMQL4コード（`.mqh`, `.mq4`）
- View / Logic / Action / Test 各層のモジュール
- 共通関数／補助ヘルパーを含む

---

## 第2章. ログタグ分類と出力例

### タグ一覧（現時点で使用する基本4種）

| タグ       | 用途                         | 主な対象クラス例               |
|------------|------------------------------|------------------------------|
| `[VIEW]`   | UI操作／描画処理              | `CEntryPanel`, `ChartRenderer` |
| `[ACTION]` | 発注／建値移動／Closeなどの実行処理 | `CEntryExecutor`, `CBEExecutor` |
| `[LOGIC]`  | 状態判定／バリデーション処理       | `CPanelStateManager`, `CEntryValidator` |
| `[TEST]`   | テストコードでの出力            | `EntryExecutorTest.mq4` など     |

> 💡 `[DEBUG]` は全タグに共通するため、**すべての出力に含める必要はない**。タグが付いていれば＝デバッグログとみなす。

---

## 第3章. 出力関数の使い分けと責任範囲

| 層／役割          | 使用関数       | 出力内容                           | 備考                                   |
|------------------|----------------|------------------------------------|----------------------------------------|
| 本体（Trade/Logic/View） | `DebugPrint()` | 条件分岐・処理開始／終了・結果出力など | タグ付きで明示                         |
| テストコード        | `DebugPrint()` | テスト用ログ（成功・失敗・呼び出し確認） | `[TEST]` タグで統一                   |
| UI通知／ユーザー出力 | `Print()`       | ユーザー向けの常時通知メッセージ         | `DebugPrint()`は使わない                 |
| 共通関数／ヘルパー  | （呼び出し側に委ねる） | 原則出力しない（必要時のみtag引数で制御） | 詳細は第4章参照                        |

---

## 第4章. 共通関数・ヘルパーでのログ出力方針

### ✅ 推奨方針：デフォルトは出力なし、必要時のみ明示的にON

- `tag = ""` を引数に追加することで、呼び出し側が責務タグを制御
- 関数内の `DebugPrint()` 呼び出しは、**原則コメントアウト**しておき、必要時に有効化

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

## 第5章. 良いログ／悪いログの例

### ✅ 良いログ（責務と意味が明確）

```mql4
DebugPrint("[ACTION] [BEGIN] MoveSLToBEForTicket()");
DebugPrint("[ACTION] [CHECK] currentSL = 145.850, entry = 145.800");
DebugPrint("[ACTION] [RESULT] SL moved to breakeven");
DebugPrint("[ACTION] [END] MoveSLToBEForTicket()");
```

### ❌ 悪いログ（責務不明・粒度不明）

```mql4
DebugPrint("処理開始");
DebugPrint("OK");
DebugPrint("何かがおかしい");
```

---

## 第6章. 補足：タグ管理と拡張のガイドライン

- タグは将来的に以下のような分類を追加する余地がある（例：`[DRAW]`, `[EXIT]`, `[COMMON]` など）
- ただし、**現在は4タグ（VIEW / ACTION / LOGIC / TEST）に統一し、運用負荷を軽減**
- ログの目的に応じてサブ要素（`[UI]`, `[DRAW]`）をメッセージ内で表現するのは任意

---

## 付録. タグ運用まとめ（呼び出し元での指定例）

```mql4
// Trade処理でのログ出力
DebugPrint("[ACTION] Entry order sent successfully.");

// Logic処理での条件チェック
DebugPrint("[LOGIC] Spread = 1.2 → OK");

// 描画系処理（VIEW層）
DebugPrint("[VIEW] TPライン描画完了 @ 145.600");

// テスト用ログ
DebugPrint("[TEST] CEntryExecutor entry success");
```
