""""""""""""""""""""""""""""""""""""""""""""""
" 挿入モード
""""""""""""""""""""""""""""""""""""""""""""""

"カッコ入力時にカーソルを真ん中に
inoremap {} {}<Left>
inoremap [] []<Left>
inoremap () ()<Left>
inoremap "" ""<Left>
inoremap '' ''<Left>
inoremap `` ``<Left>
inoremap <> <><Left>
inoremap ?? ??<Left>
inoremap %% %%<Left>


""""""""""""""""""""
" View
""""""""""""""""""""

set number

syntax on
set t_Co=256
colorscheme desert

set ruler		" show the cursor position all the time
set scrolloff=5

" 入力されているテキストの最大幅 「0」で無効
set textwidth=0

"閉じ括弧が入力されたとき、対応する括弧を表示する
set showmatch

"現在行のhighlight
set cursorline
augroup cch
  autocmd! cch
  autocmd WinLeave * set nocursorline
  autocmd WinEnter,BufRead * set cursorline
augroup END

hi clear CursorLine
hi CursorLine gui=underline
highlight CursorLine ctermbg=233 guibg=black


""""""""""""""""""""
" Input
""""""""""""""""""""

" タブの代わりに空白文字を挿入する
set modeline
set expandtab

" always set autoindenting on
set ai

"新しい行を作ったときに高度な自動インデントを行う
set smartindent

""""""""""""""""""""
" Move
""""""""""""""""""""

set whichwrap=b,s,h,l,<,>,[,],~

"インクリメンタルサーチを行う
set incsearch

"検索時に大文字を含んでいたら大/小を区別
set smartcase

"タブ移動
nnoremap <S-Tab>   gt
nnoremap <Tab><Tab> gT

"ノーマルモード時の矢印キーの挙動修正
nnoremap OA <Up>
nnoremap OB <Down>
nnoremap OC <Right>
nnoremap OD <Left>


""""""""""""""""""""
" System
""""""""""""""""""""

"tab bashライクタブ保管
set wildmode=list:longest
"listで表示される文字のフォーマットを指定する
set listchars=eol:$,tab:>\ ,extends:<

set nocompatible	" Use Vim defaults (much better!)

" タグジャンプ
nnoremap <C-h> :pop<CR>


"日本語入力をリセット
au BufNewFile,BufRead * set iminsert=0
"タブ幅をリセット
au BufNewFile,BufRead * set tabstop=4 shiftwidth=4


"""""""""""""""""""
" newcomplcache
"""""""""""""""""""

" Disable AutoComplPop.
let g:acp_enableAtStartup                        = 0
" Use neocomplcache.
let g:neocomplcache_enable_at_startup            = 1
" Use smartcase.
let g:neocomplcache_enable_smart_case            = 1
" Use camel case completion.
let g:neocomplcache_enable_camel_case_completion = 1
" Use underbar completion.
let g:neocomplcache_enable_underbar_completion   = 1
" Set minimum syntax keyword length.
let g:neocomplcache_min_syntax_length            = 3
let g:neocomplcache_lock_buffer_name_pattern     = '\*ku\*'


""""""""""""""""""""
" Save file
""""""""""""""""""""

"バックアップファイルを作らない
set nobackup
" "swapfile使わない
set noswapfile
