## BE/SL/TP構成拡張：構想引継ぎドキュメント（v1.0）

### 目的
- 現在完成した `CBEPriceCalculator` クラスを起点に、BE/SL/TPの計算・描画・制御をモジュール単位に分離し、拡張性・保守性の高い構造へ統合する
- 将来的なマルチポジション対応・統括UI対応・トリガー実行機能へ拡張可能な土台とする

---

### 対象構成（計9クラス + 統括マネージャー）

| カテゴリ     | Calculator               | Visualizer                  | Manager                     |
|--------------|---------------------------|------------------------------|------------------------------|
| SL関連       | `CSLPriceCalculator`      | `CSLLineVisualizer`         | `CSLManager`                |
| TP関連       | `CTPPriceCalculator`      | `CTPLineVisualizer`         | `CTPManager`                |
| BE関連       | `CBEPriceCalculator` ※済  | `CBEReferenceLineVisualizer`| `CBETriggerManager`         |

- 各カテゴリは単一責務で構成（価格計算／ライン描画／UI連携）
- Managerが各処理の統括（表示切替・モード切替・実行処理）を担う
- 実際の SL/TP/BE の反映処理（OrderModify）は関数ベースで十分なため、専用クラスは不要

---

### 統括マネージャーの必要性と役割

将来的に以下のような UI 状態管理が必要になる：
- 「SL操作中はTP/BEラインを非表示」
- 「BE到達後SL自動更新」
- 「すべてのラインを一括非表示」 など

そのために以下の統括クラスを導入：

#### `CLineControlOrchestrator`
- 役割：SL/TP/BEそれぞれのManagerを統括し、UI操作に応じた制御を一元管理
- 使用例：UIパネルの「ライン表示切替」や「対象ポジション切替」など

---

### 構成図（責務マップ）

```plaintext
[UI操作] 
   ┗━━━ CSLEntryPanel 
        ┗━━━ CSLManager 
              ├━━━ CSLPriceCalculator
              ├━━━ CSLLineVisualizer
              └━━━ OrderModify()

同様に：
    CTPManager → CTPPriceCalculator, CTPLineVisualizer, OrderModify()
    CBETriggerManager → CBEPriceCalculator, CBEReferenceLineVisualizer, OrderModify()

【上位統括】
    CLineControlOrchestrator → SL/TP/BEの各Managerを連携・一元制御
```

---

### 今後の起票候補（タスクベース）

1. `CSLPriceCalculator` クラス仕様書作成（Lot, EntryPrice, SL基準）
2. `CSLLineVisualizer` の描画仕様（D&D移動、色分岐、複数ポジ対応）
3. `CSLManager` による制御構成（表示切替・OnClickハンドリング）
4. 同様に TP / BE の各カテゴリを順次設計化
5. 最後に `CLineControlOrchestrator` 等の統括制御クラスに統合

---

### 備考
- 本設計は `EPT_spec_MQL_Designs_v2.0.md` に準拠し、責務分離・再利用性・UI接続性の観点で整理
- 各クラスは `Include/Logic/` / `Include/View/` に配置予定（計算＝Logic、描画＝View）
- Managerはパネル状態と統合するため、`StateManager` との接続インターフェース設計が必要
