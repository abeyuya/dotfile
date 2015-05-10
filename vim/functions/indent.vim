
"日本語入力をリセット
au BufNewFile,BufRead * set iminsert=0
"タブ幅をリセット
au BufNewFile,BufRead * set tabstop=4 shiftwidth=4

" 特定ファイルでのタブ幅 
au BufNewFile,BufRead *.html set tabstop=2 shiftwidth=2
au BufNewFile,BufRead *.erb  set tabstop=2 shiftwidth=2
au BufNewFile,BufRead *.sh   set tabstop=2 shiftwidth=2
au BufNewFile,BufRead *.json set tabstop=2 shiftwidth=2
au BufNewFile,BufRead *.js   set tabstop=2 shiftwidth=2
au BufNewFile,BufRead *.php  set tabstop=2 shiftwidth=2
au BufNewFile,BufRead *.css  set tabstop=2 shiftwidth=2
au BufNewFile,BufRead *.scss set tabstop=2 shiftwidth=2

