scriptencoding utf-8

set rtp+=$GHQ_ROOT/github.com/junegunn/fzf

" vim-plug
call plug#begin('~/.local/share/nvim/plugged')

Plug 'tomtom/tcomment_vim'
Plug 'tomasr/molokai'
Plug 'AndrewRadev/splitjoin.vim'
Plug 'kana/vim-submode'
Plug 'plasticboy/vim-markdown'
Plug 'koron/imcsc-vim'
Plug 'Shougo/echodoc.vim'
Plug 'fatih/vim-go', { 'branch': 'gocode-change' }
Plug 'buoto/gotests-vim'
Plug 'neomake/neomake'
Plug 'HerringtonDarkholme/yats.vim' " Typescript syntax highlighting
Plug 'tpope/vim-fugitive'
Plug 'artur-shaik/vim-javacomplete2'
Plug 'leafgarland/typescript-vim'
Plug 'editorconfig/editorconfig-vim'
Plug 'dag/vim-fish'
Plug 'prabirshrestha/async.vim'
Plug 'prabirshrestha/vim-lsp'
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'yami-beta/asyncomplete-gocode.vim'
Plug 'junegunn/fzf.vim'
Plug 'jaawerth/nrun.vim'
Plug 'posva/vim-vue'

call plug#end()

" neomake
let g:neomake_cpp_enabled_makers = ['clang']
let g:neomake_cpp_clang_maker = {
      \   'exe': 'clang++',
      \   'args': ['-I/home/yuki/.linuxbrew/include', '-std=c++0x'],
      \ }

let g:neomake_typescript_enabled_makers = []
let g:neomake_typescript_tsc_maker = {
      \   'args': [
      \     '--noEmit'
      \   ],
      \   'append_file': 0,
      \   'errorformat':
      \     '%E%f %#(%l\,%c): error %m,' .
      \     '%E%f %#(%l\,%c): %m,' .
      \     '%Eerror %m,' .
      \     '%C%\s%\+%m'
      \ }
autocmd! BufWritePost * Neomake

let g:neomake_go_gometalinter_args = ['--config='.$HOME.'/.config/gometalinter/config.json']

let g:neomake_python_enabled_makers = []

au FileType javascript let b:neomake_javascript_eslint_exe = nrun#Which('eslint')

" vim-lsp
nnoremap <C-]> :LspDefinition<CR>

if executable('coursier')
  au User lsp_setup call lsp#register_server({
        \   'name': 'scala-languageserver',
        \   'cmd': {server_info->['coursier', 'launch', '-r', 'https://dl.bintray.com/dhpcs/maven', '-r', 'sonatype:releases', 'com.github.dragos:languageserver_2.11:0.1.3']},
        \   'whitelist': ['scala'],
        \ })
endif
if executable('go-langserver')
  au User lsp_setup call lsp#register_server({
        \   'name': 'go-langserver',
        \   'cmd': {server_info->['go-langserver', '-mode', 'stdio']},
        \   'whitelist': ['go'],
        \ })
endif
if executable('pyls')
  au User lsp_setup call lsp#register_server({
        \   'name': 'pyls',
        \   'cmd': {server_info->['pyls']},
        \   'whitelist': ['python'],
        \ })
endif
if executable('typescript-language-server')
  au User lsp_setup call lsp#register_server({
        \   'name': 'typescript-language-server',
        \   'cmd': {server_info->['typescript-language-server', '--stdio']},
        \   'root_uri':{server_info->lsp#utils#path_to_uri(lsp#utils#find_nearest_parent_file_directory(lsp#utils#get_buffer_path(), 'tsconfig.json'))},
        \   'whitelist': [''],
        \ })
endif
if executable('js-langserver')
  au User lsp_setup call lsp#register_server({
        \   'name': 'js-langserver',
        \   'cmd': {server_info->['js-langserver', '--stdio']},
        \   'whitelist': ['javascript'],
        \ })
endif
if executable('javascript-typescript-stdio')
  au User lsp_setup call lsp#register_server({
        \   'name': 'javascript-typescript-stdio',
        \   'cmd': {server_info->['javascript-typescript-stdio']},
        \   'whitelist': ['typescript', 'javascript'],
        \ })
endif
if executable('language_server-ruby')
  au User lsp_setup call lsp#register_server({
        \   'name': 'language_server-ruby',
        \   'cmd': {server_info->['language_server-ruby']},
        \   'whitelist': ['ruby'],
        \ })
endif
if executable('rls')
  au User lsp_setup call lsp#register_server({
        \   'name': 'rls',
        \   'cmd': {server_info->['rustup', 'run', 'nightly', 'rls']},
        \   'whitelist': ['rust'],
        \ })
endif

" asyncomplete
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <expr> <CR> pumvisible() ? "\<C-y>\<CR>" : "\<CR>"
let g:asyncomplete_log_file = '/tmp/asyncomplete'
call asyncomplete#register_source(
      \   asyncomplete#sources#gocode#get_source_options({
      \     'name': 'gocode',
      \     'whitelist': ['go'],
      \     'completor': function('asyncomplete#sources#gocode#completor'),
      \     'config': {
      \       'gocode_path': expand('~/.local/bin/gocode'),
      \     },
      \   }),
      \ )

" vim-go
let g:go_fmt_command = "goimports"
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_structs = 1
let g:go_highlight_operators = 1
let g:go_term_enabled = 1
let g:go_highlight_build_constraints = 1

" set key of <Leader>
let mapleader = "\<Space>"

" echodoc
let g:echodoc#enable_at_startup = 1

" vim-submode
let g:submode_keep_leaving_key = 1
let g:submode_timeout = 0
call submode#enter_with('winsize', 'n', '', '<C-w>>', '<C-w>>')
call submode#enter_with('winsize', 'n', '', '<C-w><', '<C-w><')
call submode#enter_with('winsize', 'n', '', '<C-w>+', '<C-w>-')
call submode#enter_with('winsize', 'n', '', '<C-w>-', '<C-w>+')
call submode#map('winsize', 'n', '', '>', '<C-w>>')
call submode#map('winsize', 'n', '', '<', '<C-w><')
call submode#map('winsize', 'n', '', '+', '<C-w>-')
call submode#map('winsize', 'n', '', '-', '<C-w>+')

" extension of f-function
nmap <expr> f 'lv$<Esc>/\%V['.nr2char(getchar()).']<CR><Plug>(flc)'
nmap <expr> F 'hv0<Esc>?\%V['.nr2char(getchar()).']<CR><Plug>(flc)'
call submode#enter_with('flc', 'n', '', '<Plug>(flc)', ':autocmd flc InsertEnter * noh<CR>')
call submode#map('flc', 'n', '', 'n', 'n')
call submode#map('flc', 'n', '', 'N', 'N')

" fzf.vim
nnoremap <Leader>b :Buffer<CR>
nnoremap <Leader>p :GFiles<CR>

" go-vim
let g:go_template_autocreate = 0

" vim-clang
" let g:clang_cpp_options = '-std=c++0x -stdlib=libc++'
let g:clang_cpp_options = '-std=c++0x -I /home/yuki/.linuxbrew/include'

" javacomplete2
autocmd FileType java setlocal omnifunc=javacomplete#Complete

" vim-markdown
let g:vim_markdown_folding_disabled = 1

" other custom keymaps
nnoremap <Leader>w :w<CR>
nnoremap <Leader>e :enew<CR>
nnoremap <Leader>q ZZ
nnoremap <Leader>t :enew<CR>:call Term()<CR>
noremap <Leader>h 60h
noremap <Leader>l 60l
noremap <Leader>k 15k
noremap <Leader>j 15j
noremap <C-j> <Esc>:noh<CR>
noremap! <C-j> <Esc>:noh<CR>
noremap n nzz
tnoremap <C-j> <C-\><C-n>
vnoremap // <Esc>/\%V

" nvim
colorscheme molokai
syntax on
set t_Co=256
set backspace=indent,eol,start
set scrolloff=5
set noswapfile
set nowritebackup
set nobackup
set number
set showmatch matchtime=1
set autoindent
set expandtab
set shiftwidth=2
set smartindent
set backspace=indent
set vb t_vb=
set novisualbell
set clipboard+=unnamedplus
set list
set ruler
set matchpairs& matchpairs+=<:>
set showmatch
set matchtime=3
set wrap
set textwidth=0
set listchars=tab:»\ ,trail:-,extends:»,precedes:«,nbsp:%
set tabstop=2
set shiftround
set infercase
set ignorecase
set smartcase
set incsearch
set hlsearch
set ambiwidth=double
set completeopt=menuone

" Hide NetRW buffer
autocmd FileType netrw setl bufhidden=wipe

" configs of auto insertion list prefix on markdown files
augroup config
  autocmd!
  autocmd FileType markdown inoremap <buffer><expr> <CR> (getline('.') =~ '^\s*-\s') ? '<CR>- ' : '<CR>'
  autocmd FileType markdown nnoremap <buffer><expr> o (getline('.') =~ '^\s*-\s') ? 'o- ' : 'o'
  autocmd FileType markdown inoremap <buffer><expr> <CR> (getline('.') =~ '^\s*\*\s') ? '<CR>* ' : '<CR>'
  autocmd FileType markdown nnoremap <buffer><expr> o (getline('.') =~ '^\s*\*\s') ? 'o* ' : 'o'
  autocmd BufNewFile,BufRead *.es6 set filetype=javascript
augroup END

" config of vim -b option. it enables read binary for vim
augroup BinaryXXD
  autocmd!
  autocmd BufReadPre  *.bin let &binary =1
  autocmd BufReadPost * if &binary | silent %!xxd -g 1
  autocmd BufReadPost * set ft=xxd | endif
  autocmd BufWritePre * if &binary | %!xxd -r | endif
  autocmd BufWritePost * if &binary | silent %!xxd -g 1
  autocmd BufWritePost * set nomod | endif
augroup END
