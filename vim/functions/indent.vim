
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
au BufNewFile,BufRead *.rb   set tabstop=2 shiftwidth=2
au BufNewFile,BufRead .vimrc set tabstop=2 shiftwidth=2
au BufNewFile,BufRead *.vim  set tabstop=2 shiftwidth=2


augroup vagrant
  au!
  au BufRead,BufNewFile Vagrantfile set filetype=ruby
  au BufNewFile,BufRead Vagrantfile set tabstop=2 shiftwidth=2
augroup END

augroup ridgepole
  au!
  au BufRead,BufNewFile Schemefile set filetype=ruby
  au BufNewFile,BufRead Schemefile set tabstop=2 shiftwidth=2
augroup END

augroup gemfile
  au!
  au BufRead,BufNewFile Gemfile set filetype=ruby
  au BufNewFile,BufRead Gemfile set tabstop=2 shiftwidth=2
augroup END

augroup markdown
  au!
  au BufRead,BufNewFile *.md set filetype=markdown
  au BufNewFile,BufRead *.md set tabstop=2 shiftwidth=2
augroup END

augroup thor
  au!
  au BufRead,BufNewFile *.thor set filetype=ruby
  au BufNewFile,BufRead *.thor set tabstop=2 shiftwidth=2
augroup END

augroup terraform
  au!
  au BufRead,BufNewFile *.tf set filetype=ruby
  au BufNewFile,BufRead *.tf set tabstop=2 shiftwidth=2
augroup END
