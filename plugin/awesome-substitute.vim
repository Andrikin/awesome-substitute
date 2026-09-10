" substitute.vim - %s///g automatic cmdline fill
" Autor: André Alexandre Aguiar
" Version: 0.1
" Dependences: traces.vim

if exists("g:loaded_awesome_substitute")
  finish
endif
let g:loaded_awesome_substitute = 1

let s:save_cpo = &cpo
set cpo&vim

" Stealing idea from Tim Pope
function! s:startthething(setup, ...) abort
    let word = expand('<cword>')
	if !a:0 && a:setup ==# 'run'
        let fn = matchstr(matchstr(expand('<stack>'), '[^. ]*$'), '[^\[\]]*')
        let &operatorfunc = function(fn, [word])
		return 'g@'
    endif
    if !a:0 && a:setup ==# 'visual'
        let op = a:setup
    else
        let word = a:setup
        let op = a:1
    endif
    let cmd = ''
	if op == 'line'
		let cmd = ":'[,']s:\\v<" . word . ">\\C::g\<left>\<left>"
	elseif op == 'char'
		let cmd = ":%s:\\v<" . word . ">\\C::g\<left>\<left>"
    elseif op == 'visual'
        let cmd = ":\<c-u>'<,'>s:\\v<" . word . ">\\C::g\<left>\<left>"
	endif
	call feedkeys(cmd, 'n')
endfunction

nnoremap <expr> <plug>(AwesomeSubstitute) <SID>startthething('run')
xnoremap <expr> <plug>(XAwesomeSubstitute) <SID>startthething('visual')

if !hasmapto('<plug>(AwesomeSubstitute)')
	nmap gs <plug>(AwesomeSubstitute)
	xmap gs <plug>(XAwesomeSubstitute)
	" In the line
	nnoremap gss :.s:\<<c-r><c-w>\>\C::g<left><left>
endif

let &cpo = s:save_cpo
unlet s:save_cpo

" I can call functions that returns no value, but can do something
" xnoremap <expr> <plug>(AwesomeSubstitute) ":\<c-u>" 
" . (<SID>get_word()) 
" . (<SID>spreadtheword()) 
" . "\<c-r>=<SID>set_cur_pos()\<cr>"
