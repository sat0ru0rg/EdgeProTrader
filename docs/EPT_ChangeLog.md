# EPT_ChangeLog.md
# Version: v1.6（2025/04/30）

# EdgeProTrader ChangeLog

本ドキュメントは、EdgeProTraderプロジェクトにおける**すべてのドキュメント変更履歴を横断的に記録する公式ログファイル**です。  
更新時の一貫性・トレーサビリティを維持するため、以下の構造および運用ルールに基づいて管理されます。

---

## 運用ルール（固定セクション）

- 本ファイルは、基本的に **ファイル名・バージョンを固定** したまま追記により更新を続けます。
- 履歴の記録は常に `

## ChangeLog履歴

` セクション以下に追加されます。
- **上部のこのルールセクションには、GPTは原則として変更・追記を行いません。**
- ファイル構成やログ記述形式に変更がある場合のみ、新しいバージョンファイルを作成します。

---

## 運用ルールまとめ

- 仕様書・設計書に変更が発生したら必ずここに追記する
- 変更の"理由・背景"は簡潔でも良いので必ず記載する
- 影響範囲には、変更によって影響するモジュール、クラス、ロジック領域を記載する
- 大規模バージョンアップ（v2.0など）の場合、事前に全体設計ドキュメントも見直す

---

## 備考：ファイルバージョン運用について

- このログファイルは、原則としてファイル名・バージョンを維持したまま追記によって更新されます。
- 内容構成（列や運用方針）に変更があった場合を除き、`EPT_ChangeLog.md` というファイル名のまま最新版として管理されます。


これより、EdgeProTraderプロジェクトのChangeLog正式運用を開始する。
---

## ChangeLog履歴

| No | 日付 | ドキュメント種別 | バージョン | 変更内容 | 理由・背景 | 影響範囲 |
| 01 :---|:---|:---|:---|:---|:---|
| 02  2025/04/20 | モジュール設計書 | v1.4 | 取引パネルUIと基本機能群の仕様を確定・完成 | EdgeProTrader取引ツールの最初の正式版として、基本操作機能を確立するため | 取引パネルUI、ボタン機能設計、基本エントリーロジック |
| 03  2025/04/28 | モジュール設計書 | v1.5 | BE機能を正式仕様に追加、状態管理ルール明確化 | トレード実戦で建値移動ニーズが高まり、状態制御を厳密に定義する必要があったため | ボタン一覧、状態管理、エントリーロジック |
| 04  2025/04/29 | タスクガイドライン | v1.4_fixed | 工程別タスク洗い出しスレッド制度を追加、特別スレッド運用を明記 | タスクドリブン開発における工程単位の柔軟な管理体制が必要と判断 | EPT_taskGuide_v1.4_fixed、スレッド運用ルール |
| 05  2025/04/29 | 自分用運用マニュアル | v1.6_fixed | 工程別タスク洗い出しスレッドを特別スレッドとして明記 | スレッド運用実務での判断基準・記述基準を明確にするため | EPT_manual_v1.6_fixed、運用ルールセクション |
| 06  2025/04/30 | プロンプト | v4_fixed2 | ファイル参照時のベース名指定ルール（最新版自動参照）をGPT行動ルールに追加 | スレッド立ち上げの簡略化と運用効率向上を目的とした仕様強化 | EPT_prompt_v4_fixed2、全スレッド作成手順 |
| 07  2025/04/30 | タスクガイドライン | v1.4_fixed2 | 第11章「ファイル参照指定ルール（簡略対応）」を新設し、記述例も追加 | スレッド立ち上げ時の記述ミスや手間を省くため | EPT_taskGuide_v1.4_fixed2、スレッド運用セクション |
| 08  2025/04/30 | 自分用運用マニュアル | v1.6_fixed2 | スレッド記述方法としてベース名指定OKを明記 | 実務におけるファイル参照ルールを統一・簡略化するため | EPT_manual_v1.6_fixed2、スレッド運用ルール
| 09  2025/04/30 | プロンプト | v4_fixed4 | タスク表記形式と表示ルールを明文化（マーク＋1文字／完了タスク非表示対応） | タスク管理運用の明瞭化と視認性・効率向上のため | EPT_prompt_v4_fixed4、タスク記録・表示運用全体 |
| 10  2025/04/30 | タスクガイドライン | v1.4_fixed3 | 第12章にタスク表記・表示ルールを追加、GPT記録統一を明記 | 表記形式の統一と、未完了タスクの標準表示運用の徹底のため | EPT_taskGuide_v1.4_fixed3、タスク記録と表示運用ルール |
| 11  2025/04/30 | ChangeLog | v1.4 | ファイル構造を整理。上部に運用ルールセクション、履歴表は `## ChangeLog履歴` 以下に固定化 | GPTが履歴のみを安全に追記できる構造に整理し、ログの長期運用性を向上するため | EPT_ChangeLog_v1.4、GPT追記動作、ログ構造一貫性 |
| 12  2025/04/30 | プロンプト | v4_fixed5 | GPT行動ルールにspecLog構造運用ルールを追記（履歴表以外は非編集） | 誤った領域への追記を防ぎ、specLogの構造と行動ルールを明確に統一するため | EPT_prompt_v4_fixed5、specLog編集時のGPT挙動全般 |
| 13 | 2025/04/30 | ChangeLog | v1.5 | 履歴表に No列（通し番号）を追加し、過去ログを一括で番号付け | 仕様変更履歴の視認性と差分把握を明確化するため | EPT_ChangeLog_v1.5、履歴管理とレビュー運用全般 |
| 14 | 2025/04/30 | プロンプト | v4_fixed6 | GPTがspecLogに履歴を追加する際、No報告を必須とする行動ルールを追加 | ユーザーがどの履歴が追加されたかを明確に把握できるようにするため | EPT_prompt_v4_fixed6、GPT出力ルール、履歴トラッキング |
| 15 | 2025/04/30 | プロンプト | v4_fixed9 | GPTによるドキュメント更新時、行番号（L◯〜L◯）を併せて報告するルールを追加 | 更新箇所の特定を容易にし、確認作業を迅速化するため | EPT_prompt_v4_fixed9、ドキュメント更新報告全般
| 16 | 2025/04/30 | ChangeLog | v1.6 | ログファイルの正式名称を `EPT_specLog.md` から `EPT_ChangeLog.md` に変更。すべての参照表記と行動ルールも統一 | ファイル名と実体（仕様横断の履歴管理）の整合性を図るため | EPT_ChangeLog.md、全参照ドキュメント、GPTプロンプト（v4_fixed10）
| 17 | 2025/04/30 | プロジェクト企画書 | v2.0 | MQL5移行前提構想・段階移行・準自動化構想などを反映したv2.0企画書を新規作成 | MQL4からMQL5への開発軸変更と将来的な裁量半自動売買構想の明文化のため | EPT_project_v2.0, 全体戦略, 長期ビジョン, 技術スタック |
| 18 | 2025/04/30 | 運用ルール・テンプレート | v1.0 | 引き継ぎレポートテンプレートの新設と標準運用ルールへの追加（EPT_manual, EPT_taskGuide, EPT_PFMGuideline） | フェーズ移行・設計未完時の引き継ぎを円滑にし、開発の継続性と構造的運用を確保するため | EPT_transition_Template, EPT_manual, EPT_taskGuide, EPT_PFMGuideline |
| 18 | 2025/04/30 | プロンプト | v4_fixed12 | スレッド名が未宣言の場合、GPTがユーザーにスレッド名を明示的に尋ねるリマインドルールを追加 | タスク出典・整理との整合性を保つため | EPT_prompt_v4_fixed12、スレッド起票全般 |
| 19 | 2025/04/30 | プロンプト | v4_fixed11 | タスク登録時には出典スレッド名を備考欄に必ず明記するルールを追加 | タスクトレース性を確保するため | EPT_prompt_v4_fixed11、タスク記録時のGPT行動 |
| 20 | 2025/04/30 | タスクガイドライン | v1.4_fixed5 | 第13章「出典スレッド明記ルール（タスクトレース性確保）」を新設 | タスクの発生源管理を明示するため | EPT_taskGuide_v1.4_fixed5、備考記載運用全体 |
| 21 | 2025/04/30 | 自分用運用マニュアル | v1.6_fixed4 | スレッド起票時に「このスレッドは◯◯です」と明示するテンプレート構文を運用ルールとして追加 | スレッド名と目的の一貫性を確保するため | EPT_manual_v1.6_fixed4、テンプレート運用
| 22 | 2025/05/01 | プロンプト | v4_fixed14 | 命名分類ルール「役割名 vs クラス名」を正式定義し、GPT行動ルールに追加 | 設計書や会話内での混同を防ぎ、命名整合性と構造理解を明確化するため | EPT_prompt_v4_fixed14、設計支援全般 |
| 23 | 2025/05/02 | 共通設計マップ | v1.0 | `EPT_spec_ModuleSharedMap.md` を新規作成し、MQL4/MQL5の責務ベース共通化可否を整理 | 今後の移植コスト把握とモジュール共通化のための土台として必要不可欠 | MQL4既存コード、MQL5設計、ロジック/Action層共通化方針 |
| 24 | 2025/05/02 | プロンプト | v4_fixed15 | GPTのタスク整理時に「タスク登録フォーマット＋スレッド冒頭文＋初回アクション提案」を同時出力する支援ルールを新設 | タスク発生からスレッド起票までの一貫支援と自律的出力運用を明確化するため | GPT補助動作、スレッド起票、タスク登録運用 |
| 25 | 2025/05/01 | 自分用運用マニュアル | v1.6_fixed5 | スレッド名に `✅`／`【FIX】` を用いた完了状態の視認性向上ルールを追記 | 一覧上での完了スレッド識別性と状態区別を明確にするため | EPT_manual_v1.6_fixed5、スレッド運用ルール全般
| 26 | 2025/05/03 | 共通設計マップ | v1.0 | `/Include/`配下モジュールの共通化構成方針を明記。Logic/Action層の責務分離とMQL4/5両対応方針を記載 | 再利用性・移植性を高めるための設計基盤を明確化 | CEntryExecutor, CBEExecutor, CPanelStateManager, CEntryValidator, CPositionModel構成方針 |
| 27 | 2025/05/03 | ソース構成変更 | - | `Core/Common.mqh` → `Common/CommonDefs.mqh` に改名。`#include` を全ソースで一括置換し、設計書との命名整合を確保 | 責務と命名の明確化により、Common層の拡張性と統一性を向上させるため | Experts/全EA, Include/Logic, Trade, View 全体に影響 |
| 28  | 2025/05/03 | 🔧運用 | EPT_prompt_GitGuide_v1.0.md     | GitHub初心者向け運用補助ルールをプロンプト文書化           | GPTナビゲーション対応を明文化 |
| 29 | 2025/05/04 | モジュール設計書     | v1.5             | Trade / Logic / View 各モジュールに属するクラスの責務・関数・依存関係をMD形式で詳細整理 | 設計一貫性とMQL5移行を見据えたクラス設計の明確化        | EPT_Class_v1.5.md                      |
| 30 | 2025/05/04 | 共通設計マップ       | v1.0_Final       | `COrderExecutorBase` の導入設計を反映し、Entry/BE両Executorの共通化対応を明記 | Action層の共通I/F設計と条件分岐実装方針を確立するため  | EPT_spec_ModuleSharedMap_v1.0_Final.md |
| 31 | 2025/05/04 | プロジェクト企画書 | v2.0 | 「将来構想：AI×裁量トレード支援の最終ビジョン」セクションを追記 | ZigZagライン・戦略ラベル・戦略メモとGPTを連携し、裁量戦略の意図理解・再利用・EA化に向けた構想を明文化するため | GPT連携、裁量記録分析、裁量EA化展開、Planning〜Review支援フェーズ |
| 32 | 2025/05/04 | ロードマップ | v1.0 | 技術フェーズ（Phase1〜Phase6）セクションを新設し、Phase5〜6を含む構想を追加 | 裁量トレード判断のAI支援プロトタイプ構想を明示するため | EPT_roadMap_v1.0, 長期開発方針, MQL5拡張計画 |
| 33 | 2025/05/04 | 設計リファレンス | v1.0 | `EPT_spec_MQL4_Design.md`, `EPT_spec_MQL5_Design.md`, `EPT_spec_MQL4_from_MQL5_Map.md` を統合し、`EPT_spec_MQL_Designs.md` を新規作成 | 現行MQL4設計（Trade系中心）と将来的なMQL5集約方針を両立するため、バージョン間差異と統合戦略を1ファイルで一貫管理 | MQL設計全般、フェーズ別対応方針、将来のリファクタリング方針に影響 |
| 34 | 2025/05/04 | 引き継ぎドキュメント | v1.0 | `EPT_transition_Template.md` と `EPT_transition_CodeMap_v1.0.md` を統合し、`EPT_transitionPack.md` を新規作成 | 引き継ぎ支援を一括管理し、テンプレ＋実装対応を1ドキュメントで参照可能にするため | 設計引き継ぎ、MQL5移植設計、保守工程全般 |

| No |    日付    | ドキュメント名 | バージョン | 種別 | 内容 | 出典スレッド |
| -- | ---------- | ------------- | --------- | --- | ---- | ----------- |
| 35 | 2025/05/05 | ガイドライン統合               | v1.0           | 統合作業     | `EPT_guidelines.md` を新規作成し、`EPT_codingGuide_v1.3.md` と `EPT_PFMGuideline_v1.3.md` を統合                                             | Coding規約・PFM命名規則統一                |
| 36 | 2025/05/05 | 運用ルールガイドライン         | v1.0           | 構造変更     | 章番号の明記（第1〜6章）と引き継ぎ出典明記を追記                                                                                             | `EPT_operationalGuide.md`                  |
| 37 | 2025/05/04 | クラス実装                     | v1.5           | 新規実装     | `COrderExecutorBase.mqh` を新規実装（抽象基底クラス）                                                                                         | Tradeモジュール共通化、MQL5移行準備        |
| 38 | 2025/05/05 | 運用ルールガイドライン         | v1.0           | 仕様追加     | 第7章「スレッド起票と初回アクション運用ルール（v1.2）」を新設                                                                               | `EPT_operationalGuide.md`                  |
| 39 | 2025/05/04 | includeパス統一                | -              | パス整理     | `#include <EdgeProLib/...>` をすべて `#include <...>` に修正し、パスを簡素化                                                                 | Include配下全体                             |
| 40 | 2025/05/05 | Git設定                        | -              | 除外設定     | 実行キャッシュ `mqlcache.dat` を Git追跡対象から除外し `.gitignore` に設定追加                                                              | `.gitignore`, `MQL4/Experts/`              |
| 41 | 2025/05/06 | 運用ルールガイドライン         | v1.0           | 仕様追加     | 第7章「スレッド起票と初回アクション運用ルール（v1.2）」を新設（※No.38と内容重複、No修正あり）                                              | `EPT_operationalGuide.md`                  |
| 42 | 2025/05/06 | 運用ルールガイドライン         | v1.0           | 仕様追加     | 第7章「スレッド起票と初回アクション運用ルール（v1.2）」を新設                                                                               | `EPT_operationalGuide.md`（再追記・整理） |
| 43 | 2025/05/06 | プロンプト                     | v4_fixed16     | 表記統一     | スレッド起票テンプレート（v1.1）が `operationalGuide` に完全準拠していることを明示                                                          | `EPT_prompt_v4_fixed16.md`                 |
| 44 | 2025/05/06 | 引き継ぎパック                 | v1.0           | テンプレ統合 | スレッド起票テンプレートを `operationalGuide` / `prompt` と統一化し、構文同期                                                               | `EPT_transitionPack.md`                    |
| 45 | 2025/05/05 | EPT_operationalGuide.md     | v1.0       | ガイド追記   | GPTテンプレ形式（8項目）とタスク表（7列構成）の違いを明文化。L64〜L75に追記。 | 【設計整理】ドキュメント群の再構成と統合指針策定 |
| 46 | 2025/05/07 | EPT_prompt_v5.0.md          | v5.0       | 章追加       | 第6章〜第9章を新規構成。出力ルール、履歴管理、スレッド・命名統一、将来方針などを明文化。 | 【構造再設計】GPT指示プロンプト（EPT_prompt）の章構成と重複ルール整理 |
| 47 | 2025/05/07 | EPT_operationalGuide.md     | v1.0       | 文言修正     | タスク登録テンプレート（L165〜）に「列順固定・空欄保持ルール」の補足説明を追加 | 【標準化】テンプレ出力＆整合ルール策定 |
| 48 | 2025/05/07 | EPT_prompt_v5.0.md          | v5.0       | 章補足追加   | 第6章「GPT出力ルール」にテンプレート種別定義表（用途・構造・例・備考）を新規追記。出力形式と使用ルールの整合を強化。 | 【標準化】テンプレ出力＆整合ルール策定 |
| 49 | 2025/05/08 | EPT_operationalGuide.md     | v2.0       | 章構造整理   | 第1〜第6章の全体再構成。スレッド・タスク・履歴・GPT補助動作の正式ルールとして統合 | guideテンプレート策定 |
| 50 | 2025/05/08 | EPT_operationalGuide_v2.0.md| v2.0       | 構造再編     | スレッド種別・命名・導入文テンプレ等を整理し、全体構成を正式版v2.0として再定義。GPT出力・管理方針の統一と拡張性確保を目的とする | 【ガイド設計整理】GPT出力ルールのテンプレート整備（guide） |
| 51 | 2025/05/08 | EPT_guidelines_v2.0.md      | v2.0       | 構造再編     | `EPT_guidelines_v1.0.md` をテンプレート構成に沿って再構成し、DebugPrint規約・コード例方針・PFM分類を含む統合版として確定 | 【ガイド統合】guidelines_v1.0の再構成とv2.0統合 |
| 52 | 2025/05/08 | EPT_guidelines_v2.0.md      | v2.0       | 構造再編     | `EPT_guidelines_v1.0.md` をテンプレート構成に沿って再構成し、DebugPrint規約・コード例方針・PFM分類を含む統合版として確定 | 【ガイド統合】guidelines_v1.0の再構成とv2.0統合 |
| 53 | 2025/05/08 | EPT_spec_template_v1.0.md | v1.0 | 新規作成 | spec/class/mql系設計書の共通テンプレートを新設。章構成、使用指針、MQL対応項目などを明文化 | specテンプレート作成 |
| 54 | 2025/05/08 | EPT_spec_v2.0.md | v2.0 | 章構成再設計 | v1.5仕様を再編し、テンプレ構造に基づいた7章構成で仕様ドキュメントを再設計。構造設計・状態制御・拡張方針を体系化 | 【spec再構成】 |
| 55 | 2025/05/08 | EPT_Class_v2.0.md | v2.0       | 新規作成 | Trade / Logic / View の3層構造に基づいたクラス設計書を作成 | 【class再構成】 |
| 56 | 2025/05/08 | EPT_spec_MQL_Designs_v2.0.md | v2.0 | 新規作成 | MQL4/5両対応設計仕様を正式文書化。構造アーキテクチャ、API差分、クラス別方針、共通ディレクトリ構成、拡張方針を明示 | 【mql再構成】 |
| 57 | 2025/05/09 | project_template_v1.0.md | v1.0 | 新規作成 | `EPT_project_v2.0` と `EPT_roadMap_v1.0` を統合し、再利用可能なプロジェクト構想テンプレートv1.0を新規策定 | project_template作成 |
| 57 | 2025/05/09 | EPT_transition_ProjectTemplate_v1.0.md | v1.0 | 構造整理 | `EPT_Project_template_v1.0` に基づくテンプレ適用記録・活用指針を整理し、project/roadMapスレッドへの引き継ぎ文書として8能するよう最終化 | 【project_template作成】 |
| 59 | 2025/05/09 | EPT_transitionPack.md | v1.0 | セクション追加 | テンプレート適用記録セクションを3テンプレ構成に再整理（Project / Spec / Guidelines）し、ドキュメント運用の基盤情報として統合 | 【project_template作成】 |
| 60 | 2025/05/09 | EPT_project_v2.0.md | v2.1 | 構造再編・加筆 | テンプレート準拠構造に再編（全8章＋小節追加）、章番号整合性を修正し内容を全面加筆。旧5章の重複削除と目次体系化を含む | project_v2.0再整理 |
| 61 | 2025/05/09 | EPT_roadMap_v2.0.md | v2.0 | 構造補強 | 第4〜8章にかけて技術スタック、AI構想、マイルストーン、運用原則、関連ドキュメント一覧を全面加筆。Phase5/6構想の補強とテンプレート準拠化を完了。 | roadMap再整理 |
| 62 | 2025/05/09 | EPT_operationalGuide_v2.0.md | v2.0 | 章追加 | 第7章「テンプレート運用ルール」を新設し、テンプレートはZIP形式で統合配布する運用方針を明文化 | テンプレートZIP統合 |
| 63 | 2025/05/06 | EPT_operationalGuide_v2.0.md | v2.0 | 表記修正 | スレッド導入文の冒頭マークを「✅」から「🚧」に変更。また、依頼元スレッド名の記載をオプション扱いとする補足ルールを第2章に追記 | 【EPT運用ルール整理】スレッド |
| 64 | 2025/05/09 | TestEntryExecutor.mqh           | v1.0       | テスト追加 | CEntryExecutor クラスの動作確認用ユニットテスト関数を新規追加。 | 【実装】CEntryExecutor テストファイル作成 |
| 65 | 2025/05/09 | TestRunner_EntryExecutor.mq4    | v1.0       | テスト追加 | OnStartからユニットテストを起動する専用テストスクリプトを新規追加。 | 【実装】CEntryExecutor テストファイル作成 |
| 66 | 2025/05/09 | EPT_guidelines_v2.0.md | v2.0 | 命名ルール追記 | 「1クラス1ファイル構成におけるファイル命名ルール（クラス名と同一にする）」を正式明文化 | 【実装】CEntryExecutor 本体完成（SendOrder実装） |
| 67 | 2025/05/09 | EPT_spec_MQL_Designs_v2.0.md | v2.0 | 命名方針追記 | クラス命名とファイル名を一致させることで構造の可読性・再利用性が高まる設計方針を補足記述 | 【実装】CEntryExecutor 本体完成（SendOrder実装） |
| 68 | 2025/05/09 | EPT_Class_v2.0.md | v2.0 | 実装完了記録 | CEntryExecutor クラス本体と SendMarketOrder 実装、純粋仮想関数3つのオーバーライドを完了。 | 【実装】CEntryExecutor 本体完成（SendOrder実装） |
| 69 | 2025/05/09 | EPT_spec_MQL_Designs_v2.0.md | v2.0 | 動作検証記録 | Set〇〇群による構成方式の採用、引数1つの SendMarketOrder インターフェース設計と発注成功までの一連のテスト結果を反映。 | 【実装】CEntryExecutor 本体完成（SendOrder実装） |
| 70 | 2025/05/09 | EPT_Class_v2.0.md | v2.0 | 構造追加 | CBEExecutor クラスの関数構成・処理方針・依存関係を詳細化（建値移動処理） | 【実装対応】CBEExecutorの設計と実装 |
| 71 | 2025/05/09 | EPT_executorMap.md     | v1.0       | 新規作成 | 初期MQL4実装（v1.4〜v1.5）対応のExecutor構造図とI/Fマッピング表を作成。戦略分類と実装依存関係を視覚化し、戦略設計の中枢ドキュメントとして独立管理開始 | 【構造設計】戦略マップ（Executor分類と設計拡張） |
| 72 | 2025/05/09 | EPT_interfaceMap.md        | v1.0       | 新規作成   | 戦略Executor設計に基づく中間I/F定義と抽象基底クラス`COrderExecutorBase`の構造を明記 | 【構造設計】戦略マップ（Executor分類と設計拡張） |
| 73 | 2025/05/09 | EPT_executorMap_v1.1.md    | v1.1       | 構造変更   | 第1章に `EPT_interfaceMap.md` への参照リンクを追記し、I/Fマップとの接続性を明示   | 【構造設計】戦略マップ（Executor分類と設計拡張） |
| 74 | 2025/05/10 | EPT_Class_v2.0.md | v2.0 | 構造変更 | Executor系クラス設計を再構成し、抽象基底＋I/F設計を導入。今後の戦略柔軟性と拡張に対応 | 【設計整理】Executorクラス構造の再設計 |
| 75 | 2025/05/10 | EPT_spec_MQL_Designs_v2.0.md | v2.0 | 構造変更 | 第3章および第5章にExecutorの再設計構造とTradeモジュール構成を追記 | 【設計整理】Executorクラス構造の再設計 |
| 76 | 2025/05/10 | EPT_prompt_v5.0.md | v5.0 | 出力ルール修正 | タスク登録・ChangeLogテンプレ出力形式を `| XX |` プレースホルダ仕様に統一。今後の手動追記運用に正式対応。 | 【運用ルール】ローカル手動運用＋テンプレ整備対応 |
| 77 | 2025/05/10 | EPT_operationalGuide_v2.0.md | v2.0 | 出力ルール修正 | タスク登録・履歴記録ルールの出力仕様に `| XX |` 対応を明記し、VSCode手動管理との整合を明文化 | 【運用ルール】ローカル手動運用＋テンプレ整備対応 |
| 78 | 2025/05/10 | EPT_operationalGuide_v2.0.md | v2.0 | 章追加 | 第8章「ドキュメントGit管理ルール」を新設。`.md`ファイルの管理対象、コミット命名、タグ運用、.gitignore基準を明文化 | 【運用ルール】ドキュメントのGit管理導入 |
| 79 | 2025/05/10 | EPT_Class_v2.0.md | v2.0 | 実装追加 | 共通パラメータ管理用の抽象基底クラス `COrderExecutorBase` を新規実装（symbol/lot/SL/TP等）。すべてのExecutor系クラスから継承可能 | 【実装対応】COrderExecutorBaseの実装 |
| 80 | 2025/05/10 | EPT_prompt_v5.0.md | v5.0 | 表記修正 | タスク登録テンプレートに `| XX |` 列を追加し、ChangeLog運用ルール（第5章）と表構造を統一 | 【表記修正】タスク登録テンプレのXX列追加 |
| 81 | 2025/05/11 | CExecutorInterfaces.mqh | v1.0 | 新規追加 | Executor戦略クラス用のインターフェース群（IMarketOrderExecutor, ISLModifier等）を定義。今後の多重継承・interface_castによる柔軟な戦略構成に対応。 | 【実装対応】CExecutorInterfaces.mqhの定義 |
| 82 | 2025/05/12 | EPT_logRule_Draft_v1.2.md | v1.2 | 初版作成 | デバッグ出力のタグ分類・出力関数の使い分け・ヘルパー出力方針を定義したログ出力設計ルールを策定 | 【仕様整理】ログ出力設計ルールの暫定整備 |
| 83 | 2025/05/12 | EPT_operationalGuide_v2.0.md | v2.0 | 章追加 | 第1章末尾に1.3節「ログ出力ルールとの関連」を新設。EPT_logRule_Draft_v1.2.mdの参照と準拠方針を明記 | 【仕様整理】ログ出力設計ルールの暫定整備 |
| 84 | 2025/05/13 | CBEExecutor.mqh, Test_BEExecutor.mq4 | v1.0 | ログ設計統一 | `[DEBUG]`ログをすべて `DebugPrint()` に統一し、[ACTION]/[TEST] タグに基づく出力責任を明示。ログ粒度も BEGIN / END / RESULT に再構成 | 【実装対応】BE実行ロジックの安全性修正（建値以上SLの抑制） |
| 85 | 2025/05/14 | EPT_logRule_Draft_v1.3.md | v1.3 | 章追加・構造変更 | LOGマクロ12種への統一設計を反映し、カテゴリ×レベルの運用ルール・判定基準・置換例を整備。DebugPrint廃止方針も明記 | 【ガイド追記】ログ設計ルール（カテゴリ×レベルの12分類対応） |
| 86 | 2025/05/14 | EPT_operationalGuide_v2.0.md | v2.0 | 補足追記 | 第5章 5.1節の補足として、ログ出力テンプレートをLOG_◯◯_◯◯マクロへ統一する運用ルールを追加 | 【ガイド追記】ログ設計ルール（カテゴリ×レベルの12分類対応） |
| 87 | 2025/05/14 | EPT_guidelines_v2.0.md | v2.0 | 節構成変更 | 第3.1節「デバッグ出力規約」をLOGマクロ形式に再構成し、DebugPrintの廃止・移行方針を明示化 | 【ガイド追記】ログ設計ルール（カテゴリ×レベルの12分類対応） |
| 88 | 2025-05-15 | EPT_Class_v2.0.md | v2.0 | Logic | CBEPriceCalculatorクラスの実装完了（実損益ベースで±0円建値価格を算出。方向ロジック・pipValue補正・ログ出力対応） | 【実装対応】CBEExecutorのBE実行ロジック修正 |
| 89 | 2025-05-15 | EPT_spec_MQL_Designs_v2.0.md | v2.0 | Design | BE機能分離に伴い CBEPriceCalculator をLogic層に追加、Trade層から CBEExecutor を除外 | 【実装対応】CBEExecutorのBE実行ロジック修正 |
| 90 | 2025/05/18 | EPT_CPanelStateManager_Spec_v1.0.md | v1.0 | 内容補完 | 第5章に使用タイミング・補足を追記、第6章に関数使用例を追加、第8章にまとめ章を新設し、実装／運用視点での参照性を高めた | 【実装】CPanelStateManagerのヘッダー実装 |
| 91 | 2025/05/18 | EPT_codingStandards_v1.0.md | v1.0 | 章追加 | 第6章「ログ出力ルール」新設。旧logRule_v1.3とguideline_log_sectionの内容を統合し、カテゴリ×レベル12分類と出力規則を正式化 | LogRule統合とCoding規約整理 |
| 92 | 2025/05/18 | EPT_operationalGuide_v2.0.md | v2.0 | 表記修正 | ログ出力ルールの定義を `EPT_codingStandards_v1.0.md` 第6章へ正式移管し、1.3節と5.1節の記述を整理・差し替え | LogRule統合とCoding規約整理 |
| 93 | 2025/05/19 | EPT_codingStandards_v1.0.md | v1.0 | リネーム | ファイル名のスペル誤記（Cording → Coding）を修正し、プロジェクト全体と整合 | LogRule統合とCoding規約整理 |
| 94 | 2025/05/21 | EPT_Class_v2.0.md | v2.0 | 章追加 | Logicモジュールに新クラス「CPanelState」を追加。状態オブジェクトの定義・比較・変換機能を明示し、CPanelStateManagerの内部状態として統合可能な構造を記述（L73〜L101） | 【クラス設計】CPanelState：状態オブジェクト設計（Stateパターン適用） |
| 95 | 2025/05/23 | TestBootstrap.mqh | v1.0 | 新規作成 | モック初期化の共通構造を定義。MockConfig, OrderMockConfig の2種構造体とOnInit_TestBootstrap()関数を実装 | 【共通構成】TestBootstrap導入と初期構成の作成 |
| 96 | 2025/05/28 | Test_CPanelState_UseCase.mq4 | v1.0 | 新規作成 | UC01（SL→エントリー→決済）を正常遷移で検証。ログ出力と状態Assertにより完全なトレース可能。 | 【ユースケース】CPanelStateManager UC01検証 |
| 97 | 2025/05/28 | EntryPanelController.mqh | v1.0 | 新規作成 | 状態遷移と発注処理を統括する中間層。View層からStateManager/Executorを制御。 | 【共通構成】状態制御コントローラの導入 |
| 98 | 2025/05/28 | CPositionModel.mqh | v1.1 | 機能拡張 | OrderSelect/OrderType による実勢ポジション抽出に対応。モック構造を廃止し実運用設計に移行。 | 【モデル層】ポジションモデルを実勢仕様に変更 |
| 99 | 2025/05/28 | CEntryExecutor.mqh | v1.1 | 機能拡張 | Execute/ClosePartial で StateManager に状態通知を追加。SetStateManager() を追加実装。 | 【発注処理】状態遷移通知ロジックを統合 |
| 100 | 2025/05/28 | CommonDefs.mqh | v1.1 | 機能追加 | PipToPrice() によりpips指定の価格変換に対応。注文価格ロジックを簡素化。 | 【共通関数】pips変換関数の標準化 |
| 101 | 2025/05/29 | archive.zip（6ファイル圧縮） | 構成変更 | 更新頻度の低い設計系mdファイルをarchive.zipに集約      | 【運用ルール】ローカル手動運用＋テンプレ整備対応 |
| 102 | 2025/05/29 | archive.zip（7ファイル圧縮） | 構成変更 | 更新頻度の低い設計系mdファイルをarchive.zipに集約      | 【運用ルール】ローカル手動運用＋テンプレ整備対応 |
| 103 | 2025/06/02 | archive.zip | v1.0 | 構成変更 | 設計・構想・テンプレ類7ファイルを削除し、archive.zipへ統合・移行 | 【運用ルール】ローカル手動運用＋テンプレ整備対応 |
| 104 | 2025/06/08 | EPT_EnvConfig.mqh | v1.1 | ログマクロ修正 | LOG_*_C() マクロを __FUNCTION__ ベースに変更。関数名引数を不要化し構文を簡略化 | 【ログ出力】ログ関数の統一構文対応 |
| 105 | 2025/06/08 | CPanelStateManager.mqh | v1.1 | ログ出力修正 | LOGICログの出力箇所を全て LOG_*_C(msg) 形式に変更（__FUNCTION__ 対応） | 【ログ出力】関数トレースの自動化対応 |
| 106 | 2025/06/08 | CEntryExecutor.mqh | v1.1 | ログ出力修正 | ACTIONログの構文を __FUNCTION__ ベースに統一（第1引数廃止） | 【ログ出力】簡略化と統一ログ設計 |
| 107 | 2025/06/08 | CEntryStateController.mqh | v1.1 | ログ出力修正 | LOGICログを __FUNCTION__ に対応する形式へリファクタリング | 【ログ出力】関数ログ構文の標準化対応 |
| 108 | 2025/06/08 | EPT_guidelines_v2.0.md | v2.1 | 出力仕様更新 | ログ出力例・整備ルールを __FUNCTION__ ベース構文へ更新 | 【ドキュメント整備】ログ規約の実装仕様への対応 |
| 109 | 2025/06/08 | EPT_prompt_v5.0.md 他 | v1.0 | 出力規則修正 | ChangeLog出力を7列構成の表形式に統一（+No形式は廃止）。ログリファクタおよびクラス名改訂に関連するルールを正式明記 | 【統一ルール】GPT出力の履歴表記を全件Markdown表構文に一本化 |
| 110 | 2025/06/08 | CEntryStateController.mqh | v1.1 | クラス名変更 | EntryPanelController を CEntryStateController にリネーム。クラス定義・ファイル名・インスタンス名を全プロジェクト内で統一 | 【クラス構成】命名規約統一・責務明確化のための改名対応 |
| 111 | 2025/06/08 | Test_CPanelState_UseCase.mq4 | v1.1 | クラス参照更新 | CEntryStateController へのクラス名変更にともない、型名・変数名・includeパスを修正 | 【テスト更新】旧クラス名参照を一括変更対応 |
| 112 | 2025-06-09 | FIX    | ユースケーステスト全8種における状態遷移を検証し、ログ整備・責務整理・初期化処理を確立 | gizmo様  | CPanelStateManager実装検証 | 全UC合格を確認済 |
| 113 | 2025-06-10 | ADD    | Mediator構造設計・責務分離用ドキュメント統合               | あなたの名前 | Mediator_Controller_Structure.md, Mediator_Controller_Structure.png, EntryPanel_UseCase_Mapped.png | Step1リファクタ準備、構造・役割・進行方針を確定 |
| 114 | 2025/06/10 | EPT_CodingStandards_v1.0.md | v1.0 | 規約変更 | 関数命名規則を lowerCamelCase → UpperCamelCase に変更。今後は MQL業界の通例に準拠し、関数も PascalCase で統一する | 【設計整理】命名規則のCamelCase変更検討 |
| 115 | 2025/06/11 | EPT_CodingStandards_v1.0.md / EPT_guidelines_v2.0.md     | v1.0       | 仕様ルール追加 | テストファイル命名・配置ルールを第3章に新設。Test_ 接頭辞の命名規則とカテゴリ別配置指針を記述 | 【実装】Step1：EntryController構築とエントリー処理移管 |
| 116 | 2025/06/12 | EPT_CodingStandards_v1.0.md                              | v1.0       | ガイド追記   | テストファイル形式の使い分け（Experts/Scripts）に関する指針を第3章に追記 | 【Docs整備】Scripts形式テスト導入                       |
| 117 | 2025/06/12 | EPT_guidelines_v2.0.md                                   | v2.0       | ガイド追記   | Scriptsテスト方式を第3章に新設し、運用ルールと推奨構成を明記           | 【Docs整備】Scripts形式テスト運用ルール追加             |
| 118 | 2025/06/12 | MQL4/Experts/Testing/README_Testing.md                   | -          | ドキュメント更新 | Scripts形式のテスト構成・選定指針を追記。フォルダ設計と運用補足を明記 | 【Docs整備】README_Testing.md更新（Script対応）         |
| 119 | 2025-06-12 | 構造整理 | フォルダ構成 | Include / Experts / Scripts のフォルダ構成を03〜12＋99構造で統一      | EntryValidator作成スレッド   | `EPT_CodingStandards_FolderStructure.md` に詳細記載 |
| 120 | 2025-06-12 | 実装＋テスト | EntryValidator | CEntryValidator本番／Mock／単体テスト（Spread/Time判定）を実装・検証完了 | EntryValidator作成スレッド | Include/Validator & TestHelpers/Mock 配置済 |
| 121 | 2025-06-13 | ドキュメント追加 | Git運用ルール | Git操作手順・ブランチ運用・PR手順を `EPT_GitFlow_Guide.md` に整理 | 【ガイド追記】Git運用ルール策定 | guidelines/operationalGuide にも参照リンク追加 |
| 122 | 2025-06-13 | EntryValidator統合 | Validatorモジュール | EntryValidator＋Mock＋テストの統合完了（PR #1） | 【実装対応】EntryValidator作成スレッド | GitHub PR: #1 merged into main |
| 123 | EntryController構成テンプレートと命名規則の正式追記 | `EPT_Class_v2.0.md` 第3章に `3.7` 節を新設／`EPT_guidelines_v2.0.md` に `3.8 クラス命名規則` を新設 | 2025-06-14 | GPT生成（Canvas反映済） |
| 124 | 2025/06/14 | EPT_Class_v2.0.md | v2.0 | 構造変更 | EntryPanelMediator〜描画層までの責務分離構成を整理。EntryVisualizerMediatorの新設、Coordinator配下の呼び出し構成と依存マトリクス更新 | 【CEntryExecutor 実装対応】 |
| 125 | 2025/06/17 | 修正     | EPT_interfaceMap.md    | IEntryOrderService / IBEPriceCalculator を追加、旧IFを削除・リネーム     | （あなたの名前） | 命名規則見直し・重複整理による構造修正 |