-- lazy.nvim
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({'git','clone','--filter=blob:none','https://github.com/folke/lazy.nvim.git','--branch=stable',lazypath})
end
vim.opt.rtp:prepend(lazypath)
-- set key of <Leader>
vim.g.mapleader = ' ' -- Required for lazy

-- Disable Copilot's default tab mapping
vim.g.copilot_no_tab_map = true

-- lazy
require('lazy').setup({
  'AndrewRadev/splitjoin.vim',
  'MunifTanjim/nui.nvim',
  'Shougo/echodoc.vim',
  'ThePrimeagen/refactoring.nvim',
  'andymass/vim-matchup',
  'arp242/gopher.vim',
  'base16-project/base16-vim',
  'chrisbra/Recover.vim',
  'cocopon/inspecthi.vim',
  'dag/vim-fish',
  'dart-lang/dart-vim-plugin',
  'dosimple/workspace.vim',
  'echasnovski/mini.bufremove',
  'github/copilot.vim',
  'hrsh7th/cmp-calc',
  'hrsh7th/cmp-nvim-lsp',
  'hrsh7th/cmp-path',
  'hrsh7th/nvim-cmp',
  'hrsh7th/vim-vsnip',
  'j-hui/fidget.nvim',
  'julienvincent/hunk.nvim',
  'junegunn/fzf',
  'junegunn/fzf.vim',
  'kana/vim-submode',
  'lambdalisue/suda.vim',
  'lewis6991/satellite.nvim',
  'mbbill/undotree',
  'neovim/nvim-lspconfig',
  'niklasl/vim-rdf',
  'nvim-lua/plenary.nvim',
  'ojroques/nvim-lspfuzzy',
  'pierreglaser/folding-nvim',
  'plasticboy/vim-markdown',
  'pmizio/typescript-tools.nvim',
  'rhysd/git-messenger.vim',
  'sindrets/diffview.nvim',
  'storyn26383/vim-vue',
  'tomtom/tcomment_vim',
  'tpope/vim-abolish',
  'tpope/vim-fugitive',
  'tpope/vim-sleuth',
  'wakatime/vim-wakatime',
  'zbirenbaum/copilot.lua',
})

-- hunk.nvim
require('hunk').setup()

-- Copilot.nvim
vim.keymap.set('i','<C-f>','copilot#Accept("<CR>")',{expr=true,silent=true,script=true})

-- nvim-cmp
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

-- echodoc
vim.g.echodoc_enable_at_startup=1

-- submode
vim.g.submode_keep_leaving_key=1
vim.g.submode_timeout=0
local enter=vim.fn['submode#enter_with']
local map=vim.fn['submode#map']
enter('winsize','n','','<C-w>>','<C-w>>')
enter('winsize','n','','<C-w><','<C-w><')
enter('winsize','n','','<C-w>+','<C-w>-')
enter('winsize','n','','<C-w>-','<C-w>+')
map('winsize','n','','>','<C-w>>')
map('winsize','n','','<','<C-w><')
map('winsize','n','','+','<C-w>-')
map('winsize','n','','-','<C-w>+')

-- extension of f-function
-- vim.keymap.set('n','f',function() return 'lv$<Esc>/\%V['..string.char(vim.fn.getchar())..']<CR><Plug>(flc)' end,{expr=true})
-- vim.keymap.set('n','F',function() return 'hv0<Esc>?\%V['..string.char(vim.fn.getchar())..']<CR><Plug>(flc)' end,{expr=true})
enter('flc','n','','<Plug>(flc)',':autocmd flc InsertEnter * noh<CR>')
map('flc','n','','n','n')
map('flc','n','','N','N')

-- fzf.vim
function _G.GitGrep(kwd)
  vim.fn['fzf#vim#grep']('git grep --line-number ""',0,{dir=vim.fn.systemlist('git rev-parse --show-toplevel')[1],options='--query='..vim.fn.shellescape(kwd)})
end
vim.keymap.set('n','<Leader>b',':Buffer<CR>',{silent=true})
-- vim.keymap.set('n','<Leader>p',function() vim.fn['fzf#run'](vim.fn['fzf#wrap']({source='ag -l'})) end,{silent=true})
-- 上記のようにするとtable内の関数がluaへの変換でnilになってしまいバグる
vim.keymap.set('n', '<Leader>p',
  [[<Cmd>call fzf#run(fzf#wrap({'source': 'ag -l'}))<CR>]],
  { silent = true, noremap = true })
vim.keymap.set('n','<Leader>g',function() GitGrep('') end,{silent=true})
vim.keymap.set('v','<Leader>g',function() GitGrep(vim.fn.getreg('"')) end,{silent=true})
-- Suppress fzf.vim custom statusline(use lightline)
vim.api.nvim_create_autocmd('User',{pattern='FzfStatusLine',command=':'})

-- go-vim
vim.g.go_template_autocreate=0

-- vim-clang
vim.g.clang_cpp_options='-std=c++0x -stdlib=libc++'

-- vim-markdown
vim.g.vim_markdown_folding_disabled=1

-- satellite.nvim
require('satellite').setup({
  handlers = {
    cursor = { enabled = false };
  };
})

-- fidget
require('fidget').setup({})

-- other custom keymaps
vim.keymap.set('n','<Leader>w','<cmd>w<CR>',{silent=true})
vim.keymap.set('n','<Leader>e','<cmd>enew<CR>',{silent=true})
vim.keymap.set('n','<Leader>q','<cmd>up<CR>:bp | bd #<CR>',{silent=true})
vim.keymap.set('n','<Leader>x','<cmd>q<CR>',{silent=true})
vim.keymap.set('n','<Leader>c','<cmd>enew<CR>:lua Term()<CR>',{silent=true})
vim.keymap.set('n','<Leader>h','60h',{silent=true})
vim.keymap.set('n','<Leader>l','60l',{silent=true})
vim.keymap.set('n','<Leader>k','15k',{silent=true})
vim.keymap.set('n','<Leader>j','15j',{silent=true})
vim.keymap.set('n','<leader>i',function() vim.diagnostic.open_float() end,{silent=true})
vim.keymap.set('n','[d',vim.diagnostic.goto_prev,{silent=true})
vim.keymap.set('n',']d',vim.diagnostic.goto_next,{silent=true})
vim.keymap.set({'n','i'},'<C-j>','<Esc>:noh<CR>',{silent=true})
vim.keymap.set('n','n','nzz')
vim.keymap.set('t','<C-j>','<C-\\><C-n>')
-- vim.keymap.set('v','//','<Esc>/\%V',{remap=true})
function _G.Tabs()
  local tabs=vim.tbl_map(function(t) return t.tabnr end,vim.fn.gettabinfo())
  local current=vim.fn.tabpagenr()
  local others=vim.tbl_filter(function(n) return n~=current end,tabs)
  vim.fn['fzf#run']({source=others,sink=function(nr) vim.cmd('tabn '..nr) end,down='30%'})
end
vim.keymap.set('n','<Leader>t','<cmd>lua Tabs()<CR>',{silent=true})
vim.keymap.set('n','<Leader>n',':tab split<CR>',{silent=true})

-- nvim
vim.cmd('colorscheme mycolor')
vim.cmd('syntax on')
local opt = vim.opt
opt.breakindent = true
opt.breakindentopt = 'sbr'
opt.clipboard = 'unnamedplus'
opt.expandtab = true
opt.foldenable = false
opt.guifont = 'Source Code Pro Regular:h11'
opt.ignorecase = true
opt.infercase = true
opt.laststatus = 0
opt.list = true
opt.listchars = {tab='» ',trail='-',extends='»',precedes='«',nbsp='%'}
opt.matchpairs:append('<:>')
opt.matchtime = 3
opt.mouse = 'a'
opt.number = false
opt.scrolloff = 5
opt.shiftround = true
opt.shiftwidth = 2
opt.showbreak = '>'
opt.showmatch = true
opt.showmode = false
opt.smartcase = true
opt.smartindent = true
opt.tabstop = 2
opt.termguicolors = true
opt.title = true
opt.titlestring = '%{fnamemodify(getcwd(),":t")}: %t'
opt.undofile = true

-- Filetypes
vim.api.nvim_create_autocmd({'BufRead','BufNewFile'},{pattern='*.graphql',command='setfiletype graphql'})

-- nvim colors
-- Change the default background of floating window.
vim.cmd([[hi NormalFloat guibg=#444444 guifg=#ffffff ctermbg=238 ctermfg=7]])
vim.cmd([[hi! link LspSignatureActiveParameter Search]])
-- https://github.com/neovim/neovim/issues/26369#:~:text=look%20into%20the%20ways%20of%20fixing%20that%20cleared%20highlight%20group%20inside%20markdown%20code%20block%20is%20highlighted%20as%20comment.%20because%20it%20falls%20back%20to%20%40text.literal.block.markdown%20which%20falls%20back%20to%20%40text.literal%20which%20is%20linked%20to%20comment.
vim.cmd([[hi! link @text.literal Normal]])

-- Remove all statuslines
if vim.g.gonvim_running then
  vim.o.statusline = '%#Normal# '
end

-- Zoom-in / Zoom-out
function _G.Zoom(amount)
  local current = tonumber(vim.o.guifont:match('%d+$')) or 11
  zoom_set(current + amount)
end

-- Sets the font size to `font_size`
local function zoom_set(size)
  vim.o.guifont = vim.o.guifont:gsub('%d+$','')..size
end
_G.ZoomSet = zoom_set

vim.keymap.set('n','<C-+>',function() Zoom(vim.v.count1) end,{silent=true})
vim.keymap.set('n','<C-->',function() Zoom(-vim.v.count1) end,{silent=true})
vim.keymap.set('n','<C-0>',function() ZoomSet(11) end,{silent=true})

-- lsp
local lspconfig=require('lspconfig')
local capabilities = vim.tbl_deep_extend('force',
  vim.lsp.protocol.make_client_capabilities(),
  require('cmp_nvim_lsp').default_capabilities()
)

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    require('folding').on_attach()

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

-- " nnoremap <silent> <c-]> <cmd>lua vim.lsp.buf.definition()<CR>
-- " if executable('typescript-language-server')
-- "   lua require'lspconfig'.tsserver.setup{
-- "         \   capabilities = capabilities;
-- "         \   on_attach = on_attach;
-- "         \   root_dir = require'lspconfig'.util.root_pattern('tsconfig.json');
-- "         \   filetypes = {'typescript', 'typescriptreact', 'typescript.tsx'};
-- "         \   single_file_support = false;
-- "         \   flags = {
-- "         \     debounce_text_changes = 500;
-- "         \   };
-- "         \ }
-- " en
-- " if executable('tsgo')
-- "   lua vim.lsp.config['tsgo'] = {
-- "         \   cmd = { 'tsgo', 'lsp', '--stdio' },
-- "         \   filetypes = {'typescript', 'typescriptreact', 'typescript.tsx'};
-- "         \   root_markers = { 'tsconfig.json' },
-- "         \ }
-- "   lua vim.lsp.enable('tsgo')
-- " else
require'typescript-tools'.setup{
  settings = {
    tsserver_file_preferences = {
      includeInlayParameterNameHints = "all",
    },
  },
  capabilities = capabilities;
  on_attach = on_attach;
  root_dir = function (fname)
    if require'lspconfig'.util.root_pattern('vue.config.ts', 'vue.config.js', 'nuxt.config.ts', 'nuxt.config.js', 'deno.json')(fname) then
      return nil
    end
    return require'lspconfig'.util.root_pattern('tsconfig.json')(fname)
  end;
  filetypes = {'typescript', 'typescriptreact', 'typescript.tsx'};
  single_file_support = false;
  flags = {
    debounce_text_changes = 500;
  };
}
-- " en
-- if executable('gopls')
if vim.fn.executable('gopls') == 1 then
  require'lspconfig'.gopls.setup{
    capabilities = capabilities;
    on_attach = on_attach;
  }
end
-- if executable('graphql-lsp')
if vim.fn.executable('graphql-lsp') == 1 then
  require'lspconfig'.graphql.setup{
    capabilities = capabilities;
    on_attach = on_attach;
  }
end
-- if executable('deno')
if vim.fn.executable('deno') == 1 then
  require'lspconfig'.denols.setup{
    on_attach = on_attach;
    root_dir = require'lspconfig'.util.root_pattern('deno.json');
    init_options = {
      lint = true;
    };
  }
end
-- if executable('pylsp')
if vim.fn.executable('pylsp') == 1 then
  require'lspconfig'.pylsp.setup{
    on_attach = on_attach;
  }
end
-- if executable('rust-analyzer')
if vim.fn.executable('rust-analyzer') == 1 then
  require'lspconfig'.rust_analyzer.setup{
    on_attach = on_attach;
  }
end
-- " if executable('vue-language-server')
-- "   lua require 'lspconfig'.volar.setup{
-- "         \   filetypes = { 'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue', 'json' };
-- "         \   root_dir = function (fname)
-- "         \     local root_dir = require'lspconfig'.util.root_pattern('package.json')(fname)
-- "         \     if root_dir == nil then
-- "         \       return nil
-- "         \     end
-- "         \     local package_json = vim.fn.json_decode(vim.fn.readfile(root_dir .. '/package.json'))
-- "         \     if package_json.dependencies.vue then
-- "         \       if string.find(package_json.dependencies.vue, "^%^?3") then
-- "         \         return root_dir
-- "         \       end
-- "         \     end
-- "         \     if package_json.dependencies.nuxt then
-- "         \       if string.find(package_json.dependencies.nuxt, "^%^?3") then
-- "         \         return root_dir
-- "         \       end
-- "         \     end
-- "         \     return nil
-- "         \   end;
-- "         \   single_file_support = false;
-- "         \   on_attach = on_attach;
-- "         \ }
-- " en
-- if executable('typescript-language-server')
--   " " こっちの方法だとエラー箇所がずれる問題が起きた
--   " lua require'lspconfig'.volar.setup{
--   "       \   capabilities = capabilities;
--   "       \   on_attach = on_attach;
--   "       \ }
--   " lua local function organize_imports()
--   "       \   local params = {
--   "       \     command = "_typescript.organizeImports",
--   "       \     arguments = { vim.api.nvim_buf_get_name(0) },
--   "       \     title = "",
--   "       \   }
--   "       \   vim.lsp.buf.execute_command(params)
--   "       \ end
--   "       \ require'lspconfig'.tsserver.setup{
--   "       \   capabilities = capabilities;
--   "       \   on_attach = on_attach;
--   "       \   root_dir = require'lspconfig'.util.root_pattern('tsconfig.json');
--   "       \   filetypes = {'typescript', 'typescriptreact', 'typescript.tsx', 'vue'};
--   "       \   single_file_support = false;
--   "       \   flags = {
--   "       \     debounce_text_changes = 500;
--   "       \   };
--   "       \   commands = {
--   "       \     OrganizeImports = {
--   "       \       organize_imports,
--   "       \     },
--   "       \   },
--   "       \   init_options = {
--   "       \     plugins = {
--   "       \       {
--   "       \         name = "@vue/typescript-plugin",
--   "       \         location = "/usr/lib/node_modules/@vue/typescript-plugin",
--   "       \         languages = { "vue" },
--   "       \       },
--   "       \     },
--   "       \   },
--   "       \ }
--   " lua require'lspconfig'.volar.setup{
--   "       \   capabilities = capabilities;
--   "       \   on_attach = on_attach;
--   "       \   filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" },
--   "       \   root_dir = require'lspconfig'.util.root_pattern('vue.config.ts', 'vue.config.js', 'nuxt.config.ts', 'nuxt.config.js');
--   "       \   init_options = {
--   "       \     vue = {
--   "       \       hybridMode = false,
--   "       \     },
--   "       \   },
--   "       \ }
-- en
-- if executable('vls')
if vim.fn.executable('vls') == 1 then
  require 'lspconfig'.vuels.setup{
    filetypes = { 'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue', 'json' };
    root_dir = function (fname)
      local root_dir = require'lspconfig'.util.root_pattern('package.json')(fname)
      if root_dir == nil then
        return nil
      end
      local package_json = vim.fn.json_decode(vim.fn.readfile(root_dir .. '/package.json'))
      if package_json.dependencies.vue then
        if string.find(package_json.dependencies.vue, "^%^?2") then
          return root_dir
        end
      end
      if package_json.dependencies.nuxt then
        if string.find(package_json.dependencies.nuxt, "^%^?2") then
          return root_dir
        end
      end
      return nil
    end;
    single_file_support = false;
    on_attach = on_attach;
  }
end

vim.api.nvim_create_user_command('LspDiagnostics',function() vim.diagnostic.setqflist() end,{range=true})
vim.api.nvim_create_user_command('LspFormatting',function() vim.lsp.buf.format() end,{range=true})
vim.api.nvim_create_user_command('LspRename',function() vim.lsp.buf.rename() end,{range=true})
vim.api.nvim_create_user_command('LspIncomingCalls',function() vim.lsp.buf.incoming_calls() end,{range=true})
vim.api.nvim_create_user_command('LspOutgoingCalls',function() vim.lsp.buf.outgoing_calls() end,{range=true})
vim.api.nvim_create_user_command('LspTypeDefinition',function() vim.lsp.buf.type_definition() end,{range=true})
vim.api.nvim_create_user_command('LspImplementation',function() vim.lsp.buf.implementation() end,{range=true})
vim.api.nvim_create_user_command('LspHover',function() vim.lsp.buf.hover() end,{range=true})
vim.api.nvim_create_user_command('LspSignatureHelp',function() vim.lsp.buf.signature_help() end,{range=true})
vim.api.nvim_create_user_command('LspDefinition',function() vim.lsp.buf.definition() end,{range=true})
vim.api.nvim_create_user_command('LspDocumentSymbol',function() vim.lsp.buf.document_symbol() end,{range=true})
vim.api.nvim_create_user_command('LspWorkspaceSymbol',function() vim.lsp.buf.workspace_symbol() end,{range=true})
vim.api.nvim_create_user_command('LspCodeAction',function() vim.lsp.buf.code_action() end,{range=true})

-- https://github.com/neovim/nvim-lspconfig/wiki/User-contributed-tips#peek-definition
local function preview_location_callback(_,method,result)
  if not result or vim.tbl_isempty(result) then vim.lsp.log.info(method,'No location found');return end
  if vim.tbl_islist(result) then
    vim.lsp.util.preview_location(result[1])
  else
    vim.lsp.util.preview_location(result)
  end
end
function _G.peek_definition()
  local params=vim.lsp.util.make_position_params()
  vim.lsp.buf_request(0,'textDocument/definition',params,preview_location_callback)
end

-- Hide NetRW buffer
vim.api.nvim_create_autocmd('FileType',{pattern='netrw',command='setlocal bufhidden=wipe'})

-- Assembly specific settings
local asm_grp=vim.api.nvim_create_augroup('asmfile',{clear=true})
vim.api.nvim_create_autocmd('FileType',{group=asm_grp,pattern='asm',callback=function()
  vim.opt_local.shiftwidth=8
  vim.opt_local.expandtab=false
  vim.opt_local.tabstop=8
end})

-- Go specific settings
local go_grp=vim.api.nvim_create_augroup('gofile',{clear=true})
vim.api.nvim_create_autocmd('FileType',{group=go_grp,pattern='go',callback=function()
  vim.opt_local.shiftwidth=2
  vim.opt_local.expandtab=false
  vim.opt_local.tabstop=2
  vim.opt_local.formatprg='goimports'
end})

-- configs to insert automatically list prefix on markdown files
local config_grp=vim.api.nvim_create_augroup('config',{clear=true})
vim.api.nvim_create_autocmd('FileType',{group=config_grp,pattern='markdown',callback=function()
  vim.keymap.set('i','<CR>',function()
    local l=vim.fn.getline('.')
    -- if l:match('^%s*-\s') then return '<CR>- ' end
    -- if l:match('^%s*\*\s') then return '<CR>* ' end
    return '<CR>'
  end,{buffer=true,expr=true})
  vim.keymap.set('n','o',function()
    local l=vim.fn.getline('.')
    -- if l:match('^%s*-\s') then return 'o- ' end
    -- if l:match('^%s*\*\s') then return 'o* ' end
    return 'o'
  end,{buffer=true,expr=true})
end})
vim.api.nvim_create_autocmd({'BufNewFile','BufRead'},{group=config_grp,pattern='*.es6',command='set filetype=javascript'})

-- config of vim -b option. it enables read binary for vim
local binary_grp=vim.api.nvim_create_augroup('BinaryXXD',{clear=true})
vim.api.nvim_create_autocmd('BufReadPre',{group=binary_grp,pattern='*.bin',command='let &binary =1'})
vim.api.nvim_create_autocmd('BufReadPost',{group=binary_grp,pattern='*',callback=function()
  if vim.o.binary then vim.cmd('%!xxd -g 1');vim.cmd('set ft=xxd') end
end})
vim.api.nvim_create_autocmd('BufWritePre',{group=binary_grp,pattern='*',callback=function() if vim.o.binary then vim.cmd('%!xxd -r') end end})
vim.api.nvim_create_autocmd('BufWritePost',{group=binary_grp,pattern='*',callback=function() if vim.o.binary then vim.cmd('silent %!xxd -g 1');vim.cmd('set nomod') end end})

-- Open terminal on new buffer
local function buf_byte()
  local byte=vim.fn.line2byte(vim.fn.line('$')+1)
  return byte==-1 and 0 or byte-1
end
function _G.Term()
  vim.fn.termopen('fish')
  vim.cmd('setlocal nonumber norelativenumber scrolloff=0 nolist')
end
vim.api.nvim_create_autocmd('VimEnter',{callback=function()
  if vim.fn.expand('%')=='' and buf_byte()==0 then Term() end
end})
vim.api.nvim_create_autocmd('BufEnter',{callback=function()
  if vim.bo.buftype=='terminal' then
    vim.opt_local.scrolloff=0
  else
    vim.opt_local.scrolloff=5
  end
end})
-- vim.api.nvim_create_autocmd('BufLeave',{callback=function()
--   if vim.b.term_title and vim.b.terminal_job_pid then
--     vim.cmd('file term/'..vim.b.terminal_job_pid..'/'..vim.b.term_title)
--   end
-- end}) -- comment outed?

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
