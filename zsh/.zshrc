function loadlib() {
  lib=${1:?"You have to specify a library file"}
  if [ -f "$lib" ];then # ファイルの存在を確認
      . "$lib"
  fi
}

# マシン固有の設定を読み込む
loadlib $HOME/.local.zsh

##########
# for zsh
##########

# color
export CLICOLOR=1
export LSCOLORS=gxfxcxdxbxegedabagacad


# zsh補完
autoload -U compinit; compinit                      # 補完機能を有効にする
setopt auto_list                                    # 補完候補を一覧で表示する(d)
setopt auto_menu                                    # 補完キー連打で補完候補を順に表示する(d)
setopt list_packed                                  # 補完候補をできるだけ詰めて表示する
setopt list_types                                   # 補完候補にファイルの種類も表示する
bindkey "^[[Z" reverse-menu-complete                # Shift-Tabで補完候補を逆順する("\e[Z"でも動作する)
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}' # 補完時に大文字小文字を区別しない


#プロンプト
autoload colors
colors

# ブランチ表示
autoload -Uz vcs_info
zstyle ':vcs_info:*' formats '[%b]'
zstyle ':vcs_info:*' actionformats '[%b|%a]'
precmd () {
    psvar=()
    LANG=en_US.UTF-8 vcs_info
    [[ -n "$vcs_info_msg_0_" ]] && psvar[1]="$vcs_info_msg_0_"
}

PROMPT="
%{${fg[yellow]}%}%~%{${reset_color}%} %1(v|%F{green}%1v%f|)
[%T %n]$ "

# direnv
eval "$(direnv hook zsh)"
export EDITOR="vim"

# screenと競合しないように
bindkey -e

### alias
alias ll="ls -la"
alias sc="/usr/bin/screen"
alias rubyhttpd="ruby -run -e httpd . -p 3000"

[[ "$TERM_PROGRAM" == "vscode" ]] && . "$(code --locate-shell-integration-path zsh)"

