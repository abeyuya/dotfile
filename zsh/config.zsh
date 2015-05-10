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

# 現在地表示
autoload colors
colors
PROMPT="%{${fg[yellow]}%}% [~] %{${reset_color}%} $ "

#プロンプト
autoload colors
colors

PROMPT="
 %{${fg[yellow]}%}%~%{${reset_color}%} 
[%n]$ "

# ブランチ表示
autoload -Uz vcs_info
zstyle ':vcs_info:*' formats '[%b]'
zstyle ':vcs_info:*' actionformats '[%b|%a]'
precmd () {
    psvar=()
    LANG=en_US.UTF-8 vcs_info
    [[ -n "$vcs_info_msg_0_" ]] && psvar[1]="$vcs_info_msg_0_"
}
RPROMPT="%1(v|%F{green}%1v%f|)"


