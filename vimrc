" vim-plug
call plug#begin('~/.vim/plugged')
Plug 'JulesWang/css.vim', { 'for': 'css' }
Plug 'airblade/vim-gitgutter'
Plug 'altercation/vim-colors-solarized'
Plug 'ap/vim-css-color', { 'for': 'css' }
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'briancollins/vim-jst', { 'for': 'jst' }
Plug 'ekalinin/Dockerfile.vim', { 'for': 'Dockerfile' }
Plug 'fatih/vim-go', { 'do': ':GoInstallBinaries' }
Plug 'groenewege/vim-less', { 'for': 'less' }
Plug 'hashivim/vim-terraform', { 'for': 'terraform' }
Plug 'kien/ctrlp.vim'
Plug 'majutsushi/tagbar'
Plug 'mitsuhiko/vim-jinja', { 'for': 'jinja' }
Plug 'mitsuhiko/vim-python-combined', { 'for': 'python' }
Plug 'nazo/pt.vim'
Plug 'othree/html5.vim', { 'for': 'html' }
Plug 'pangloss/vim-javascript', { 'for': 'javascript' }
Plug 'pearofducks/ansible-vim', { 'for': 'ansible' }
Plug 'tangledhelix/vim-kickstart', { 'for': 'kickstart' }
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-git'
Plug 'MaxMEllon/vim-jsx-pretty'
Plug 'leafgarland/typescript-vim'
Plug 'google/vim-jsonnet'
Plug 'chrisbra/unicode.vim'
Plug 'jremmen/vim-ripgrep'
" Plug 'sjl/splice.vim'
Plug 'errael/splice9'
Plug 'yasuhiroki/github-actions-yaml.vim'
Plug 'neoclide/coc.nvim', {'branch': 'release', 'for': 'typescript*'}
Plug 'github/copilot.vim'
"Plug 'zbirenbaum/copilot.lua' " might need nvim
"Plug 'zbirenbaum/copilot-cmp'
Plug 'dense-analysis/ale'
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
let g:my_textwidth = 100
set autoindent
execute 'set colorcolumn=' . g:my_textwidth
set expandtab
set ignorecase
set nowrap
set shiftwidth=4
set smartindent
set smarttab
set softtabstop=4
set tabstop=4
execute 'set textwidth=' . g:my_textwidth

"colorscheme inkpot
set background=dark
let g:solarized_termcolors=256
let g:solarized_termtrans=1
colorscheme solarized

" highlight >--- with a better color from inkpot, X(82) vs inkpots X(55)
au BufEnter * hi SpecialKey cterm=BOLD ctermfg=237 ctermbg=NONE

" general
set backspace=2
set cscopetag
set nofileignorecase " so Build* doesn't match build.go
set foldenable
set foldmethod=marker
set history=50
set hlsearch
set noincsearch
set laststatus=2
set list
set listchars=
set listchars=extends:$,precedes:$,tab:¬\ ,trail:.
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
nnoremap <leader>lc :lclose<CR>

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
autocmd BufRead,BufNewFile *.c setlocal ts=2 sw=2 sts=2 nocin
autocmd BufRead,BufNewFile *.cc setlocal ts=2 sw=2 sts=2 nocin
autocmd BufRead,BufNewFile *.h setlocal ts=2 sw=2 sts=2 nocin
autocmd BufRead,BufNewFile *.css setlocal ts=2 sw=2 sts=2
autocmd BufRead,BufNewFile *.haml setlocal ts=2 sw=2 sts=2
autocmd BufRead,BufNewFile *.html setlocal ts=2 sw=2 sts=2
autocmd BufRead,BufNewFile *.jinja setlocal ft=htmljinja ts=2 sw=2 sts=2
autocmd BufRead,BufNewFile *.js setlocal ts=2 sw=2 sts=2
autocmd BufRead,BufNewFile *.jst setlocal ft=jst ts=2 sw=2 sts=2
autocmd BufRead,BufNewFile *.less setlocal ft=less ts=2 sw=2 sts=2
autocmd BufRead,BufNewFile *.md setlocal ft=markdown
autocmd BufRead,BufNewFile *.proto setlocal ts=2 sw=2 sts=2
autocmd BufRead,BufNewFile *.rb setlocal ts=2 sw=2 sts=2
autocmd BufRead,BufNewFile *.tf setlocal ts=2 sw=2 sts=2
autocmd BufRead,BufNewFile *.tst setlocal syntax=perl
autocmd BufRead,BufNewFile *.txt setlocal printoptions+=number:n
autocmd BufRead,BufNewFile *.scss setlocal ft=scss ts=2 sw=2 sts=2
autocmd BufRead,BufNewFile *.yml setlocal ts=2 sw=2 sts=2
autocmd BufRead,BufNewFile *.yaml setlocal ts=2 sw=2 sts=2
autocmd BufRead,BufNewFile *.yaml.tmpl setlocal ft=yaml ts=2 sw=2 sts=2
autocmd BufRead,BufNewFile Build* setlocal noexpandtab filetype=make syntax=make
autocmd BufRead,BufNewFile Jenkinsfile setlocal ft=groovy
autocmd BufRead,BufNewFile hg-editor-*.txt setlocal syntax=hgcommit
autocmd BufRead,BufNewFile inv/* setlocal syntax=ansible_hosts
autocmd BufRead,BufNewFile inventory/* setlocal syntax=ansible_hosts
autocmd BufRead,BufNewFile go.mod setlocal noexpandtab
autocmd BufRead,BufNewFile [Mm]ake* setlocal noexpandtab filetype=make syntax=make
autocmd BufRead,BufNewFile Rakefile setlocal ts=2 sw=2 sts=2
autocmd BufRead,BufNewFile Vagrantfile setlocal ft=ruby ts=2 sw=2 sts=2
autocmd FileType crontab set backupcopy=yes
autocmd FileType jsonnet set ts=2 sw=2 sts=2
autocmd FileType typescript* set ts=2 sw=2 sts=2

" gitgutter
highlight GitGutterAdd ctermbg=none
highlight GitGutterChange ctermbg=none
highlight GitGutterDelete ctermbg=none
highlight SignColumn ctermbg=none

" AFAICT, gitgutter is busted because it never updates; force it to run
" when writing the file
au BufWritePost * :GitGutter

" golang
au FileType go nmap <leader>r <Plug>(go-run)
au FileType go nmap <leader>b <Plug>(go-build)
au FileType go nmap <leader>t :GoTest!<cr>
au FileType go nmap <leader>tc <Plug>(go-test-compile)
au FileType go nmap <leader>T <Plug>(go-test-func)
au FileType go nmap <leader>TF <Plug>(go-test-file)
au FileType go nmap <leader>c <Plug>(go-coverage)
au FileType go nmap <leader>cc <Plug>(go-coverage-clear)
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
let g:go_fmt_command = "goimports"
" separate imports from this repo from others
au FileType go let b:go_fmt_options = {
    \ 'goimports': '-local ' .
    \ trim(system('{cd '. shellescape(expand('%:h')) .' && go list -m | head -n1;}')),
    \ }

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

" yaml syntax is busted when VAR='blah' is used. First ' does not get
" recognized. this fixes it some
autocmd FileType yaml* syntax clear yamlFlowString

"
" coc + typescript
"
let g:coc_global_extensions = ['coc-go', 'coc-tsserver']
let g:coc_user_config = {}
" example config; see :help coc-config (when in typescript file)
"let g:coc_user_config['diagnostic.hintSign'] = '!!'

autocmd FileType yaml* syntax clear yamlFlowString

" Remap keys for applying codeAction to the current line.
nmap <leader>ac <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
nmap <leader>qf <Plug>(coc-fix-current)

nnoremap <leader>ld :CocDiagnostics<cr>

" GoTo code navigation.
nmap <silent> cd <Plug>(coc-definition)
nmap <silent> cy <Plug>(coc-type-definition)
nmap <silent> ci <Plug>(coc-implementation)
nmap <silent> cr <Plug>(coc-references)
nmap <silent> dn <Plug>(coc-diagnostic-next)
nmap <silent> dp <Plug>(coc-diagnostic-prev)

" copilot
" ability to press tab and ignore the suggestion
inoremap <silent> <A-Tab> <Tab>

":python << EOF
"import os
"virtualenv = os.environ.get('VIRTUAL_ENV')
"if virtualenv:
"    activate_this = os.path.join(virtualenv, 'bin', 'activate_this.py')
"    if os.path.exists(activate_this):
"        execfile(activate_this, dict(__file__=activate_this))
"EOF

source ~/.vimrc.local
