# EPT\_CPanelStateManager\_Spec\_v1.0.md

## 第1章. クラスの目的と責務

本クラスは、EdgeProTraderにおける `CEntryPanel` のUI状態の中心的制御ロジックを担う。EntryModeの管理、ボタンの有効／無効判定、BEライン／SL／TPの表示スタイル管理を一元化し、操作ミスの抑止と柔軟なUI拡張を可能にする。

---

## 第2章. 内部状態構成

| 変数名                  | 型         | 内容                    |
| -------------------- | --------- | --------------------- |
| `m_entryMode`        | int       | 現在のEntryMode（0〜3）     |
| `m_openPositions[3]` | struct\[] | 各ポジションの保有状態と価格情報      |
| `m_isBEAllVisible`   | bool      | BE\_LINE\_ALLが表示中かどうか |

---

## 第3章. EntryMode制御ロジック

### 3.1 EntryMode定義

```mql4
enum EntryMode {
   MODE_ENTRY_1 = 0,
   MODE_ENTRY_2,
   MODE_ENTRY_3,
   MODE_ALL
};
```

### 3.2 切替操作

* EntryPanel上の `[①][②][③][ALL]` ボタンで明示的に切替
* SetEntryMode() 呼出により `m_entryMode` を更新し、ライン・UI状態を再評価する

---

## 第4章. 操作可否判定関数（CanXxx系）

| 関数名               | 戻り値  | 使用者         | 使用タイミング     | 説明                          |
| ----------------- | ---- | ----------- | ----------- | --------------------------- |
| `CanEnter()`      | bool | CEntryPanel | BUY/SELL押下前 | SL表示中かつ未保有スロットであればtrue      |
| `CanShowSL()`     | bool | CEntryPanel | SLボタン押下前    | ENTRY\_1〜3は常時true、ALLはfalse |
| `CanShowTP()`     | bool | CEntryPanel | TPボタン押下前    | SL表示中であればtrue               |
| `CanShowBE()`     | bool | CEntryPanel | BEボタンの活性判定  | ENTRY\_nなら保有中、ALLなら保有数2以上   |
| `CanClose()`      | bool | CEntryPanel | CLOSEボタン前   | ENTRY\_n：保有中、ALL：2ポジ以上保有時   |
| `IsModeActive(i)` | bool | 描画制御など      | ライン描画時      | 現在のEntryModeと一致していればtrue    |

---

## 第5章. ライン描画とスタイル制御

### 5.1 表示ルール

* 選択中ポジション：通常色、太さ2、操作可
* その他ポジ：薄色、太さ1、非操作
* ALLモード中かつBE表示ON時：BE\_LINE\_ALLだけ強調、他は非操作で薄色

### 5.2 関数一覧（役割と使用タイミング）

| 関数名                                | 概要                                                   | 使用タイミング                    | 補足                                        |
| ---------------------------------- | ---------------------------------------------------- | -------------------------- | ----------------------------------------- |
| `UpdateLineStyles()`               | EntryModeとBE\_LINE状態に応じて全ライン（ENTRY/SL/TP/BE）のスタイルを更新 | EntryMode切替時、BE\_LINE表示切替時 | ENTRY\_LINE\_1〜3、SL/TP、BE\_LINE\_ALLを一括更新 |
| `ApplyLineStyle(name, w, c, flag)` | 特定ラインに太さ・色・選択可否を適用                                   | `UpdateLineStyles()`から個別呼出 | 例：ENTRY\_LINE\_1を白・太さ2・選択可で表示             |

---

## 第6章. 外部公開関数一覧（CEntryPanel向け）

| 関数名                      | 概要                  | 使用タイミング   | 使用例／補足                                          |
| ------------------------ | ------------------- | --------- | ----------------------------------------------- |
| `GetCurrentEntryMode()`  | 現在のEntryModeを返す     | CLOSE操作など | `ClosePosition(GetCurrentEntryMode())` などで利用される |
| `SetEntryMode(int mode)` | EntryModeを切替し、状態更新  | ボタン押下時    | EntryMode変更後に`UpdateLineStyles()`を内部で呼ぶ         |
| `SuggestEntryMode()`     | 未保有スロットの最小番号を返す     | 再エントリー時   | `pos[1]`だけ保有中 → 0 or 2 を提案                      |
| `UpdateButtonStates()`   | 全ボタンの有効／無効を一括判定・反映  | 状態変化後     | `CanXxx()` 系を組み合わせてボタンの活性制御に使われる                |
| `UpdateLineStyles()`     | ラインの太さ・色・選択可能性を一括更新 | モード切替時    | 表示中のラインを視覚的に差別化する際に使用される                        |

---

## 第7章. 拡張設計候補（将来対応）

* BE\_LINE\_ALLのドラッグによる全ポジSL一括移動
* EntryMode=ALLでの一括SL調整機能
* ライン描画ON/OFFの設定切替（カスタマイズUI）
* EntryMode切替の自動提案ロジック

---

## 第8章. まとめ（要点整理）

* `EntryMode`ごとに対象ポジションのUIとラインを動的制御
* BE\_LINE\_ALLは **ALLモードかつ表示ON時のみ**強調表示
* ラインは\*\*視認性（太さ／色）と操作可否（selectable）\*\*で分離管理
* `CanXxx()`系でボタン制御、`UpdateLineStyles()`系で描画状態更新
* 将来の自動トレーリングBEや一括操作にも拡張しやすい構造

---

以上
