scriptencoding utf-8

" let g:copilot_no_tab_map = v:true

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
" call minpac#add('github/copilot.vim')
call minpac#add('hrsh7th/cmp-calc')
call minpac#add('hrsh7th/cmp-nvim-lsp')
call minpac#add('hrsh7th/cmp-path')
call minpac#add('hrsh7th/nvim-cmp')
call minpac#add('hrsh7th/vim-vsnip')
call minpac#add('j-hui/fidget.nvim')
call minpac#add('junegunn/fzf')
call minpac#add('junegunn/fzf.vim')
call minpac#add('k-takata/minpac', {'type': 'opt'})
call minpac#add('kana/vim-submode')
call minpac#add('mbbill/undotree')
call minpac#add('neovim/nvim-lsp')
call minpac#add('niklasl/vim-rdf')
call minpac#add('petertriho/nvim-scrollbar')
call minpac#add('pierreglaser/folding-nvim')
call minpac#add('plasticboy/vim-markdown')
call minpac#add('storyn26383/vim-vue')
call minpac#add('tomasr/molokai')
call minpac#add('tomtom/tcomment_vim')
call minpac#add('tpope/vim-fugitive')
call minpac#add('wakatime/vim-wakatime')
packloadall

" set key of <Leader>
let mapleader = "\<Space>"

" " copilot-vim
" let g:copilot_node_command = $ASDF_DATA_DIR . '/installs/nodejs/lts-gallium/bin/node'
" imap <silent><script><expr> <C-f> copilot#Accept("\<CR>")

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
  view = {
    entries = 'native',
  },
  window = {
    documentation = {
      max_width = 100,
    },
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

" vim-markdown
let g:vim_markdown_folding_disabled = 1

" nvim-scrollbar
lua require('scrollbar').setup()

" fidget
lua require('fidget').setup({})

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
set breakindent
set breakindentopt=sbr
set clipboard=unnamedplus
set expandtab
set guifont=Source\ Code\ Pro\ Regular:h11
set ignorecase
set infercase
set laststatus=0
set list
set listchars=tab:»\ ,trail:-,extends:»,precedes:«,nbsp:%
set matchpairs+=<:>
set matchtime=3
set mouse=a
set nofoldenable
set nonumber
set scrolloff=5
set shiftround
set shiftwidth=2
set showbreak=>
set showmatch
set smartcase
set smartindent
set tabstop=2
set termguicolors
set undofile

" Filetypes
au BufRead,BufNewFile *.graphql setfiletype graphql

" nvim colors
hi Normal guifg=#ffffff guibg=black
" Change the default background of floating window.
hi NormalFloat guibg=#444444 guifg=#ffffff ctermbg=238 ctermfg=7

" Remove all statuslines
if exists('g:gonvim_running')
  let &statusline='%#Normal# '
endif

" Zoom-in / Zoom-out
function! Zoom(amount) abort
  call ZoomSet(matchstr(&guifont, '\d\+$') + a:amount)
endfunc

" Sets the font size to `font_size`
function ZoomSet(font_size) abort
  let &guifont = substitute(&guifont, '\d\+$', a:font_size, '')
endfunc

noremap <silent> <C-+> :call Zoom(v:count1)<CR>
noremap <silent> <C--> :call Zoom(-v:count1)<CR>
noremap <silent> <C-0> :call ZoomSet(11)<CR>

" nvim_lsp

" Enlarge the capabilities powered by nvim-cmp.
lua capabilities = require('cmp_nvim_lsp').default_capabilities()
lua <<EOF
on_attach = function(client, bufnr)
  if client.resolved_capabilities.goto_definition == true then
    vim.api.nvim_buf_set_option(bufnr, 'tagfunc', 'v:lua.vim.lsp.tagfunc')
  end

  if client.resolved_capabilities.document_formatting == true then
    vim.api.nvim_buf_set_option(bufnr, 'formatexpr', 'v:lua.vim.lsp.formatexpr()')
  end

  require('folding').on_attach()
end
EOF

nnoremap <silent> <c-]> <cmd>lua vim.lsp.buf.definition()<CR>
if executable('typescript-language-server')
  lua require'lspconfig'.tsserver.setup{
        \   capabilities = capabilities;
        \   on_attach = on_attach;
        \   filetypes = {"typescript", "typescriptreact", "typescript.tsx"};
        \   flags = {
        \     debounce_text_changes = 500;
        \   };
        \ }
en
if executable('gopls')
  lua require'lspconfig'.gopls.setup{
        \   capabilities = capabilities;
        \   on_attach = on_attach;
        \ }
en
if executable('graphql-lsp')
  lua require'lspconfig'.graphql.setup{
        \   capabilities = capabilities;
        \   on_attach = on_attach;
        \ }
en

nnoremap <Leader>i <cmd>lua vim.lsp.buf.hover()<CR><cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>
inoremap <M-i> <cmd>lua vim.lsp.buf.signature_help()<CR>

" https://github.com/neovim/nvim-lspconfig/wiki/User-contributed-tips#peek-definition
lua <<EOF
local function preview_location_callback(_, method, result)
  if result == nil or vim.tbl_isempty(result) then
    vim.lsp.log.info(method, 'No location found')
    return nil
  end
  if vim.tbl_islist(result) then
    vim.lsp.util.preview_location(result[1])
  else
    vim.lsp.util.preview_location(result)
  end
end

function peek_definition()
  local params = vim.lsp.util.make_position_params()
  return vim.lsp.buf_request(0, 'textDocument/definition', params, preview_location_callback)
end
EOF

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

function! Term()
  call termopen('fish')
  setlocal nonumber norelativenumber scrolloff=0
endfunction

" autocmd BufLeave * if exists('b:term_title') && exists('b:terminal_job_pid') | file `='term/' . b:terminal_job_pid . '/' . b:term_title`

autocmd BufEnter * if &buftype ==# 'terminal' | set so=0 | else | set so=5 | endif
