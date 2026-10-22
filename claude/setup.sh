# クラウドセッションの起動時に実行する (ローカルでは実行しない。手順は README の「Claude Code」を参照)

# 1) ~/.claude/CLAUDE.md に claude/user-CLAUDE.md の内容を追記
#    - curl | bash で実行されるため、本文はリポジトリの master から取得する
#      (別ブランチの本文を試すときは CLAUDE_MD_URL を上書きする)
#    - 3 回まで取得を試し、それでも失敗したらセッションの起動を止めないよう WARN だけ出して続ける
#      (curl の --retry は DNS 失敗や接続拒否を再試行しないため、ループで再試行する)
#    - 途中までの内容を書き込まないよう、取得が成功してから追記する
CLAUDE_MD="$HOME/.claude/CLAUDE.md"
CLAUDE_MD_URL="${CLAUDE_MD_URL:-https://raw.githubusercontent.com/abeyuya/dotfile/master/claude/user-CLAUDE.md}"
mkdir -p "$(dirname "$CLAUDE_MD")"
touch "$CLAUDE_MD"
claude_md_fetched=
for _ in 1 2 3; do
  if claude_md_body=$(curl -fsSL --max-time 20 "$CLAUDE_MD_URL"); then
    claude_md_fetched=1
    break
  fi
  sleep 2
done
if [ -n "$claude_md_fetched" ]; then
  printf '\n%s\n' "$claude_md_body" >> "$CLAUDE_MD"
else
  echo "[setup] WARN: failed to fetch $CLAUDE_MD_URL" >&2
fi

# 2) abeyuya/skills の plugin を user scope にインストール
#    - pr-review: CLAUDE.md の delegate-pr-review 用
#    - pr-create: PR 作成時の pr-template / pr-screenshots / pr-diagrams 用
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
  for plugin in pr-review pr-create; do
    run_with_timeout claude plugin install "$plugin" --marketplace abeyuya/skills --scope user </dev/null \
      || echo "[setup] WARN: $plugin plugin install failed" >&2
    run_with_timeout claude plugin update "$plugin@abeyuya-skills" --scope user </dev/null \
      || echo "[setup] WARN: $plugin plugin update failed" >&2
  done
else
  echo "[setup] WARN: claude CLI not found; skip abeyuya/skills plugin install" >&2
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
