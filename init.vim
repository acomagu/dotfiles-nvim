scriptencoding utf-8

set rtp+=$GHQ_ROOT/github.com/junegunn/fzf

" vim-plug
call plug#begin('~/.local/share/nvim/plugged')

Plug 'AndrewRadev/splitjoin.vim'
Plug 'artur-shaik/vim-javacomplete2'
Plug 'buoto/gotests-vim'
Plug 'dag/vim-fish'
Plug 'editorconfig/editorconfig-vim'
Plug 'fatih/vim-go', { 'branch': 'gocode-change' }
Plug 'HerringtonDarkholme/yats.vim' " Typescript syntax highlighting
Plug 'itchyny/lightline.vim'
Plug 'jaawerth/nrun.vim'
Plug 'jeffkreeftmeijer/vim-dim'
Plug 'junegunn/fzf.vim'
Plug 'kana/vim-submode'
Plug 'koron/imcsc-vim'
Plug 'leafgarland/typescript-vim'
Plug 'neomake/neomake'
Plug 'niklasl/vim-rdf'
Plug 'plasticboy/vim-markdown'
Plug 'posva/vim-vue'
Plug 'prabirshrestha/asyncomplete-lsp.vim'
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/async.vim'
Plug 'prabirshrestha/vim-lsp'
Plug 'Shougo/echodoc.vim'
Plug 'tomtom/tcomment_vim'
Plug 'tpope/vim-fugitive'

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
let g:lsp_signs_enabled = 1
let g:lsp_diagnostics_echo_cursor = 1
nnoremap <C-]> :LspDefinition<CR>

augroup Lsp
  au!
  if executable('coursier')
    au User lsp_setup call lsp#register_server({
          \   'name': 'scala-languageserver',
          \   'cmd': {server_info->['coursier', 'launch', '-r', 'https://dl.bintray.com/dhpcs/maven', '-r', 'sonatype:releases', 'com.github.dragos:languageserver_2.11:0.1.3']},
          \   'whitelist': ['scala'],
          \ })
    au FileType scala setlocal omnifunc=lsp#complete
  endif
  " if executable('golsp')
  "   au User lsp_setup call lsp#register_server({
  "         \   'name': 'golsp',
  "         \   'cmd': {server_info->['golsp', '-mode', 'stdio']},
  "         \   'whitelist': ['go'],
  "         \ })
  "   au FileType go setlocal omnifunc=lsp#complete
  " endif
  if executable('bingo')
    au User lsp_setup call lsp#register_server({
          \   'name': 'bingo',
          \   'cmd': {server_info->['bingo']},
          \   'whitelist': ['go'],
          \ })
    au FileType go setlocal omnifunc=lsp#complete
  endif
  if executable('pyls')
    au User lsp_setup call lsp#register_server({
          \   'name': 'pyls',
          \   'cmd': {server_info->['pyls']},
          \   'whitelist': ['python'],
          \ })
    au FileType python setlocal omnifunc=lsp#complete
  endif
  if executable('typescript-language-server')
    au User lsp_setup call lsp#register_server({
          \   'name': 'typescript-language-server',
          \   'cmd': {server_info->['typescript-language-server', '--stdio']},
          \   'root_uri':{server_info->lsp#utils#path_to_uri(lsp#utils#find_nearest_parent_file_directory(lsp#utils#get_buffer_path(), 'tsconfig.json'))},
          \   'whitelist': ['typescript'],
          \ })
    au FileType typescript setlocal omnifunc=lsp#complete
  endif
  if executable('js-langserver')
    au User lsp_setup call lsp#register_server({
          \   'name': 'js-langserver',
          \   'cmd': {server_info->['js-langserver', '--stdio']},
          \   'whitelist': ['javascript'],
          \ })
    au FileType javascript setlocal omnifunc=lsp#complete
  endif
  if executable('javascript-typescript-stdio')
    au User lsp_setup call lsp#register_server({
          \   'name': 'javascript-typescript-stdio',
          \   'cmd': {server_info->['javascript-typescript-stdio']},
          \   'whitelist': ['typescript', 'javascript'],
          \ })
    au FileType javascript setlocal omnifunc=lsp#complete
  endif
  if executable('language_server-ruby')
    au User lsp_setup call lsp#register_server({
          \   'name': 'language_server-ruby',
          \   'cmd': {server_info->['language_server-ruby']},
          \   'whitelist': ['ruby'],
          \ })
    au FileType ruby setlocal omnifunc=lsp#complete
  endif
  if executable('rls')
    au User lsp_setup call lsp#register_server({
          \   'name': 'rls',
          \   'cmd': {server_info->['rustup', 'run', 'nightly', 'rls']},
          \   'whitelist': ['rust'],
          \ })
    au FileType rust setlocal omnifunc=lsp#complete
  endif
augroup END

" asyncomplete
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <expr> <CR> pumvisible() ? "\<C-y>\<CR>" : "\<CR>"
let g:asyncomplete_log_file = '/tmp/asyncomplete'
let g:asyncomplete_smart_completion = 0

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
nnoremap <Leader>g y:call GitGrep("")<CR>
vnoremap <Leader>g y:call GitGrep(@")<CR>

function! GitGrep(kwd)
  call fzf#vim#grep(
        \   'git grep --line-number ""', 0,
        \   {
        \     'dir': systemlist('git rev-parse --show-toplevel')[0],
        \     'options': '--query='.shellescape(a:kwd),
        \   }, 0
        \ )
endfunction

"" Suppress fzf.vim custom statusline(use lightline)
autocmd! User FzfStatusLine :

" go-vim
let g:go_template_autocreate = 0

" vim-clang
let g:clang_cpp_options = '-std=c++0x -stdlib=libc++'

" javacomplete2
autocmd FileType java setlocal omnifunc=javacomplete#Complete

" lightline.vim
set noshowmode
let g:lightline = {
      \   'colorscheme': 'wombat',
      \   'component_function': {
      \       'mode': 'LightlineMode',
      \       'filename': 'LightlineFilename',
      \   },
      \ }

function! LightlineMode()
  return &filetype ==# 'fzf' ? 'FZF' :
        \ lightline#mode()
endfunction

function! LightlineFilename()
  return &filetype ==# 'fzf' ? '' :
        \ fnamemodify(expand('%'), ':~:.') !=# '' ? fnamemodify(expand('%'), ':~:.') : '[No Name]'
endfunction

" vim-markdown
let g:vim_markdown_folding_disabled = 1

" other custom keymaps
nnoremap <Leader>w :w<CR>
nnoremap <Leader>e :enew<CR>
nnoremap <Leader>q :up<CR>:call CloseBuf()<CR>
nnoremap <Leader>x :q<CR>
nnoremap <Leader>c :enew<CR>:call Term()<CR>
noremap <Leader>h 60h
noremap <Leader>l 60l
noremap <Leader>k 15k
noremap <Leader>j 15j
noremap <C-j> <Esc>:noh<CR>
noremap! <C-j> <Esc>:noh<CR>
noremap n nzz
tnoremap <C-j> <C-\><C-n>
vnoremap // <Esc>/\%V
nnoremap <Leader>t :call Tabs()<CR>
nnoremap <Leader>n :tab split<CR>

function! Tabs()
    let tabs = map(gettabinfo(), {_, v -> v['tabnr']})
    let current_tab = tabpagenr()
    let tabs_without_current = filter(tabs, {_, nr -> nr != current_tab})
    call fzf#run({
          \   'source': tabs_without_current,
          \   'sink': {nr -> execute('tabn ' . nr)},
          \   'down': '30%',
          \ })
endfunction

" nvim
colorscheme dim
syntax on
set ambiwidth=single
set autoindent
set backspace=indent
set backspace=indent,eol,start
set clipboard=unnamedplus
set completeopt=menuone
set expandtab
set hidden
set hlsearch
set ignorecase
set incsearch
set infercase
set list
set listchars=tab:»\ ,trail:-,extends:»,precedes:«,nbsp:%
set matchpairs& matchpairs+=<:>
set matchtime=3
set nobackup
set noswapfile
set novisualbell
set nowritebackup
set number
set ruler
set scrolloff=5
set shiftround
set shiftwidth=2
set showmatch
set showmatch matchtime=1
set smartcase
set smartindent
set tabstop=2
set t_Co=256
set textwidth=0
set vb t_vb=
set wrap

" Hide NetRW buffer
autocmd FileType netrw setl bufhidden=wipe

" configs to insert automatically list prefix on markdown files
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
    :bp|bd #
  endif
endfunction

function! CloseLastTerm()
  if len(filter(range(1, bufnr('$')), 'buflisted(v:val)')) == 1
    :q
  end
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
