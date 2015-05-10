" .gvimrc Myjumpto functions


""""""""""""""""""""""""""""""
"sepが空でなければ、sepをセパレータとしてジャンプ。
"見つからなければ見かけの行頭へ。
"カーソル位置が見かけの行頭の場合は真の行頭へ。
""""""""""""""""""""""""""""""
function! MyJumptoBol(sep)
    if col('.') == 1
        call cursor(line('.')-1, col('$'))
        call cursor(line('.'), col('$'))
        return ''
    endif
    if matchend(strpart(getline('.'), 0, col('.')), '[[:blank:]]\+') >= col('.')-1
        silent exec 'normal! 0'
        return ''
    endif
    if a:sep != ''
        call search('[^'.a:sep.']\+', 'bW', line("."))
        if col('.') == 1
            silent exec 'normal! ^'
        endif
        return ''
    endif
    exec 'normal! ^'
    return ''
endfunction

""""""""""""""""""""""""""""""
"sepが空でなければ、sepをセパレータとしてジャンプ。
"見つからなければ行末へ。
""""""""""""""""""""""""""""""
function! MyJumptoEol(sep)
    if col('.') == col('$')
        silent exec 'normal! w'
        return ''
    endif

    if a:sep != ''
        let prevcol = col('.')
        call search('['.a:sep.']\+[^'.a:sep.']', 'eW', line("."))
        if col('.') != prevcol
            return ''
        endif
    endif
    call cursor(line('.'), col('$'))
    return ''
endfunction

""""""""""""""""""""""""""""""
"行末でも停止する単語単位移動コマンド
""""""""""""""""""""""""""""""
function! MyMoveWord_i(cmd)
    let isEol = 0
    if col('$') == col('.')
        let isEol = 1
    endif
    let prevline = line('.')
    silent exec 'normal! '.a:cmd
    if line('.') == prevline
        return ''
    endif
    if a:cmd == 'w'
        if isEol == 0
            call cursor(prevline, 0)
            call cursor(line('.'), col('$'))
        endif
        if line('.') - prevline > 1
            call cursor(prevline+1, 0)
            call cursor(line('.'), col('$'))
        endif
    elseif a:cmd == 'b'
        call cursor(line('.'), col('$'))
        if prevline - line('.') > 1
            call cursor(prevline-1, 0)
            call cursor(line('.'), col('$'))
        endif
    endif
    return ''
endfunction
