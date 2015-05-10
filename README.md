# About

個人的な設定ファイルです

# 環境構築

各設定ファイルへシンボリックリンクを貼るだけです

```
.gemrc -> ./Documents/dev/dotfile/gem/.gemrc
.gitconfig -> ./Documents/dev/dotfile/git/.gitconfig
.gitignore -> ./Documents/dev/dotfile/git/.gitignore
.screenrc -> ./Documents/dev/dotfile/screen/.screenrc
.vimrc -> ./Documents/dev/dotfile/vim/.vimrc
.zshrc -> ./Documents/dev/dotfile/zsh/.zshrc
.zshrc_homedir -> ./Documents/dev/dotfile/zsh/zshrc_homedir
```

上記のような感じで各ファイルへシンボリックリンクを貼る
```
例) ln -s ./Documents/dev/dotfile/vim/.vimrc .vimrc
```


## zsh

zshは環境切り分け用に特殊な設定をする必要があります
(自宅・会社とかを切り分けるため)

1. {repo_root_dir}/zsh/zshrc_homedirを作る

  ```
  ZSHHOME="${HOME}/Documents/dev/dotfile/zsh"
  ```

1. $HOMEにzshrc_homedirへのシンボリックリンクを貼る

  ```
  ln -s ./Documents/dev/dotfile/zsh/zshrc_homedir ~/.zshrc_homedir
  ```

1. {repo_root_dir}/zsh/path.zshを作る

  ```
  cp zsh/path.zsh.sample zsh/path.zsh
  ```
