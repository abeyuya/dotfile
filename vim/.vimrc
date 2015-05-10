" Include only


if filereadable(expand("./functions/config.vim"))
  source ./functions/config.vim
endif


"""Myjumpto function
" if filereadable(expand("./functions/in_Myjumpto.vim"))
"   source ./functions/in_Myjumpto.vim
" endif


if filereadable(expand("./functions/indent.vim"))
  source ./functions/indent.vim
endif


if filereadable(expand('./functions/savefile.vim'))
  source ./functions/savefile.vim
endif


if filereadable(expand('./functions/vundle.vim'))
  source ./functions/vundle.vim
endif


if filereadable(expand('./functions/neocomplcache.vim'))
  source ./functions/neocomplcache.vim
endif


""""""""""""""""""""
" vim-javascript
""""""""""""""""""""

let g:html_indent_inctags = "html,body,head,tbody"
let g:html_indent_script1 = "inc"
let g:html_indent_style1  = "inc"

