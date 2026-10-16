# About

個人的な設定ファイルです

# 環境構築

各設定ファイルへシンボリックリンクを貼ります

```
ln -s ./Documents/dev/dotfile/gem/.gemrc .gemrc
ln -s ./Documents/dev/dotfile/git/.gitconfig .gitconfig
ln -s ./Documents/dev/dotfile/git/.gitignore .gitignore
ln -s ./Documents/dev/dotfile/screen/.screenrc .screenrc
ln -s ./Documents/dev/dotfile/vim/.vimrc .vimrc
ln -s ./Documents/dev/dotfile/zsh/.zshrc .zshrc
```

## Claude Code

`claude/CLAUDE.md` がローカルとクラウドセッションで共通の指示です。

- ローカル: `~/.claude/CLAUDE.md` の先頭に次の 1 行を書いて読み込みます。ローカルだけの指示はその下に書きます
  ```
  @~/Documents/dev/dotfile/claude/CLAUDE.md
  ```
- クラウドセッション: 起動時に `claude/setup.sh` が master の `claude/CLAUDE.md` を取得して `~/.claude/CLAUDE.md` に追記します
