# 1) ~/.claude/CLAUDE.md に claude/CLAUDE.md の内容を追記
#    - curl | bash で実行されるため、本文はリポジトリの master から取得する
#    - 取得に失敗してもセッションの起動を止めないよう、WARN だけ出して続ける
#    - 途中までの内容を書き込まないよう、一時ファイルに取得してから追記する
CLAUDE_MD="$HOME/.claude/CLAUDE.md"
CLAUDE_MD_URL="https://raw.githubusercontent.com/abeyuya/dotfile/master/claude/CLAUDE.md"
mkdir -p "$(dirname "$CLAUDE_MD")"
touch "$CLAUDE_MD"
claude_md_tmp=$(mktemp)
if curl -fsSL --max-time 30 "$CLAUDE_MD_URL" -o "$claude_md_tmp"; then
  { echo; cat "$claude_md_tmp"; } >> "$CLAUDE_MD"
else
  echo "[setup] WARN: failed to fetch $CLAUDE_MD_URL" >&2
fi
rm -f "$claude_md_tmp"

# 2) pr-review plugin を user scope にインストール (CLAUDE.md の delegate-pr-review 用)
#    - 失敗や停止でセッションの起動を止めないよう、timeout を付けて WARN だけ出して続ける
#      (timeout コマンドが無い環境では timeout なしで実行する)
#    - 既に入っていると install は何もしないので、update で最新版にする
#    - -y は付けない (marketplace が宣言したコマンドを無人で承認しない)
#    - curl | bash で実行されるため、stdin (= このスクリプトの残り) を読ませないよう /dev/null を渡す
run_with_timeout() {
  if command -v timeout >/dev/null 2>&1; then
    timeout 90 "$@"
  else
    "$@"
  fi
}
if command -v claude >/dev/null 2>&1; then
  run_with_timeout claude plugin install pr-review --marketplace abeyuya/skills --scope user </dev/null \
    || echo "[setup] WARN: pr-review plugin install failed" >&2
  run_with_timeout claude plugin update pr-review@abeyuya-skills --scope user </dev/null \
    || echo "[setup] WARN: pr-review plugin update failed" >&2
else
  echo "[setup] WARN: claude CLI not found; skip pr-review plugin install" >&2
fi

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
