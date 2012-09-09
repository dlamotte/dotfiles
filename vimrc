" if we have a local file to read, we need to read that first for machine
" specifics
if filereadable(expand("$HOME/.vimrc.local"))
    source $HOME/.vimrc.local
endif

" force term due to inkpot 256 colors
set term=xterm-256color

" highlight >--- with a better color from inkpot, X(82) vs inkpots X(55)
au BufEnter * hi SpecialKey cterm=BOLD ctermfg=238 ctermbg=NONE

" make sure our tabs are 4
set tabstop=4
set shiftwidth=4
set softtabstop=4
set textwidth=79

" ft specifics
au BufRead,BufNewFile *.css setlocal tw=0 ts=2 sw=2 sts=2
au BufRead,BufNewFile *.haml setlocal tw=0 ts=2 sw=2 sts=2
au BufRead,BufNewFile *.html setlocal tw=0 ts=2 sw=2 sts=2
au BufRead,BufNewFile *.js setlocal tw=0 ts=2 sw=2 sts=2
au BufRead,BufNewFile *.less setlocal ft=less ts=2 sw=2 sts=2
au BufRead,BufNewFile *.md setlocal ft=markdown
au BufRead,BufNewFile *.rb setlocal ts=2 sw=2 sts=2
au BufRead,BufNewFile *.scss setlocal tw=0 ts=2 sw=2 sts=2
au BufRead,BufNewFile Rakefile setlocal ts=2 sw=2 sts=2

" make sure indents are correct
set autoindent
set smartindent

" remove actual tabs but make it 'feel' like tabs
set smarttab
set expandtab

set ignorecase

" search cscope and tags files
set cscopetag

" dont wrap really long lines
set nowrap

" I save enough that I have never really needed this and its become annoying
" on nfs and slow filesystems (sshfs)
set noswapfile

" show the contents of the cmd buffer
set showcmd

" don't outdent comment lines when they are smartindented help smartindent
inoremap # X#

" select last thing pasted via :set paste (inspired by gv)
noremap <Leader>v `[v`]

" start taglist plugin with ctags
nnoremap <silent> <F8> :Tlist<CR>
"let Tlist_Auto_Open = 1
let Tlist_Compact_Format = 1
let Tlist_Exit_OnlyWindow = 1

set printoptions=number:y,paper:letter,syntax:n
au BufEnter *.txt set printoptions+=number:n
au BufRead,BufNewFile hg-editor-*.txt set syntax=hgcommit tw=0
au BufRead,BufNewFile *.as set filetype=actionscript
au BufRead,BufNewFile *.scss set filetype=scss

" make :Man command available
source $VIMRUNTIME/ftplugin/man.vim

" default MANPAGER vimmanpager doesn't play well
" with the :Man command and we don't want to see raw colour codes
" so we use sed to strip them.
let $MANPAGER = "sed -e 's:\\x1B\\[[[:digit:]]\\+m::g'"

" awesome colorscheme by ciaranm
colorscheme inkpot

" TODO: try using marker to remember folds, not mkview/loadview
" remember and load folds
"au BufWrite * mkview

"if bufname("%") " only if current buffer exists
"    au BufRead * loadview
"endif
set foldenable
set foldmethod=marker

fun! <SID>window_width()
    if ! &diff
        if winwidth(0) > 80
            setlocal foldcolumn=2
        else
            setlocal foldcolumn=0
        endif
    endif
endfun

au BufEnter,VimResized * :call <SID>window_width()

" nice status bar
set laststatus=2

" q: is annoying
nmap q: :q

fun! Find_scm_root(path,dir)
    let l:path = a:path
    let l:lastpath = ""
    while strlen(l:path) > 0 && l:path != l:lastpath &&
        \ ! isdirectory(l:path."/".a:dir )
        let l:lastpath = l:path
        let l:path = fnamemodify(l:path,":h")
    endwhile
    return l:path
endfun

fun! Scm_status()
    let l:path = expand("%:p")
    let l:type = ""
    let l:branch = ""

    let l:hgpath = Find_scm_root(l:path,".hg")
    let l:gitpath = Find_scm_root(l:path,".git")
    " found hg repo
    if strlen(l:hgpath) > 1
        let l:type = "hg"
        " get branch
        try
            let l:branch = readfile(l:hgpath."/.hg/branch", "", 1)[0]
        catch /E484/
            let l:branch = "default"
        endtry
    elseif strlen(l:gitpath) > 1
        let l:gitpath .= "/.git"
        let l:type = "git"
        " get branch
        try
            let l:branch = substitute(readfile(l:gitpath."/HEAD", "", 1)[0],
                        \ "^.*/", "", "")
        catch /E484/
        endtry
    endif

    if strlen(l:type) > 0
        return printf("[%s: %s]", l:type, l:branch)
    endif

    return ""
endfun

" fancy status line
set statusline=
set statusline+=%2*%-3.3n%0*                    " buffer number
set statusline+=%f                              " file name
set statusline+=%h%1*%m%r%w%0*                  " flags
set statusline+=[%{strlen(&ft)?&ft:'none'},     " filetype
set statusline+=%{&encoding},                   " encoding
set statusline+=%{&fileformat}]                 " file format
set statusline+=%{Scm_status()}                 " scm status
set statusline+=%=                              " right align
set statusline+=%2*0x%-8B                       " current char
set statusline+=%-14.(%l,%c%V%)                 " offset
set statusline+=%P                              " percent through file

" information on wrapping lines
set listchars=
set listchars=extends:$,precedes:$,tab:>-,trail:.
set list

" fancier editing of binaries
augroup Binary
    au!
    au BufReadPre  *.bin let &bin=1
    au BufReadPost *.bin if &bin | silent %!xxd
    au BufReadPost *.bin set ft=xxd | endif
    au BufWritePre *.bin if &bin | silent %!xxd -r
    au BufWritePre *.bin endif
    au BufWritePost *.bin if &bin | silent %!xxd
    au BufWritePost *.bin set nomod | endif
augroup END

:python << EOF
import os
virtualenv = os.environ.get('VIRTUAL_ENV')
if virtualenv:
    activate_this = os.path.join(virtualenv, 'bin', 'activate_this.py')
    if os.path.exists(activate_this):
        execfile(activate_this, dict(__file__=activate_this))
EOF
