scriptencoding utf-8

let g:copilot_no_tab_map = v:true

set packpath=$XDG_DATA_HOME/nvim/site

" minpac
packadd minpac
call minpac#init()
call minpac#add('AndrewRadev/splitjoin.vim')
call minpac#add('MunifTanjim/nui.nvim') " for hunk.nvim
" call minpac#add('sourcegraph/sg.nvim')
call minpac#add('Shougo/echodoc.vim')
call minpac#add('ThePrimeagen/refactoring.nvim')
call minpac#add('andymass/vim-matchup')
call minpac#add('arp242/gopher.vim')
call minpac#add('base16-project/base16-vim')
call minpac#add('chrisbra/Recover.vim')
call minpac#add('cocopon/inspecthi.vim')
call minpac#add('dag/vim-fish')
call minpac#add('dart-lang/dart-vim-plugin')
call minpac#add('dosimple/workspace.vim')
call minpac#add('echasnovski/mini.bufremove')
call minpac#add('github/copilot.vim')
call minpac#add('hrsh7th/cmp-calc')
call minpac#add('hrsh7th/cmp-nvim-lsp')
call minpac#add('hrsh7th/cmp-path')
call minpac#add('hrsh7th/nvim-cmp')
call minpac#add('hrsh7th/nvim-insx')
call minpac#add('hrsh7th/vim-vsnip')
call minpac#add('j-hui/fidget.nvim')
call minpac#add('julienvincent/hunk.nvim')
call minpac#add('junegunn/fzf')
call minpac#add('junegunn/fzf.vim')
call minpac#add('k-takata/minpac', {'type': 'opt'})
call minpac#add('kana/vim-submode')
call minpac#add('lambdalisue/suda.vim')
call minpac#add('lewis6991/satellite.nvim')
call minpac#add('mbbill/undotree')
call minpac#add('mfussenegger/nvim-dap')
call minpac#add('microsoft/vscode-js-debug', {'type': 'opt', 'do': '!npm i --legacy-peer-deps && npx gulp vsDebugServerBundle && mv dist out'})
call minpac#add('neovim/nvim-lspconfig')
call minpac#add('niklasl/vim-rdf')
call minpac#add('nvim-lua/plenary.nvim') " for typescript-tools.nvim
call minpac#add('ojroques/nvim-lspfuzzy')
call minpac#add('pierreglaser/folding-nvim')
call minpac#add('plasticboy/vim-markdown')
call minpac#add('pmizio/typescript-tools.nvim')
call minpac#add('rhysd/git-messenger.vim')
call minpac#add('sindrets/diffview.nvim')
call minpac#add('storyn26383/vim-vue')
call minpac#add('tomtom/tcomment_vim')
call minpac#add('tpope/vim-abolish')
call minpac#add('tpope/vim-fugitive')
call minpac#add('tpope/vim-sleuth')
call minpac#add('wakatime/vim-wakatime')
" call minpac#add('yetone/avante.nvim') # need some deps
packloadall

set rtp+=~/.local/src/github.com/acomagu/jump-to-prompt.nvim

" hunk.nvim
lua require('hunk').setup()

" set key of <Leader>
let mapleader = "\<Space>"

" copilot-vim
imap <silent><script><expr> <C-f> copilot#Accept("\<CR>")

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
    { name = 'cody' },
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

" insx
lua <<EOF
require('insx').add(
  '<CR>',
  require('insx.recipe.fast_break')({
    open_pat = [[```\w*]],
    close_pat = '```',
    indent = 0,
  })
)

-- html tag like.
require('insx').add(
  '<CR>',
  require('insx.recipe.fast_break')({
    open_pat = require('insx').helper.search.Tag.Open,
    close_pat = require('insx').helper.search.Tag.Close,
  })
)
EOF

" nvim-dap
lua <<EOF
local exts = {
  'javascript',
  'typescript',
  'javascriptreact',
  'typescriptreact',
  -- using pwa-chrome
  'vue',
  'svelte',
}

local dap = require('dap')

dap.adapters["pwa-node"] = {
  type = "server",
  host = "127.0.0.1",
  port = "${port}",
  executable = {
    command = 'node',
    args = {
      os.getenv('XDG_DATA_HOME') .. '/nvim/site/pack/minpac/opt/vscode-js-debug/out/src/vsDebugServer.js',
      "${port}",
      "127.0.0.1",
    },
  }
}

dap.configurations.typescript = {
  {
    type = 'pwa-node',
    request = 'launch',
    name = 'Launch Current File (pwa-node)',
    cwd = "${workspaceFolder}",
    args = { '${file}' },
    sourceMaps = true,
    protocol = 'inspector',
    console = 'integratedTerminal',
  },
  {
    type = 'pwa-node',
    request = 'launch',
    name = 'Launch Current File (pwa-node with ts-node)',
    cwd = "${workspaceFolder}",
    runtimeArgs = { '--loader', 'ts-node/esm' },
    runtimeExecutable = 'node',
    args = { '${file}' },
    sourceMaps = true,
    skipFiles = { '<node_internals>/**', 'node_modules/**' },
    resolveSourceMapLocations = {
      "${workspaceFolder}/**",
      "!**/node_modules/**",
    },
    console = 'integratedTerminal',
  },
  {
    type = 'pwa-node',
    request = 'launch',
    name = 'Launch Current File 2',
    program = '${file}',
    cwd = "${workspaceFolder}",
    skipFiles = { '<node_internals>/**', '${workspaceFolder}/node_modules/**' },
    console = 'integratedTerminal',
  },
  {
    type = 'pwa-node',
    request = 'launch',
    name = 'Launch Current File (pwa-node with deno)',
    cwd = "${workspaceFolder}",
    runtimeArgs = { 'run', '--inspect-brk', '--allow-all', '${file}' },
    runtimeExecutable = 'deno',
    attachSimplePort = 9229,
  },
  {
    type = 'pwa-node',
    request = 'launch',
    name = 'Launch Test Current File (pwa-node with jest)',
    cwd = "${workspaceFolder}",
    runtimeArgs = { '${workspaceFolder}/node_modules/.bin/jest' },
    runtimeExecutable = 'node',
    args = { '${file}', '--coverage', 'false'},
    rootPath = '${workspaceFolder}',
    sourceMaps = true,
    console = 'integratedTerminal',
    internalConsoleOptions = 'neverOpen',
    skipFiles = { '<node_internals>/**', 'node_modules/**' },
  },
  {
    type = 'pwa-node',
    request = 'launch',
    name = 'Launch Test Current File (pwa-node with vitest)',
    cwd = "${workspaceFolder}",
    program = '${workspaceFolder}/node_modules/vitest/vitest.mjs',
    args = { '--inspect-brk', '--threads', 'false', 'run', '${file}' },
    autoAttachChildProcesses = true,
    smartStep = true,
    console = 'integratedTerminal',
    skipFiles = { '<node_internals>/**', 'node_modules/**' },
  },
  {
    type = 'pwa-node',
    request = 'launch',
    name = 'Launch Test Current File (pwa-node with deno)',
    cwd = "${workspaceFolder}",
    runtimeArgs = { 'test', '--inspect-brk', '--allow-all', '${file}' },
    runtimeExecutable = 'deno',
    attachSimplePort = 9229,
  },
  {
    type = 'pwa-node',
    request = 'launch',
    name = 'Launch Test Current File (pwa-node with deno)',
    cwd = "${workspaceFolder}",
    runtimeArgs = { 'test', '--inspect-brk', '--allow-all', '${file}' },
    runtimeExecutable = 'deno',
    attachSimplePort = 9229,
  },
  {
    type = 'pwa-node',
    request = 'launch',
    name = 'Test (npm run test v2)',
    cwd = "${workspaceFolder}",
    runtimeExecutable = 'npm',
    sourceMaps = true,
    rootPath = "${workspaceFolder}",
    runtimeArgs = { 'run', 'test' },
    console = "integratedTerminal",
  },
  {
    type = 'pwa-node',
    request = 'attach',
    name = 'Attach Program (pwa-node)',
    cwd = "${workspaceFolder}",
    processId = require('dap.utils').pick_process,
    skipFiles = { '<node_internals>/**' },
  },
}
dap.configurations.javascript = dap.configurations.typescript
dap.configurations.javascriptreact = dap.configurations.typescript
dap.configurations.typescriptreact = dap.configurations.typescript
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
nnoremap <silent> <Leader>b :Buffer<CR>
nnoremap <silent> <Leader>p :call fzf#run(fzf#wrap({'source': 'ag -l'}))<CR>
nnoremap <silent> <Leader>g :call GitGrep("")<CR>
vnoremap <silent> <Leader>g y:call GitGrep(@")<CR>

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

" satellite-nvim
lua require('satellite').setup({
      \   handlers = {
      \     cursor = { enabled = false };
      \   };
      \ })

" fidget
lua require('fidget').setup({})

" other custom keymaps
nnoremap <silent> <Leader>w :w<CR>
nnoremap <silent> <Leader>e :enew<CR>
nnoremap <silent> <Leader>q :up<CR>:bp \| bd #<CR>
" nnoremap <silent> <Leader>q :lua require('mini.bufremove').delete()<CR>
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
colorscheme mycolor
syntax on
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
set noshowmode
set scrolloff=5
set shiftround
set shiftwidth=2
set showbreak=>
set showmatch
set smartcase
set smartindent
set tabstop=2
set termguicolors
set title
set titlestring=%{fnamemodify(getcwd(),\ ':t')}:\ %t
set undofile

" Filetypes
au BufRead,BufNewFile *.graphql setfiletype graphql

" nvim colors
" Change the default background of floating window.
hi NormalFloat guibg=#444444 guifg=#ffffff ctermbg=238 ctermfg=7
hi! link LspSignatureActiveParameter Search
" https://github.com/neovim/neovim/issues/26369#:~:text=look%20into%20the%20ways%20of%20fixing%20that%20cleared%20highlight%20group%20inside%20markdown%20code%20block%20is%20highlighted%20as%20comment.%20because%20it%20falls%20back%20to%20%40text.literal.block.markdown%20which%20falls%20back%20to%20%40text.literal%20which%20is%20linked%20to%20comment.
hi! link @text.literal Normal

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
noremap <silent> <leader>i :lua vim.diagnostic.open_float()<CR>
noremap <silent> [d <cmd>lua vim.diagnostic.goto_prev()<CR>
noremap <silent> ]d <cmd>lua vim.diagnostic.goto_next()<CR>

" nvim_lsp

" Enlarge the capabilities powered by nvim-cmp.
lua <<EOF
local capabilities = vim.tbl_deep_extend('force',
  vim.lsp.protocol.make_client_capabilities(),
  require('cmp_nvim_lsp').default_capabilities()
)
on_attach = function(client, bufnr)
  -- if client.resolved_capabilities.goto_definition == true then
  --   vim.api.nvim_buf_set_option(bufnr, 'tagfunc', 'v:lua.vim.lsp.tagfunc')
  -- end

  -- if client.resolved_capabilities.document_formatting == true then
  --   vim.api.nvim_buf_set_option(bufnr, 'formatexpr', 'v:lua.vim.lsp.formatexpr()')
  -- end

  require('folding').on_attach()

  -- Set diagnostics to quickfix.
  -- do
  --   local default_handler = vim.lsp.handlers['textDocument/publishDiagnostics']
  --   vim.lsp.handlers['textDocument/publishDiagnostics'] = function(err, method, result, client_id, bufnr, config)
  --     default_handler(err, method, result, client_id, bufnr, config)
  --     vim.diagnostic.setqflist({ open = false })
  --   end
  -- end

  -- local map = function(type, key, value)
  --   vim.api.nvim_buf_set_keymap(0, type, key, value, {noremap = true, silent = true});
  -- end
  -- map('i', '<M-i>', '<cmd>lua vim.lsp.buf.signature_help()<CR>')
  -- map('n', '<M-i>', '<cmd>lua vim.lsp.buf.signature_help()<CR>')
  -- map('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>')
  -- map('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>')
  -- map('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>')
  -- map('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<CR>')
  -- map('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>')
  -- map('n', 'gt', '<cmd>lua vim.lsp.buf.type_definition()<CR>')
  -- map('n', '<leader>i', '<cmd>lua vim.diagnostic.open_float()<CR>')
  -- map('n', '<leader>=',  '<cmd>lua vim.lsp.buf.formatting()<CR>')
end

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    -- Enable completion triggered by <c-x><c-o>
    vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

    local opts = { buffer = ev.buf }
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', '<M-i>', vim.lsp.buf.signature_help, opts)
    vim.keymap.set('i', '<M-i>', vim.lsp.buf.signature_help, opts)
    vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, opts)
    vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, opts)
    vim.keymap.set('n', '<leader>wl', function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, opts)
    vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, opts)
    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
    vim.keymap.set({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', '<leader>=', function()
      vim.lsp.buf.format { async = true }
    end, opts)
  end,
})
EOF

" nnoremap <silent> <c-]> <cmd>lua vim.lsp.buf.definition()<CR>
" if executable('typescript-language-server')
"   lua require'lspconfig'.tsserver.setup{
"         \   capabilities = capabilities;
"         \   on_attach = on_attach;
"         \   root_dir = require'lspconfig'.util.root_pattern('tsconfig.json');
"         \   filetypes = {'typescript', 'typescriptreact', 'typescript.tsx'};
"         \   single_file_support = false;
"         \   flags = {
"         \     debounce_text_changes = 500;
"         \   };
"         \ }
" en
" if executable('tsgo')
"   lua vim.lsp.config['tsgo'] = {
"         \   cmd = { 'tsgo', 'lsp', '--stdio' },
"         \   filetypes = {'typescript', 'typescriptreact', 'typescript.tsx'};
"         \   root_markers = { 'tsconfig.json' },
"         \ }
"   lua vim.lsp.enable('tsgo')
" else
  lua require'typescript-tools'.setup{
        \   settings = {
        \     tsserver_file_preferences = {
        \       includeInlayParameterNameHints = "all",
        \     },
        \   },
        \   capabilities = capabilities;
        \   on_attach = on_attach;
        \   root_dir = function (fname)
        \     if require'lspconfig'.util.root_pattern('vue.config.ts', 'vue.config.js', 'nuxt.config.ts', 'nuxt.config.js', 'deno.json')(fname) then
        \       return nil
        \     end
        \     return require'lspconfig'.util.root_pattern('tsconfig.json')(fname)
        \   end;
        \   filetypes = {'typescript', 'typescriptreact', 'typescript.tsx'};
        \   single_file_support = false;
        \   flags = {
        \     debounce_text_changes = 500;
        \   };
        \ }
" en
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
if executable('deno')
  lua require'lspconfig'.denols.setup{
        \   on_attach = on_attach;
        \   root_dir = require'lspconfig'.util.root_pattern('deno.json');
        \   init_options = {
        \     lint = true;
        \   };
        \ }
en
if executable('pylsp')
  lua require'lspconfig'.pylsp.setup{
        \   on_attach = on_attach;
        \ }
en
if executable('rust-analyzer')
  lua require'lspconfig'.rust_analyzer.setup{
        \   on_attach = on_attach;
        \ }
en
" if executable('vue-language-server')
"   lua require 'lspconfig'.volar.setup{
"         \   filetypes = { 'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue', 'json' };
"         \   root_dir = function (fname)
"         \     local root_dir = require'lspconfig'.util.root_pattern('package.json')(fname)
"         \     if root_dir == nil then
"         \       return nil
"         \     end
"         \     local package_json = vim.fn.json_decode(vim.fn.readfile(root_dir .. '/package.json'))
"         \     if package_json.dependencies.vue then
"         \       if string.find(package_json.dependencies.vue, "^%^?3") then
"         \         return root_dir
"         \       end
"         \     end
"         \     if package_json.dependencies.nuxt then
"         \       if string.find(package_json.dependencies.nuxt, "^%^?3") then
"         \         return root_dir
"         \       end
"         \     end
"         \     return nil
"         \   end;
"         \   single_file_support = false;
"         \   on_attach = on_attach;
"         \ }
" en
if executable('typescript-language-server')
  " " こっちの方法だとエラー箇所がずれる問題が起きた
  " lua require'lspconfig'.volar.setup{
  "       \   capabilities = capabilities;
  "       \   on_attach = on_attach;
  "       \ }
  " lua local function organize_imports()
  "       \   local params = {
  "       \     command = "_typescript.organizeImports",
  "       \     arguments = { vim.api.nvim_buf_get_name(0) },
  "       \     title = "",
  "       \   }
  "       \   vim.lsp.buf.execute_command(params)
  "       \ end
  "       \ require'lspconfig'.tsserver.setup{
  "       \   capabilities = capabilities;
  "       \   on_attach = on_attach;
  "       \   root_dir = require'lspconfig'.util.root_pattern('tsconfig.json');
  "       \   filetypes = {'typescript', 'typescriptreact', 'typescript.tsx', 'vue'};
  "       \   single_file_support = false;
  "       \   flags = {
  "       \     debounce_text_changes = 500;
  "       \   };
  "       \   commands = {
  "       \     OrganizeImports = {
  "       \       organize_imports,
  "       \     },
  "       \   },
  "       \   init_options = {
  "       \     plugins = {
  "       \       {
  "       \         name = "@vue/typescript-plugin",
  "       \         location = "/usr/lib/node_modules/@vue/typescript-plugin",
  "       \         languages = { "vue" },
  "       \       },
  "       \     },
  "       \   },
  "       \ }
  " lua require'lspconfig'.volar.setup{
  "       \   capabilities = capabilities;
  "       \   on_attach = on_attach;
  "       \   filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" },
  "       \   root_dir = require'lspconfig'.util.root_pattern('vue.config.ts', 'vue.config.js', 'nuxt.config.ts', 'nuxt.config.js');
  "       \   init_options = {
  "       \     vue = {
  "       \       hybridMode = false,
  "       \     },
  "       \   },
  "       \ }
en
if executable('vls')
  lua require 'lspconfig'.vuels.setup{
        \   filetypes = { 'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue', 'json' };
        \   root_dir = function (fname)
        \     local root_dir = require'lspconfig'.util.root_pattern('package.json')(fname)
        \     if root_dir == nil then
        \       return nil
        \     end
        \     local package_json = vim.fn.json_decode(vim.fn.readfile(root_dir .. '/package.json'))
        \     if package_json.dependencies.vue then
        \       if string.find(package_json.dependencies.vue, "^%^?2") then
        \         return root_dir
        \       end
        \     end
        \     if package_json.dependencies.nuxt then
        \       if string.find(package_json.dependencies.nuxt, "^%^?2") then
        \         return root_dir
        \       end
        \     end
        \     return nil
        \   end;
        \   single_file_support = false;
        \   on_attach = on_attach;
        \ }
en

" nnoremap <Leader>i <cmd>lua vim.lsp.buf.hover()<CR><cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>

command! -range LspDiagnostics lua vim.diagnostic.setqflist()
command! -range LspFormatting lua vim.lsp.buf.formatting()
command! -range LspRename lua vim.lsp.buf.rename()
command! -range LspIncomingCalls lua vim.lsp.buf.incoming_calls()
command! -range LspOutgoingCalls lua vim.lsp.buf.outgoing_calls()
command! -range LspTypeDefinition lua vim.lsp.buf.type_definition()
command! -range LspImplementation lua vim.lsp.buf.implementation()
command! -range LspHover lua vim.lsp.buf.hover()
command! -range LspSignatureHelp lua vim.lsp.buf.signature_help()
command! -range LspDefinition lua vim.lsp.buf.definition()
command! -range LspDocumentSymbol lua vim.lsp.buf.document_symbol()
command! -range LspWorkspaceSymbol lua vim.lsp.buf.workspace_symbol()
command! -range LspCodeAction lua vim.lsp.buf.code_action()

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
  lua vim.fn.termopen('fish', {
        \   on_stdout = require('jump-to-prompt').on_stdout
        \ })
  setlocal nonumber norelativenumber scrolloff=0 nolist
endfunction

lua vim.api.nvim_set_keymap('n', ']]', '', {noremap = true, silent = true, callback = require('jump-to-prompt').jump_to_next_prompt})
lua vim.api.nvim_set_keymap('n', '[[', '', {noremap = true, silent = true, callback = require('jump-to-prompt').jump_to_prev_prompt})


" autocmd BufLeave * if exists('b:term_title') && exists('b:terminal_job_pid') | file `='term/' . b:terminal_job_pid . '/' . b:term_title`

autocmd BufEnter * if &buftype ==# 'terminal' | set so=0 | else | set so=5 | endif

lua <<EOF
vim.api.nvim_create_user_command('Qf', function()
  local start_line = vim.fn.line("'<")
  local end_line = vim.fn.line("'>")

  -- 選択された範囲のテキストを取得
  local selected_lines = vim.fn.getline(start_line, end_line)

  local gqlcodegen_error_format = [[%E%*\sError\ %n:\ %m,%Z%*\sat\ %f:%l:%c]]
  local tsc_error_format = [[%E%f(%l\,%c):\ error\ %m,%C\ \ %m]]

  vim.ui.select({ 'graphql-codegen', 'tsc' }, {}, function(choice)
    local error_format
    if choice == 'graphql-codegen' then
      error_format = gqlcodegen_error_format
    elseif choice == 'tsc' then
      error_format = tsc_error_format
    else
      vim.print('error')
      return
    end
    -- Quickfixリストにエラーメッセージを設定
    vim.fn.setqflist({}, 'r', { lines = selected_lines, efm = error_format })
    vim.cmd('copen')
  end)
end, {
  range = true,
})
EOF
