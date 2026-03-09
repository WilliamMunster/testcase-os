# testcase-os

> telos アーキテクチャに基づいた汎用テスト知識ベース管理システム。Gitネイティブ、Markdownファースト、Skillドリブン。

## 概要

testcase-osは、QAチームがGitとMarkdownを使用してテストケース、知識、経験を管理するのに役立ちます。独自のデータベースも、ベンダーロックインもありません—既存の開発者ツールと連動するプレーンテキストファイルだけです。

### 主な機能

- **Gitネイティブ**: バージョン管理、コラボレーション、監査証跡を内蔵
- **Markdownファースト**: すべてのテストケースを人間が読めるMarkdownカードとして保存
- **Skillドリブン**: 自動コンテキストインジェクションなし—明示的なSkillトリガーのみ
- **知識の再利用**: チェックリスト、パターン、方法論を含むCommonsライブラリ
- **経験のループ**: インシデントや見逃されたバグを追跡して継続的に改善
- **業界ベンチマーク**: 競合分析のための組み込みサポート

## クイックスタート

### 1. リポジトリのクローン

```bash
git clone https://github.com/your-org/testcase-os.git
cd testcase-os
```

### 2. セットアップの実行

```bash
bash setup.sh
```

これにより、基本的なディレクトリ構造が作成され、設定ファイルが初期化されます。

### 3. プロジェクトの設定

`_system/config.yaml`を編集します：

```yaml
project:
  name: "Your Project"
  team: "QA Team"

jira:
  url: "https://jira.company.com"
  project_key: "PROJ"

review_policy:
  p0_requires_review: true
  p1_requires_review: true
  p2_requires_review: false
  p3_requires_review: false
```

### 4. Identityの設定

チームとプロジェクト情報を`_system/identity.md`に記入します。

### 5. Skillの使用開始

```bash
# PRDからテストケースを設計
kimi-cli skill case-design --prd PRD-2026-001.md

# 今日のテストを記録
kimi-cli skill daily-track

# テストケースを検索
kimi-cli skill search --module user --priority P0
```

## ディレクトリ構造

```
testcase-os/
├── _agents/
│   └── instructions/
│       └── shared.md          # AIエージェントの指示
├── _system/
│   ├── identity.md            # チーム/プロジェクトのIdentity
│   ├── goals.md               # 品質目標とOKR
│   ├── active-context.md      # 現在のスプリントフォーカス
│   └── config.yaml            # プロジェクト設定
├── cases/                     # テストケースライブラリ
│   ├── _index.md
│   └── {module}/
│       ├── _module.md
│       └── TC-{MOD}-{NNN}.md  # テストケースカード
├── commons/                   # 再利用可能なテスト資産
│   ├── checklists/            # テストチェックリスト
│   ├── patterns/              # テストパターン
│   ├── methodology/           # テスト方法論
│   └── _index.md
├── knowledge/                 # ビジネスと技術の知識
│   ├── domain/                # ビジネスドメイン知識
│   └── tech/                  # 技術知識
├── experience/                # 学んだ教訓
│   ├── incidents/             # 本番インシデント
│   ├── missed-bugs/           # 見逃されたバグ
│   ├── techniques/            # テスト技法
│   └── anti-patterns/         # 一般的な落とし穴
├── journal/                   # 日次テストログ
│   └── YYYY-MM-DD.md
└── scripts/                   # ユーティリティスクリプト
    ├── jira-cli.sh
    ├── import-excel.sh
    └── sanitize.sh
```

## 利用可能なSkill

### case-design
業界ベンチマークを含むPRDドキュメントからテストケースを設計します。

```bash
kimi-cli skill case-design --prd PRD-2026-001.md --module user
```

### case-import
GherkinまたはExcelファイルからテストケースをインポートします。

```bash
kimi-cli skill case-import --file features/login.feature --format gherkin
kimi-cli skill case-import --file tests.xlsx --format excel
```

### case-execute
ステップバイステップのガイダンスでテストケースを実行します。

```bash
kimi-cli skill case-execute --id TC-USER-001
```

### daily-track
日次のテストアクティビティと統計を記録します。

```bash
kimi-cli skill daily-track --today
```

### search
様々な基準でテストケースを検索します。

```bash
kimi-cli skill search --module user --priority P0
kimi-cli skill search --tag regression --status active
```

### jira-sync
PRDのプルとバグ提出のためにJiraと同期します。

```bash
kimi-cli skill jira-sync --pull-prd PROJ-1234
kimi-cli skill jira-sync --create-bug bugs/BUG-001.md
```

## テストケースカード形式

テストケースはYAMLフロントマターを持つMarkdownファイルとして保存されます：

```yaml
---
id: TC-USER-001
title: 有効なデータでのユーザー登録
module: user
priority: P0
type: functional
stage: [smoke, regression]
status: active
source: prd
source_ref: "PRD-2026-001 Section 3.2"
review: pending
risk: high
risk_reason: "コアユーザージャーニー"
author: qa-engineer
created: 2026-03-09
updated: 2026-03-09
tags: [registration, smoke, positive]
---

# 有効なデータでのユーザー登録

## 背景
新規ユーザーはメールとパスワードで登録できなければなりません。

## 前提条件
- ユーザーは登録ページにいる
- メールはまだ登録されていない

## テストステップ

| # | ステップ | 入力データ | 期待結果 |
|---|----------|------------|----------|
| 1 | メールを入力 | user@test.com | メールが受け入れられる |
| 2 | パスワードを入力 | SecurePass123 | パスワードがマスクされ、強度が表示される |
| 3 | 登録をクリック | - | アカウントが作成され、確認メールが送信される |

## 業界ベンチマーク
> **参考**: 競合Xは24時間以内のメール確認を必要とする
> **ギャップ**: 当社のPRDはメール確認のタイミングを指定していない
```

### フロントマターフィールド

| フィールド | 必須 | 説明 |
|-----------|------|------|
| `id` | はい | 一意の識別子 (TC-{MODULE}-{NNN}) |
| `title` | はい | テストケースのタイトル |
| `module` | はい | モジュール名 |
| `priority` | はい | P0/P1/P2/P3 |
| `type` | はい | functional/performance/security/compatibility/usability |
| `source` | はい | prd/commons/benchmark/untracked |
| `review` | はい | pending/approved/rejected |
| `risk` | 推奨 | high/medium/low |
| `tags` | いいえ | タグのリスト |

## アップグレードパス

### 個人/小規模チーム（現在）
- 単一リポジトリ
- 直接ファイル編集
- Skillベースの対話

### チーム規模（V2）
- ロールベースの権限のための`team.yaml`
- 監査ログのためのGitフック
- MCPサーバー統合

### エンタープライズ（telos-team統合）
- 集中型ユーザー管理
- 高度な分析
- マルチプロジェクトサポート

## 貢献

貢献を歓迎します！詳細は[Contributing Guide](CONTRIBUTING.md)をご覧ください。

### Commonsの追加

1. 適切な`commons/`サブディレクトリにファイルを作成
2. 英語のファイル名（kebab-case）を使用
3. 既存の形式に従う
4. `commons/_index.md`を更新

### Issueの報告

バグの報告や機能のリクエストには[issue tracker](https://github.com/your-org/testcase-os/issues)を使用してください。

## ライセンス

MIT License - 詳細は[LICENSE](LICENSE)ファイルをご覧ください。

## 他の言語

- [English](README.md)
- [简体中文](README.zh-CN.md)

---

*telosアーキテクチャの原則で構築。*
