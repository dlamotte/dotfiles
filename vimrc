execute pathogen#infect()

" gentoo vimrc

scriptencoding utf-8
" ^^ Please leave the above line at the start of the file.

" Default configuration file for Vim
" $Header: /var/cvsroot/gentoo-x86/app-editors/vim-core/files/vimrc-r4,v 1.2 2010/03/09 18:47:21 lack Exp $

" Written by Aron Griffis <agriffis@gentoo.org>
" Modified by Ryan Phillips <rphillips@gentoo.org>
" Modified some more by Ciaran McCreesh <ciaranm@gentoo.org>
" Added Redhat's vimrc info by Seemant Kulleen <seemant@gentoo.org>

" You can override any of these settings on a global basis via the
" "/etc/vim/vimrc.local" file, and on a per-user basis via "~/.vimrc". You may
" need to create these.

" {{{ General settings
" The following are some sensible defaults for Vim for most users.
" We attempt to change as little as possible from Vim's defaults,
" deviating only where it makes sense
set nocompatible        " Use Vim defaults (much better!)
set bs=2                " Allow backspacing over everything in insert mode
set ai                  " Always set auto-indenting on
set history=50          " keep 50 lines of command history
set ruler               " Show the cursor position all the time

set viminfo='20,\"500   " Keep a .viminfo file.

" Don't use Ex mode, use Q for formatting
map Q gq

" When doing tab completion, give the following files lower priority. You may
" wish to set 'wildignore' to completely ignore files, and 'wildmenu' to enable
" enhanced tab completion. These can be done in the user vimrc file.
set suffixes+=.info,.aux,.log,.dvi,.bbl,.out,.o,.lo

" When displaying line numbers, don't use an annoyingly wide number column. This
" doesn't enable line numbers -- :set number will do that. The value given is a
" minimum width to use for the number column, not a fixed size.
if v:version >= 700
  set numberwidth=3
endif
" }}}

" {{{ Modeline settings
" We don't allow modelines by default. See bug #14088 and bug #73715.
" If you're not concerned about these, you can enable them on a per-user
" basis by adding "set modeline" to your ~/.vimrc file.
set nomodeline
" }}}

" {{{ Locale settings
" Try to come up with some nice sane GUI fonts. Also try to set a sensible
" value for fileencodings based upon locale. These can all be overridden in
" the user vimrc file.
if v:lang =~? "^ko"
  set fileencodings=euc-kr
  set guifontset=-*-*-medium-r-normal--16-*-*-*-*-*-*-*
elseif v:lang =~? "^ja_JP"
  set fileencodings=euc-jp
  set guifontset=-misc-fixed-medium-r-normal--14-*-*-*-*-*-*-*
elseif v:lang =~? "^zh_TW"
  set fileencodings=big5
  set guifontset=-sony-fixed-medium-r-normal--16-150-75-75-c-80-iso8859-1,-taipei-fixed-medium-r-normal--16-150-75-75-c-160-big5-0
elseif v:lang =~? "^zh_CN"
  set fileencodings=gb2312
  set guifontset=*-r-*
endif

" If we have a BOM, always honour that rather than trying to guess.
if &fileencodings !~? "ucs-bom"
  set fileencodings^=ucs-bom
endif

" Always check for UTF-8 when trying to determine encodings.
if &fileencodings !~? "utf-8"
  " If we have to add this, the default encoding is not Unicode.
  " We use this fact later to revert to the default encoding in plaintext/empty
  " files.
  let g:added_fenc_utf8 = 1
  set fileencodings+=utf-8
endif

" Make sure we have a sane fallback for encoding detection
if &fileencodings !~? "default"
  set fileencodings+=default
endif
" }}}

" {{{ Syntax highlighting settings
" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif
" }}}

" {{{ Terminal fixes
if &term ==? "xterm"
  set t_Sb=^[4%dm
  set t_Sf=^[3%dm
  set ttymouse=xterm2
endif

if &term ==? "gnome" && has("eval")
  " Set useful keys that vim doesn't discover via termcap but are in the
  " builtin xterm termcap. See bug #122562. We use exec to avoid having to
  " include raw escapes in the file.
  exec "set <C-Left>=\eO5D"
  exec "set <C-Right>=\eO5C"
endif
" }}}

" {{{ Filetype plugin settings
" Enable plugin-provided filetype settings, but only if the ftplugin
" directory exists (which it won't on livecds, for example).
if isdirectory(expand("$VIMRUNTIME/ftplugin"))
  filetype plugin on

  " Uncomment the next line (or copy to your ~/.vimrc) for plugin-provided
  " indent settings. Some people don't like these, so we won't turn them on by
  " default.
  " filetype indent on
endif
" }}}

" {{{ Our default /bin/sh is bash, not ksh, so syntax highlighting for .sh
" files should default to bash. See :help sh-syntax and bug #101819.
if has("eval")
  let is_bash=1
endif
" }}}

" {{{ Autocommands
if has("autocmd")

augroup gentoo
  au!

  " Gentoo-specific settings for ebuilds.  These are the federally-mandated
  " required tab settings.  See the following for more information:
  " http://www.gentoo.org/proj/en/devrel/handbook/handbook.xml
  " Note that the rules below are very minimal and don't cover everything.
  " Better to emerge app-vim/gentoo-syntax, which provides full syntax,
  " filetype and indent settings for all things Gentoo.
  au BufRead,BufNewFile *.e{build,class} let is_bash=1|setfiletype sh
  au BufRead,BufNewFile *.e{build,class} set ts=4 sw=4 noexpandtab

  " When editing a file, always jump to the last cursor position
  autocmd BufReadPost *
        \ if ! exists("g:leave_my_cursor_position_alone") |
        \     if line("'\"") > 0 && line ("'\"") <= line("$") |
        \         exe "normal g'\"" |
        \     endif |
        \ endif

  " When editing a crontab file, set backupcopy to yes rather than auto. See
  " :help crontab and bug #53437.
  autocmd FileType crontab set backupcopy=yes

  " If we previously detected that the default encoding is not UTF-8
  " (g:added_fenc_utf8), assume that a file with only ASCII characters (or no
  " characters at all) isn't a Unicode file, but is in the default encoding.
  " Except of course if a byte-order mark is in effect.
  autocmd BufReadPost *
        \ if exists("g:added_fenc_utf8") && &fileencoding == "utf-8" && 
        \    ! &bomb && search('[\x80-\xFF]','nw') == 0 && &modifiable |
        \       set fileencoding= |
        \ endif

augroup END

endif " has("autocmd")
" }}}
" vim: set fenc=utf-8 tw=80 sw=2 sts=2 et foldmethod=marker :
" end gentoo vimrc defaults


syntax on

" disable connecting to X11 (hangs on putty/ssh session)
set clipboard=exclude:.*

" force term due to inkpot 256 colors
set term=xterm-256color

" set the title of the terminal
set title

" highlight >--- with a better color from inkpot, X(82) vs inkpots X(55)
au BufEnter * hi SpecialKey cterm=BOLD ctermfg=238 ctermbg=NONE

" make sure our tabs are 4
set tabstop=4
set shiftwidth=4
set softtabstop=4
set colorcolumn=80

set scrolloff=3
set ttyfast

" unhighlight
nnoremap <leader><space> :noh<cr>

" yankring
nnoremap <silent> <F3> :YRShow<cr>
inoremap <silent> <F3> <ESC>:YRShow<cr>

" sparkup
let g:sparkupExecuteMapping = '<Leader>n'
let g:sparkupNextMapping = '<Leader>n'

" ft specifics
au BufRead,BufNewFile *.as setlocal ft=actionscript
au BufRead,BufNewFile *.css setlocal ts=2 sw=2 sts=2
au BufRead,BufNewFile *.haml setlocal ts=2 sw=2 sts=2
au BufRead,BufNewFile *.html setlocal ts=2 sw=2 sts=2
au BufRead,BufNewFile *.jinja setlocal ft=htmljinja ts=2 sw=2 sts=2
au BufRead,BufNewFile *.js setlocal ts=2 sw=2 sts=2
au BufRead,BufNewFile *.jst setlocal ft=jst ts=2 sw=2 sts=2
au BufRead,BufNewFile *.less setlocal ft=less ts=2 sw=2 sts=2
au BufRead,BufNewFile *.md setlocal ft=markdown
au BufRead,BufNewFile *.rb setlocal ts=2 sw=2 sts=2
au BufRead,BufNewFile *.tst setlocal syntax=perl
au BufRead,BufNewFile *.txt setlocal printoptions+=number:n
au BufRead,BufNewFile *.scss setlocal ft=scss ts=2 sw=2 sts=2
au BufRead,BufNewFile Build* setlocal noexpandtab filetype=make syntax=make
au BufRead,BufNewFile hg-editor-*.txt setlocal syntax=hgcommit
au BufRead,BufNewFile [Mm]ake* setlocal noexpandtab filetype=make syntax=make
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

" fancy status line (now using vim-airline)
"set statusline=
"set statusline+=%2*%-3.3n%0*                    " buffer number
"set statusline+=%f                              " file name
"set statusline+=%h%1*%m%r%w%0*                  " flags
"set statusline+=[%{strlen(&ft)?&ft:'none'},     " filetype
"set statusline+=%{&encoding},                   " encoding
"set statusline+=%{&fileformat}]                 " file format
"set statusline+=%{Scm_status()}                 " scm status
"set statusline+=%=                              " right align
"set statusline+=%2*0x%-8B                       " current char
"set statusline+=%-14.(%l,%c%V%)                 " offset
"set statusline+=%P                              " percent through file
let g:airline_detect_modified = 1
let g:airline_detect_paste = 1
let g:airline_theme = 'badwolf'
"let g:airline_theme='laederon'
"let g:airline_theme='simple' " not very good during splits
let g:airline_mode_map = {
      \ 'n'  : 'normal',
      \ 'i'  : 'insert',
      \ 'R'  : 'rplace',
      \ 'v'  : 'visual',
      \ 'V'  : 'v-line',
      \ 'c'  : 'cmd   ',
      \ '' : 'v-blck',
      \ }
let g:airline_left_sep = '▶'
let g:airline_right_sep = '◀'
let g:airline_linecolumn_prefix = '¶ '
let g:airline_branch_prefix = '⎇ '
let g:airline_paste_symbol = 'ρ'
let g:ctrlp_working_path_mode = 'ra'

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
