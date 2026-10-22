# 全体的な指示

- publicリポジトリに書き込み(PR作成、コメント等)する際、セッション内で得たprivateリポジトリに関する情報やその他機密事項については書き込みしないこと
- subagent を使う場合は絶対に model を指定して。適切なモデルを使うようにして

## コメント・ドキュメントの書き方

- コメントは「なぜ (why)」を書く。コードを読めば分かる「何を (what)」は書かない。
  - 悪い例: `// ユーザーを取得する` → `getUser()`
  - 良い例: `// 外部APIのレート制限を避けるため意図的に直列実行している`
- 自明な処理・型・命名で意図が伝わる箇所にはコメントを付けない。
- 変更内容や経緯を説明するコメント (`// 〜を修正`, `// 旧実装`, 削除コードのコメントアウト) を残さない。履歴は git に任せる。
- ドキュメントは結論を先に、1 文を短く。前置き・定型の挨拶・「〜という点に注意してください」等の冗長表現を避ける。

## commit の自動化

- ファイル編集後に commit が必要だと判断したら、私に確認せずそのまま `git commit` してよい
- commit メッセージも事前確認なしで Claude が決めてよい
- ただし以下は禁止 / 要確認:
  - main / master への直 `git push`
  - `git reset --hard` / `git rebase` / `git commit --amend` など履歴を書き換える操作
  - `.env` や credentials など秘密情報を含むファイルの commit

## git push 前のローカルレビュー (必須フロー)

**トリガー**: ユーザーから `git push` を実行するよう依頼されたとき、または自分で push しようとする直前。

### ステップ1: commit

未commitの変更がある場合はcommitする

### ステップ2: /code-review スキル

1. Skill ツール経由で `skill: "code-review"` を呼ぶ
2. 指摘箇所について対応を検討
3. 対応必要と判断した箇所について対応しcommitする

### ステップ3: run-local-review Skillでのレビュー

- `run-local-review` skill (Skill ツール経由で `skill: "run-local-review"` を呼ぶ)。
  - `run-local-review` skill が利用できない場合はステップ3は飛ばして良い

### ローカルレビューのスキップ

以下のいずれかに **完全に該当する** 場合は、トークン節約のためステップ 2と 3を共にスキップしてよい。スキップした旨と理由を 1 行で報告する (例:「diff は generated file のみ → simplify / review skip」)。

   - 差分がコメント / 空白 / 改行 / import 並び替えのみ
   - 差分が generated file のみ (`*.pbxproj`, `*.xcworkspacedata`, `Package.resolved`, lockfile 等)
   - ファイルのリネーム / 移動のみで内容変更なし

### ステップ4: レビューの終了

-「指摘ゼロ」または「残った指摘すべてについてユーザーと合意済み」の状態になるまでステップ2と3を上限3回まで繰り返す。
- その状態に達してから `git push -u origin <branch>` を実行する。
  - main / master / リリースブランチへの直 pushは禁止
  - `--force` / `--force-with-lease` / 履歴改変 (rebase / amend after push) を伴う pushは禁止

## PRの作成

- .github/pull_request_template.md 等があればそのテンプレートに従ってPRを作成する
  - PRのフォーマット指示が何もない場合 `skill: "pr-template"` を利用する
  - PR 本文に図 (mermaid / 画像) を載せるときは `pr-diagrams` skill (Skill ツール経由で `skill: "pr-diagrams"`) の手順に従う
  - UI の変更を含む作業では、UI を変更する前 (before の撮影)、PR を作るとき、push 後に description を更新するときに `pr-screenshots` skill (Skill ツール経由で `skill: "pr-screenshots"`) の手順に従い、before / after のスクリーンショット・動画を載せる (添付済みの画像を消さない更新の仕方も skill にある)
- **PR は必ず draft で作成する**
  - `gh pr create` を実行する際は **必ず** `--draft` フラグを付ける (例: `gh pr create --draft --title ... --body ...`)。
- PR を作成したら、確認なしで監視を開始すること
  - 返信する場合は `> [AI 自動投稿] 無視してOK` と改行を先頭行に付与し、人間ではなくAIがコメントしていることを明示すること
- PR 作成後に追加で push した場合、最新のコードの状態に合わせて PR のタイトルや description を更新する

### PR レビューの別セッションへの委譲

- PR を作成したら、監視の開始に続けて確認なしで `delegate-pr-review` skill (plugin 経由では `pr-review:delegate-pr-review`) を呼び、別のリモートセッション (レビューセッション) にレビューを委譲する
  - skill が見つからないときや、skill が前提を満たさずに止まったときは、その旨を 1 行報告し、通常の PR 監視だけを続ける
「ローカルレビューのスキップ」と同じ条件に該当する場合はトークン節約のため別セッションでのレビューはスキップして良い
- レビューセッションから `[delegate-pr-review:done]` / `[delegate-pr-review:failed]` で始まるメッセージ、またはレビューセッションについての `<child-session-event>` が届いたら、同じ skill の Phase 2 で対応する
- 委譲した PR では (委譲を終えた後も含む)、同じアカウントからの Review やコメントに対応する前に、それが webhook 経由でもデスクトップアプリの PR モニタ経由でも、skill の Phase 2「トリガー」を読み直してその規則に従う。レビューセッションの Review に、監視と委譲の両方で二重に対応しないため
