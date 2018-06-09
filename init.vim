scriptencoding utf-8

set rtp+=$GHQ_ROOT/github.com/junegunn/fzf

" vim-plug
call plug#begin('~/.local/share/nvim/plugged')

Plug 'tomtom/tcomment_vim'
Plug 'Shougo/deoplete.nvim'
Plug 'tomasr/molokai'
Plug 'AndrewRadev/splitjoin.vim'
Plug 'kana/vim-submode'
Plug 'plasticboy/vim-markdown'
Plug 'koron/imcsc-vim'
Plug 'Shougo/echodoc.vim'
Plug 'fatih/vim-go'
Plug 'zchee/deoplete-go', { 'do': 'make'}  " For completion with vim-go
Plug 'buoto/gotests-vim'
Plug 'neomake/neomake'
Plug 'HerringtonDarkholme/yats.vim' " Typescript syntax highlighting
Plug 'tpope/vim-fugitive'
Plug 'artur-shaik/vim-javacomplete2'
Plug 'leafgarland/typescript-vim'
Plug 'editorconfig/editorconfig-vim'
Plug 'dag/vim-fish'
Plug 'autozimu/LanguageClient-neovim', { 'do': ':UpdateRemotePlugins' }
Plug 'junegunn/fzf.vim'
Plug 'jaawerth/nrun.vim'
Plug 'posva/vim-vue'

call plug#end()

" neomake
let g:neomake_cpp_enabled_makers = ['clang']
let g:neomake_cpp_clang_maker = {
      \ 'exe': 'clang++',
      \ 'args': ['-I/home/yuki/.linuxbrew/include', '-std=c++0x'],
      \ }

let g:neomake_typescript_enabled_makers = []
let g:neomake_typescript_tsc_maker = {
      \ 'args': [
          \ '--noEmit'
      \ ],
      \ 'append_file': 0,
      \ 'errorformat':
          \ '%E%f %#(%l\,%c): error %m,' .
          \ '%E%f %#(%l\,%c): %m,' .
          \ '%Eerror %m,' .
          \ '%C%\s%\+%m'
      \ }
autocmd! BufWritePost * Neomake

let g:neomake_go_gometalinter_args = ['--config='.$HOME.'/.config/gometalinter/config.json']

let g:neomake_python_enabled_makers = []

au FileType javascript let b:neomake_javascript_eslint_exe = nrun#Which('eslint')

" LanguageClient
let g:LanguageClient_serverCommands = {
    \   'scala': ['coursier', 'launch', '-r', 'https://dl.bintray.com/dhpcs/maven', '-r', 'sonatype:releases', 'com.github.dragos:languageserver_2.11:0.1.3'],
    \   'go': ['go-langserver'],
    \   'python': ['pyls'],
    \   'javascript': ['typescript-language-server', '--stdio'],
    \   'typescript': ['javascript-typescript-stdio'],
    \   'ruby': ['language_server-ruby'],
    \ }
let g:LanguageClient_autoStart = 1
let g:LanguageClient_changeThrottle = 0.5

nnoremap <silent> <C-]> :call LanguageClient_textDocument_definition()<CR>
nnoremap <silent> <C-[> :call LanguageClient_textDocument_references()<CR>

" deoplete
let g:deoplete#enable_at_startup = 1
let g:deoplete#enable_smart_case = 1
let g:deoplete#sources#syntax#min_keyword_length = 0
" if !exists('g:deoplete_keyword_patterns')
"   let g:deoplete#keyword_patterns = {}
" endif
" let g:deoplete#keyword_patterns['default'] = '\h\w*'
" inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
" function! s:my_cr_function()
"   return (pumvisible() ? "\<C-y>" : "" ) . "\<CR>"
" endfunction
inoremap <expr><TAB> pumvisible() ? "\<C-n>" : "\<TAB>"

" if !exists('g:deoplete#sources#omni#input_patterns')
"   let g:deoplete#sources#omni#input_patterns = {}
" endif
" let g:deoplete#sources#omni#input_patterns.perl = '\h\w*->\h\w*\|\h\w*::'

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
nnoremap <Leader>q :up<CR>:call CloseBuf()<CR>
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
set hidden
set completeopt=menuone

cnoremap w!! w !sudo tee > /dev/null %<CR> :e!<CR>

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

" Open terminal on new buffer
autocmd VimEnter * if @% == '' && s:GetBufByte() == 0 | call Term()
function! s:GetBufByte()
  let byte = line2byte(line('$') + 1)
  if byte == -1
    return 0
  else
    return byte - 1
  endif
endfunction

augroup OpIME
  autocmd!
  autocmd InsertLeave * call ImInActivate()
augroup END

function! ImInActivate()
  call system('fcitx-remote -c')
endfunction

function! CloseBuf()
  if len(filter(range(1, bufnr('$')), 'buflisted(v:val)')) == 1
    :q
  else
    :bd
  endif
endfunction

function! CloseLastTerm()
  if len(filter(range(1, bufnr('$')), 'buflisted(v:val)')) == 1
    :q
  endif
endfunction

function! Term()
  call termopen('fish', {'on_exit': 'OnExit'})
  setlocal nonumber norelativenumber
endfunction

function! OnExit(job_id, code, event)
  if a:code == 0
    call CloseLastTerm()
  endif
endfunction

autocmd BufLeave * if exists('b:term_title') && exists('b:terminal_job_pid') | file `='term/' . b:terminal_job_pid . '/' . b:term_title`
