### 3.1 デバッグ出力規約（LOGマクロの統一構造）

本プロジェクトでは、すべてのログ出力は `LOG_<カテゴリ>_<レベル>()` 形式のマクロによって行う。  
旧 `DebugPrint()` は廃止対象とし、今後の開発では使用禁止とする。

#### ✅ マクロ構文

```mql4
LOG_LOGIC_DEBUG("スプレッド条件チェック開始");
LOG_ACTION_INFO("建値移動完了 Ticket=123456");
LOG_VIEW_ERROR("TPライン描画失敗 → objName: TP_1");
```

#### ✅ 使用ルール

- ログは「カテゴリ」と「レベル」の2軸で分類される
  - カテゴリ：`VIEW`, `LOGIC`, `ACTION`, `TEST`
  - レベル　：`DEBUG`, `INFO`, `ERROR`
- マクロ定義は `EPT_EnvConfig.mqh` にて提供される（12種）
- ログレベルの選択基準は `EPT_logRule_Draft_v1.3.md` 第4章を参照
- クラス／関数単位で一貫したカテゴリを使用し、粒度の明確な出力を行う

#### ✅ 移行方針

- 既存の `DebugPrint()` は段階的に `LOG_◯◯_◯◯()` に差し替える
- マクロは `DebugMode` フラグにより全体出力を制御可能

> 🔗 詳細な分類・判定基準・使用例は `EPT_logRule_Draft_v1.3.md` に準拠。
