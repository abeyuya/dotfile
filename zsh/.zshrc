# zshディレクトリのパスをhomedirファイルで指定
function loadlib() {
  lib=${1:?"You have to specify a library file"}
  if [ -f "$lib" ];then # ファイルの存在を確認
      . "$lib"
  fi
}
loadlib $HOME/.zshrc_homedir

# zshディレクトリの *.zsh ファイルをすべて読み込む
if [ -d $ZSHHOME -a -r $ZSHHOME -a -x $ZSHHOME ]; then
  for i in $ZSHHOME/*; do
    [[ ${i##*/} = *.zsh ]] && [ \( -f $i -o -h $i \) -a -r $i ] && . $i
  done
fi

# tabtab source for serverless package
# uninstall by removing these lines or running `tabtab uninstall serverless`
[[ -f /Users/abeyuya/.nodebrew/node/v6.10.2/lib/node_modules/serverless/node_modules/tabtab/.completions/serverless.zsh ]] && . /Users/abeyuya/.nodebrew/node/v6.10.2/lib/node_modules/serverless/node_modules/tabtab/.completions/serverless.zsh
# tabtab source for sls package
# uninstall by removing these lines or running `tabtab uninstall sls`
[[ -f /Users/abeyuya/.nodebrew/node/v6.10.2/lib/node_modules/serverless/node_modules/tabtab/.completions/sls.zsh ]] && . /Users/abeyuya/.nodebrew/node/v6.10.2/lib/node_modules/serverless/node_modules/tabtab/.completions/sls.zsh