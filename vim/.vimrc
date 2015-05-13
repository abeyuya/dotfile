" Include only


if filereadable(expand("~/Documents/dev/dotfile/vim/functions/config.vim"))
  source ~/Documents/dev/dotfile/vim/functions/config.vim
endif


"""Myjumpto function
" if filereadable(expand("./Documents/dev/dotfile/vim/functions/in_Myjumpto.vim"))
"   source ./Documents/dev/dotfile/vim/functions/in_Myjumpto.vim
" endif


if filereadable(expand("~/Documents/dev/dotfile/vim/functions/indent.vim"))
  source ~/Documents/dev/dotfile/vim/functions/indent.vim
endif


if filereadable(expand('~/Documents/dev/dotfile/vim/functions/savefile.vim'))
  source ~/Documents/dev/dotfile/vim/functions/savefile.vim
endif


if filereadable(expand('~/Documents/dev/dotfile/vim/functions/vundle.vim'))
  source ~/Documents/dev/dotfile/vim/functions/vundle.vim
endif


if filereadable(expand('~/Documents/dev/dotfile/vim/functions/neocomplcache.vim'))
  source ~/Documents/dev/dotfile/vim/functions/neocomplcache.vim
endif


""""""""""""""""""""
" vim-javascript
""""""""""""""""""""

let g:html_indent_inctags = "html,body,head,tbody"
let g:html_indent_script1 = "inc"
let g:html_indent_style1  = "inc"

