scriptencoding utf-8

" minpac
packadd minpac
call minpac#init()
call minpac#add('AndrewRadev/splitjoin.vim')
call minpac#add('Shougo/echodoc.vim')
call minpac#add('arp242/gopher.vim')
call minpac#add('chrisbra/Recover.vim')
call minpac#add('dag/vim-fish')
call minpac#add('dart-lang/dart-vim-plugin')
call minpac#add('editorconfig/editorconfig-vim')
call minpac#add('hrsh7th/cmp-calc')
call minpac#add('hrsh7th/cmp-nvim-lsp')
call minpac#add('hrsh7th/cmp-path')
call minpac#add('hrsh7th/nvim-cmp')
call minpac#add('hrsh7th/vim-vsnip')
call minpac#add('itchyny/lightline.vim')
call minpac#add('jaawerth/nrun.vim')
call minpac#add('junegunn/fzf')
call minpac#add('junegunn/fzf.vim')
call minpac#add('k-takata/minpac', {'type': 'opt'})
call minpac#add('kana/vim-submode')
call minpac#add('koron/imcsc-vim')
call minpac#add('mbbill/undotree')
call minpac#add('neovim/nvim-lsp')
call minpac#add('niklasl/vim-rdf')
call minpac#add('plasticboy/vim-markdown')
call minpac#add('storyn26383/vim-vue')
call minpac#add('tomasr/molokai')
call minpac#add('tomtom/tcomment_vim')
call minpac#add('tpope/vim-fugitive')
call minpac#add('wakatime/vim-wakatime')
packloadall

" set key of <Leader>
let mapleader = "\<Space>"

" nvim-cmp
lua <<EOF
local cmp = require('cmp')
cmp.setup {
  preselect = cmp.PreselectMode.None,
  mapping = {
    ['<Tab>'] = cmp.mapping.select_next_item(),
    ['<S-Tab>'] = cmp.mapping.select_prev_item(),
    ['<C-x><C-o>'] = cmp.mapping.complete(),
    ['<CR>'] = cmp.mapping.confirm({ select = false }),
  },
  snippet = {
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body)
    end,
  },
  sources = {
    { name = 'calc' },
    { name = 'nvim_lsp' },
    { name = 'path' },
    { name = 'vsnip' },
  },
}
EOF

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
nnoremap <Leader>p :call fzf#run(fzf#wrap({'source': 'ag -l'}))<CR>
nnoremap <Leader>g :call GitGrep("")<CR>
vnoremap <Leader>g y:call GitGrep(@")<CR>

function! GitGrep(kwd)
  call fzf#vim#grep(
        \   'git grep --line-number ""',
        \   0,
        \   {
        \     'dir': systemlist('git rev-parse --show-toplevel')[0],
        \     'options': '--query='.shellescape(a:kwd),
        \   },
        \ )
endfunction

"" Suppress fzf.vim custom statusline(use lightline)
autocmd! User FzfStatusLine :

" go-vim
let g:go_template_autocreate = 0

" vim-clang
let g:clang_cpp_options = '-std=c++0x -stdlib=libc++'

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
nnoremap <silent> <Leader>w :w<CR>
nnoremap <silent> <Leader>e :enew<CR>
nnoremap <silent> <Leader>q :up<CR>:bp \| bd #<CR>
nnoremap <silent> <Leader>x :q<CR>
nnoremap <silent> <Leader>c :enew<CR>:call Term()<CR>
noremap <silent> <Leader>h 60h
noremap <silent> <Leader>l 60l
noremap <silent> <Leader>k 15k
noremap <silent> <Leader>j 15j
noremap <silent> <C-j> <Esc>:noh<CR>
noremap! <silent> <C-j> <Esc>:noh<CR>
noremap n nzz
tnoremap <C-j> <C-\><C-n>
vnoremap // <Esc>/\%V
nnoremap <silent> <Leader>t :call Tabs()<CR>
nnoremap <silent> <Leader>n :tab split<CR>

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
colorscheme molokai
syntax off
set ambiwidth=single
set autoindent
set backspace=indent,eol,start
set breakindent
set breakindentopt=sbr
set clipboard=unnamedplus
set directory^=$XDG_DATA_HOME/nvim/swap//
set expandtab
set hidden
set hlsearch
set ignorecase
set incsearch
set infercase
set laststatus=0
set list
set listchars=tab:»\ ,trail:-,extends:»,precedes:«,nbsp:%
set matchpairs+=<:>
set matchtime=1
set matchtime=3
set mouse=a
set nonumber
set notermguicolors
set novb
set novisualbell
set nowritebackup
set ruler
set scrolloff=5
set shiftround
set shiftwidth=2
set showbreak=>
set showmatch
set smartcase
set smartindent
set tabstop=2
set termguicolors
set textwidth=0
set undofile
set updatetime=500
set wrap

" Filetypes
au BufRead,BufNewFile *.graphql setfiletype graphql

" nvim colors
hi Normal guifg=#ffffff guibg=black
" Change the default background of floating window.
hi NormalFloat guibg=#444444 guifg=#ffffff ctermbg=238 ctermfg=7

" nvim_lsp

" Enlarge the capabilities powered by nvim-cmp.
lua capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())

nnoremap <silent> <c-]> <cmd>lua vim.lsp.buf.definition()<CR>
if executable('typescript-language-server')
  lua require'lspconfig'.tsserver.setup{
        \   capabilities = capabilities;
        \   filetypes = {"typescript", "typescriptreact", "typescript.tsx"};
        \   flags = {
        \     debounce_text_changes = 500;
        \   };
        \ }
en
if executable('gopls')
  lua require'lspconfig'.gopls.setup{
        \   capabilities = capabilities;
        \ }
en
if executable('graphql-lsp')
  lua require'lspconfig'.graphql.setup{
        \   capabilities = capabilities;
        \ }
en

nnoremap <Leader>i <cmd>lua vim.lsp.buf.hover()<CR><cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>

" Hide NetRW buffer
autocmd FileType netrw setl bufhidden=wipe

" Assembly specific settings
augroup asmfile
  autocmd!
  autocmd FileType asm setl shiftwidth=8
  autocmd FileType asm setl noexpandtab
  autocmd FileType asm setl tabstop=8
augroup END

" Go specific settings
augroup gofile
  au!
  au FileType go setl shiftwidth=2
  au FileType go setl noexpandtab
  au FileType go setl tabstop=2
  au FileType go setl formatprg=goimports
augroup END

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

function! Term()
  call termopen('fish')
  setlocal nonumber norelativenumber scrolloff=0
endfunction

autocmd BufLeave * if exists('b:term_title') && exists('b:terminal_job_pid') | file `='term/' . b:terminal_job_pid . '/' . b:term_title`

autocmd BufEnter * if &buftype ==# 'terminal' | set so=0 | else | set so=5 | endif
