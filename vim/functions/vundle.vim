"
" Using Vundle
"

set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=./bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'

" original repos on github
"Plugin 'h1mesuke/vim-alignta'
Plugin 'tsaleh/vim-align'
Plugin 'pangloss/vim-javascript'
"Plugin 'briancollins/vim-jst'
"Plugin 'vim-scripts/VimRepress'
"Plugin 'joonty/vdebug'
"Plugin 'tpope/vim-fugitive'
"Plugin 'Lokaltog/vim-easymotion'
"Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}
"Plugin 'tpope/vim-rails.git'
"Plugin 'chase/vim-ansible-yaml'
"Plugin '2072/PHP-Indenting-for-VIm'

" vim-scripts repos
Plugin 'neocomplcache'
Plugin 'html5.vim'
Plugin 'The-NERD-tree'
"Plugin 'css_color.vim'
"Plugin 'Markdown'
"Plugin 'slim-template/vim-slim'
"Plugin 'L9'
"Plugin 'FuzzyFinder'
Plugin 'rails.vim'
"Plugin 'The-NERD-Commenter'
"Plugin 'quickrun.vim'
"
" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required

