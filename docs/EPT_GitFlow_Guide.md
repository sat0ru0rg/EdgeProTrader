# 📘 EPT\_GitFlow\_Guide.md

## ✅ このドキュメントの目的

EdgeProTraderプロジェクトにおいて、Git運用の一貫性を確保し、誤操作を防ぐための標準ガイドラインです。

---

## 1. 基本ルール

* `main` ブランチは常に安定版（動作確認済）であること。
* すべての新機能・修正作業は **個別のブランチ（feature/xxx）** を作成して実施すること。
* 作業が完了したら、GitHub上で Pull Request（PR）を作成し、**記録・確認・マージ**を行うこと。

---

## 2. 開発ブランチの作成と作業手順

```bash
# main から新しいブランチを作成
$ git checkout -b feature/entry-validator

# 通常の開発・編集を行う
$ git add .
$ git commit -m "Add: EntryValidator 実装と単体テスト"

# リモートへプッシュ
$ git push origin feature/entry-validator
```

---

## 3. Pull Request（PR）作成手順

1. GitHubにアクセスし、「Compare & Pull Request」をクリック
2. PRのタイトルと本文に以下を記述：

   * 目的
   * 主な変更点（例：Validator本体／Mock／テスト）
   * 動作確認の有無

```markdown
✅ Add: EntryValidator 実装と単体テスト

- CEntryValidator 本番用クラスの実装
- MockEntryValidator による単体テスト実行済み
- Spread / Time 判定ロジックに対する検証完了
```

3. 内容を確認し、「Merge Pull Request」ボタンを押して main へ統合

---

## 4. マージ後のローカルmain更新

```bash
# mainに戻る
$ git checkout main

# 最新のmainを取得
$ git pull origin main
```

---

## 5. その他ルール・注意点

* PRが作成されていないコードは、原則として main にマージしない
* PRには必ず日本語での目的・背景を明記する
* 削除済みのブランチは `git branch -d`（ローカル）／`--delete`（リモート）で整理

---

## 📌 このガイドの参照ルール

他のドキュメント（`EPT_operationalGuide.md` / `EPT_guidelines.md`）に以下のように明記：

> 「Git操作を行う際は、必ず `EPT_GitFlow_Guide.md` に従ってください」


## ✅ 最後に

本ガイドは随時更新・強化されます。変更時は必ず `ChangeLog` に記録し、タスクスレッドでも共有してください。
