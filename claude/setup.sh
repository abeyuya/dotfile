# ~/.claude/CLAUDE.md に追記
CLAUDE_MD="$HOME/.claude/CLAUDE.md"
mkdir -p "$(dirname "$CLAUDE_MD")"
touch "$CLAUDE_MD"
cat >> "$CLAUDE_MD" <<'EOF'

## 全体的な指示

- 日本語で返答して
- ユーザーから「markdownで出して」「コピペ可能なmarkdownでちょうだい」のような指示があった場合、markdownファイルを書き出しそのファイルを表示すること
- publicリポジトリに書き込み(PR作成、コメント等)する際、セッション内で得たprivateリポジトリに関する情報やその他機密事項については書き込みしないこと
- ユーザーから「ファイルを表示して」のような指示があった場合、指示されたファイルを全文Readする。全文ReadすることチャットUI上にその内容が表示され、ユーザーは中身を確認することができる
- subagent を使う場合は絶対に model を指定して。適切なモデルを使うようにして


##  デフォルトの挙動

- PR を作成したら、確認なしで mcp__github__subscribe_pr_activity を呼んで監視を開始すること
  - 返信する場合は `> [AI 自動投稿] 無視してOK` と改行を先頭行に付与し、人間ではなくAIがコメントしていることを明示すること

### PR 監視の定期チェックイン (send_later) を無効化

PR を監視 (`subscribe_pr_activity`) している間、`send_later` などで「1時間ごとの自己チェックイン」を仕込まないこと。
定期チェックインは発火のたびにセッションが起動してプッシュ通知が飛び、ノイズになるため。

- **やらないこと**: `send_later` / スケジューラによる PR 状態の定期ポーリング
  (CI 成功・マージ・コンフリクト遷移を取りこぼさないための heartbeat)
- **やること**: webhook で届くイベント (CI 失敗・レビューコメント等) にのみ反応する
  実際に PR で何か起きたときだけ動くので、通知は最小限になる
- CI 成功・マージ・コンフリクトの自動検知は行わない (それらは対応不要 or 私自身がマージ時に気づく状態のため、実害なし)
- 例外: **私が明示的に「定期的にチェックして」「babysit して」と依頼した場合のみ**
  定期チェックインを設定してよい。その場合も間隔は私の指示に従うこと


### commit の自動化

- ファイル編集後に commit が必要だと判断したら、私に確認せずそのまま `git commit` してよい
- commit メッセージも事前確認なしで Claude が決めてよい
- ただし以下は引き続き禁止 / 要確認:
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

### ステップ4: レビューの終了

-「指摘ゼロ」または「残った指摘すべてについてユーザーと合意済み」の状態になるまでステップ2と3を繰り返す。
- その状態に達してから `git push -u origin <branch>` を実行する。
  - main / master / リリースブランチへの直 pushは禁止
  - `--force` / `--force-with-lease` / 履歴改変 (rebase / amend after push) を伴う pushは禁止

### ステップ5: PRの作成

- .github/pull_request_template.md 等があればそのテンプレートに従ってPRを作成する
- **PR は必ず draft で作成する**
  - `gh pr create` を実行する際は **必ず** `--draft` フラグを付ける (例: `gh pr create --draft --title ... --body ...`)。

### ローカルレビューのスキップ

以下のいずれかに **完全に該当する** 場合は、トークン節約のためステップ 2と 3を共にスキップしてよい。スキップした旨と理由を 1 行で報告する (例:「diff は generated file のみ → simplify / review skip」)。

   - 差分がコメント / 空白 / 改行 / import 並び替えのみ
   - 差分が generated file のみ (`*.pbxproj`, `*.xcworkspacedata`, `Package.resolved`, lockfile 等)
   - ファイルのリネーム / 移動のみで内容変更なし

## PRへのpush後のタイトル・description等の更新

PR作成後に追加でpushを行う場合、最新のコードの状態に合わせてPRのタイトルやdescriptionを更新して

EOF

# 3) ~/.claude/hooks/session-start.sh を生成
mkdir -p "$HOME/.claude/hooks"
cat > "$HOME/.claude/hooks/session-start.sh" <<'EOF'
#!/bin/bash

# 何かあればここに書く

EOF
chmod +x "$HOME/.claude/hooks/session-start.sh"

# 4) ~/.claude/settings.json に hook を登録 (jq で merge)
SETTINGS="$HOME/.claude/settings.json"
mkdir -p "$(dirname "$SETTINGS")"
[ -f "$SETTINGS" ] || echo '{}' > "$SETTINGS"
tmp=$(mktemp)
jq '.hooks.SessionStart = ((.hooks.SessionStart // []) + [{"hooks":[{"type":"command","command":"'"$HOME"'/.claude/hooks/session-start.sh"}]}] | unique)' "$SETTINGS" > "$tmp" && mv "$tmp" "$SETTINGS"
