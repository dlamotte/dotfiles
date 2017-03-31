" pathogen setup vimruntime path
"execute pathogen#infect()

" vim-plug
call plug#begin('~/.vim/plugged')
Plug 'JulesWang/css.vim'
Plug 'airblade/vim-gitgutter'
Plug 'altercation/vim-colors-solarized'
Plug 'ap/vim-css-color'
Plug 'bling/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'briancollins/vim-jst'
Plug 'ekalinin/Dockerfile.vim'
Plug 'fatih/vim-go'
Plug 'groenewege/vim-less'
Plug 'hashivim/vim-terraform'
Plug 'kien/ctrlp.vim'
Plug 'majutsushi/tagbar'
Plug 'mitsuhiko/vim-jinja'
Plug 'mitsuhiko/vim-python-combined'
Plug 'nazo/pt.vim'
Plug 'othree/html5.vim'
Plug 'pangloss/vim-javascript'
Plug 'pearofducks/ansible-vim'
Plug 'sjl/splice.vim'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
call plug#end()

filetype plugin on
syntax on
scriptencoding utf-8

"
" options
"

" os/terminal
if !has('nvim')
    set clipboard=exclude:.*  " disable connecting to X11 (hangs on putty/ssh session)
endif
set noswapfile
set printoptions=number:y,paper:letter,syntax:n
if !has('nvim')
    set term=xterm-256color  " force term due to inkpot 256 colors
endif
set title  " set the title of the terminal
set ttyfast

if &term ==? "xterm"
  set t_Sb=^[4%dm
  set t_Sf=^[3%dm
  set ttymouse=xterm2
endif

" style/formatting
set autoindent
set colorcolumn=79
set expandtab
set ignorecase
set nowrap
set shiftwidth=4
set smartindent
set smarttab
set softtabstop=4
set tabstop=4

"colorscheme inkpot
set background=dark
let g:solarized_termcolors=256
let g:solarized_termtrans=1
colorscheme solarized

" highlight >--- with a better color from inkpot, X(82) vs inkpots X(55)
au BufEnter * hi SpecialKey cterm=BOLD ctermfg=238 ctermbg=NONE

" general
set bs=2
set cscopetag
set foldenable
set foldmethod=marker
set history=50
set hlsearch
set noincsearch
set laststatus=2
set list
set listchars=
set listchars=extends:$,precedes:$,tab:>-,trail:.
set mouse=
set nocompatible
set nomodeline
set ruler
set scrolloff=3
set showcmd
set showmatch
set suffixes+=.log,.out
set viminfo='20,<100,%
set wildmenu
set wildignore=*.pyc,*.obj,*.o,*.lo


"
" key mappings
"

nnoremap <leader><space> :noh<cr>
nnoremap <leader>sync :syntax sync fromstart<cr>
nnoremap <leader>b :<C-U>CtrlPBuffer<CR>

" don't outdent comment lines when they are smartindented help smartindent
inoremap # X#

" Don't use Ex mode, use Q for formatting
map Q gq

" q: is annoying
nmap q: :q


"
" other
"

" make % work in html and other files
runtime macros/matchit.vim

source $VIMRUNTIME/ftplugin/man.vim " make :Man command available

" default MANPAGER vimmanpager doesn't play well
" with the :Man command and we don't want to see raw colour codes
" so we use sed to strip them.
let $MANPAGER = "sed -e 's:\\x1B\\[[[:digit:]]\\+m::g'"


"
" auto...
"

autocmd BufRead,BufNewFile *.as setlocal ft=actionscript
autocmd BufRead,BufNewFile *.css setlocal ts=2 sw=2 sts=2
autocmd BufRead,BufNewFile *.haml setlocal ts=2 sw=2 sts=2
autocmd BufRead,BufNewFile *.html setlocal ts=2 sw=2 sts=2
autocmd BufRead,BufNewFile *.jinja setlocal ft=htmljinja ts=2 sw=2 sts=2
autocmd BufRead,BufNewFile *.js setlocal ts=2 sw=2 sts=2
autocmd BufRead,BufNewFile *.jst setlocal ft=jst ts=2 sw=2 sts=2
autocmd BufRead,BufNewFile *.less setlocal ft=less ts=2 sw=2 sts=2
autocmd BufRead,BufNewFile *.md setlocal ft=markdown
autocmd BufRead,BufNewFile *.rb setlocal ts=2 sw=2 sts=2
autocmd BufRead,BufNewFile *.tf setlocal ts=2 sw=2 sts=2
autocmd BufRead,BufNewFile *.tst setlocal syntax=perl
autocmd BufRead,BufNewFile *.txt setlocal printoptions+=number:n
autocmd BufRead,BufNewFile *.scss setlocal ft=scss ts=2 sw=2 sts=2
autocmd BufRead,BufNewFile *.yml setlocal ts=2 sw=2 sts=2
autocmd BufRead,BufNewFile *.yaml setlocal ts=2 sw=2 sts=2
autocmd BufRead,BufNewFile Build* setlocal noexpandtab filetype=make syntax=make
autocmd BufRead,BufNewFile Jenkinsfile setlocal ft=groovy
autocmd BufRead,BufNewFile hg-editor-*.txt setlocal syntax=hgcommit
autocmd BufRead,BufNewFile inv/* setlocal syntax=ansible_hosts
autocmd BufRead,BufNewFile inventory/* setlocal syntax=ansible_hosts
autocmd BufRead,BufNewFile [Mm]ake* setlocal noexpandtab filetype=make syntax=make
autocmd BufRead,BufNewFile Rakefile setlocal ts=2 sw=2 sts=2
autocmd BufRead,BufNewFile Vagrantfile setlocal ft=ruby ts=2 sw=2 sts=2
autocmd FileType crontab set backupcopy=yes

" golang
au FileType go nmap <leader>r <Plug>(go-run)
au FileType go nmap <leader>b <Plug>(go-build)
au FileType go nmap <leader>t <Plug>(go-test)
au FileType go nmap <leader>c <Plug>(go-coverage)
au FileType go nmap <Leader>ds <Plug>(go-def-split)
au FileType go nmap <Leader>dv <Plug>(go-def-vertical)
au FileType go nmap <Leader>dt <Plug>(go-def-tab)
au FileType go nmap <Leader>gd <Plug>(go-doc)
au FileType go nmap <Leader>gv <Plug>(go-doc-vertical)
au FileType go nmap <Leader>gb <Plug>(go-doc-browser)
au FileType go nmap <Leader>s <Plug>(go-implements)
au FileType go nmap <Leader>i <Plug>(go-info)
au FileType go nmap <Leader>e <Plug>(go-rename)

let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_fields = 1
let g:go_highlight_types = 1
let g:go_highlight_operators = 1
let g:go_highlight_build_constraints = 1

" restore last cursor position
autocmd BufReadPost *
      \ if line("'\"") > 0 && line ("'\"") <= line("$") |
      \     exe "normal g'\"" |
      \ endif |

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

"
" plugins
"

" airline (theming)
let g:airline_detect_modified = 1
let g:airline_detect_paste = 1
"let g:airline_theme = 'badwolf'
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
let g:airline_left_sep = ''
let g:airline_right_sep = ''
let g:airline_linecolumn_prefix = '¶ '
let g:airline_branch_prefix = '⎇ '
let g:airline_paste_symbol = 'ρ'

let g:airline_section_z = '0x%-4B %3p%% '.g:airline_linecolumn_prefix.'%3l:%3c'

" ctrlp (fuzzy file/buf matching)
let g:ctrlp_custom_ignore = {
    \ 'dir': '\v[\/]migrations$',
    \ }
let g:ctrlp_working_path_mode = 'a'
let g:ctrlp_use_caching = 1
let g:ctrlp_clear_cache_on_exit = 0

" pt
let g:pt_prg = "pt --nogroup --nocolor"

" tagbar (tagging)
nnoremap <leader>t :TagbarOpen<cr>
let g:tagbar_autoclose = 1
let g:tagbar_compact = 1
let g:tagbar_sort = 0
let g:tagbar_width = 40


":python << EOF
"import os
"virtualenv = os.environ.get('VIRTUAL_ENV')
"if virtualenv:
"    activate_this = os.path.join(virtualenv, 'bin', 'activate_this.py')
"    if os.path.exists(activate_this):
"        execfile(activate_this, dict(__file__=activate_this))
"EOF
