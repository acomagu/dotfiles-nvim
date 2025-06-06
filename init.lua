-- Plugin manager setup using lazy.nvim
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({'git','clone','--filter=blob:none','https://github.com/folke/lazy.nvim.git','--branch=stable',lazypath})
end
vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = ' '

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
})

vim.opt.rtp:append('~/.local/src/github.com/acomagu/jump-to-prompt.nvim')

require('hunk').setup()
require('satellite').setup({handlers={cursor={enabled=false}}})
require('fidget').setup({})

local opt = vim.opt
opt.breakindent = true
opt.breakindentopt = 'sbr'
opt.clipboard = 'unnamedplus'
opt.expandtab = true
opt.ignorecase = true
opt.infercase = true
opt.list = true
opt.listchars = {tab='» ',trail='-',extends='»',precedes='«',nbsp='%'}
opt.mouse = 'a'
opt.scrolloff = 5
opt.shiftwidth = 2
opt.shiftround = true
opt.showbreak = '>'
opt.showmatch = true
opt.smartcase = true
opt.smartindent = true
opt.tabstop = 2
opt.termguicolors = true
opt.title = true
opt.undofile = true
opt.laststatus = 0
opt.guifont = 'Source Code Pro Regular:h11'
opt.matchpairs:append('<:>')
opt.matchtime = 3
opt.number = false
opt.foldenable = false
opt.showmode = false
opt.titlestring = '%{fnamemodify(getcwd(),":t")}: %t'

vim.cmd([[hi NormalFloat guibg=#444444 guifg=#ffffff ctermbg=238 ctermfg=7]])
vim.cmd([[hi! link LspSignatureActiveParameter Search]])
vim.cmd([[hi! link @text.literal Normal]])

if vim.g.gonvim_running then
  vim.o.statusline = '%#Normal# '
end

local function zoom_set(size)
  vim.o.guifont = vim.o.guifont:gsub('%d+$','')..size
end
_G.ZoomSet = zoom_set
function _G.Zoom(amount)
  local current = tonumber(vim.o.guifont:match('%d+$')) or 11
  zoom_set(current + amount)
end
vim.keymap.set('n','<C-+>',function() Zoom(vim.v.count1) end,{silent=true})
vim.keymap.set('n','<C-->',function() Zoom(-vim.v.count1) end,{silent=true})
vim.keymap.set('n','<C-0>',function() ZoomSet(11) end,{silent=true})

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

function _G.GitGrep(kwd)
  vim.fn['fzf#vim#grep']('git grep --line-number ""',0,{dir=vim.fn.systemlist('git rev-parse --show-toplevel')[1],options='--query='..vim.fn.shellescape(kwd)})
end
vim.keymap.set('n','<Leader>b',':Buffer<CR>',{silent=true})
vim.keymap.set('n','<Leader>p',function() vim.fn['fzf#run'](vim.fn['fzf#wrap']({source='ag -l'})) end,{silent=true})
vim.keymap.set('n','<Leader>g',function() GitGrep('') end,{silent=true})
vim.keymap.set('v','<Leader>g',function() GitGrep(vim.fn.getreg('"')) end,{silent=true})

function _G.Tabs()
  local tabs=vim.tbl_map(function(t) return t.tabnr end,vim.fn.gettabinfo())
  local current=vim.fn.tabpagenr()
  local others=vim.tbl_filter(function(n) return n~=current end,tabs)
  vim.fn['fzf#run']({source=others,sink=function(nr) vim.cmd('tabn '..nr) end,down='30%'})
end
vim.keymap.set('n','<Leader>t','<cmd>lua Tabs()<CR>',{silent=true})
vim.keymap.set('n','<Leader>n',':tab split<CR>',{silent=true})

vim.keymap.set('i','<C-f>','copilot#Accept("<CR>")',{expr=true,silent=true,script=true})

local cmp=require('cmp')
cmp.setup({
  preselect=cmp.PreselectMode.None,
  mapping={
    ['<Tab>']=cmp.mapping.select_next_item(),
    ['<S-Tab>']=cmp.mapping.select_prev_item(),
    ['<C-x><C-o>']=cmp.mapping.complete(),
    ['<CR>']=cmp.mapping.confirm({select=false}),
  },
  snippet={expand=function(args) vim.fn['vsnip#anonymous'](args.body) end},
  sources={{name='calc'},{name='cody'},{name='nvim_lsp'},{name='path'},{name='vsnip'}},
  view={entries='native'},
  window={documentation={max_width=100}},
})

vim.g.echodoc_enable_at_startup=1
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
-- vim.keymap.set('n','f',function() return 'lv$<Esc>/\%V['..string.char(vim.fn.getchar())..']<CR><Plug>(flc)' end,{expr=true})
-- vim.keymap.set('n','F',function() return 'hv0<Esc>?\%V['..string.char(vim.fn.getchar())..']<CR><Plug>(flc)' end,{expr=true})
enter('flc','n','','<Plug>(flc)',':autocmd flc InsertEnter * noh<CR>')
map('flc','n','','n','n')
map('flc','n','','N','N')

vim.g.go_template_autocreate=0
vim.g.clang_cpp_options='-std=c++0x -stdlib=libc++'
vim.g.vim_markdown_folding_disabled=1

local function buf_byte()
  local byte=vim.fn.line2byte(vim.fn.line('$')+1)
  return byte==-1 and 0 or byte-1
end
function _G.Term()
  vim.fn.termopen('fish',{on_stdout=require('jump-to-prompt').on_stdout})
  vim.cmd('setlocal nonumber norelativenumber scrolloff=0 nolist')
end
vim.api.nvim_create_autocmd('VimEnter',{callback=function()
  if vim.fn.expand('%')=='' and buf_byte()==0 then Term() end
end})
vim.keymap.set('n',']]', '', {silent=true,callback=require('jump-to-prompt').jump_to_next_prompt})
vim.keymap.set('n','[[','',{silent=true,callback=require('jump-to-prompt').jump_to_prev_prompt})
vim.api.nvim_create_autocmd('BufEnter',{callback=function()
  if vim.bo.buftype=='terminal' then
    vim.opt_local.scrolloff=0
  else
    vim.opt_local.scrolloff=5
  end
end})
vim.api.nvim_create_autocmd('BufLeave',{callback=function()
  if vim.b.term_title and vim.b.terminal_job_pid then
    vim.cmd('file term/'..vim.b.terminal_job_pid..'/'..vim.b.term_title)
  end
end})

vim.api.nvim_create_autocmd('User',{pattern='FzfStatusLine',command=':'})

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

local binary_grp=vim.api.nvim_create_augroup('BinaryXXD',{clear=true})
vim.api.nvim_create_autocmd('BufReadPre',{group=binary_grp,pattern='*.bin',command='let &binary =1'})
vim.api.nvim_create_autocmd('BufReadPost',{group=binary_grp,pattern='*',callback=function()
  if vim.o.binary then vim.cmd('%!xxd -g 1');vim.cmd('set ft=xxd') end
end})
vim.api.nvim_create_autocmd('BufWritePre',{group=binary_grp,pattern='*',callback=function() if vim.o.binary then vim.cmd('%!xxd -r') end end})
vim.api.nvim_create_autocmd('BufWritePost',{group=binary_grp,pattern='*',callback=function() if vim.o.binary then vim.cmd('silent %!xxd -g 1');vim.cmd('set nomod') end end})

vim.api.nvim_create_autocmd('FileType',{pattern='netrw',command='setlocal bufhidden=wipe'})

local asm_grp=vim.api.nvim_create_augroup('asmfile',{clear=true})
vim.api.nvim_create_autocmd('FileType',{group=asm_grp,pattern='asm',callback=function()
  vim.opt_local.shiftwidth=8
  vim.opt_local.expandtab=false
  vim.opt_local.tabstop=8
end})

local go_grp=vim.api.nvim_create_augroup('gofile',{clear=true})
vim.api.nvim_create_autocmd('FileType',{group=go_grp,pattern='go',callback=function()
  vim.opt_local.shiftwidth=2
  vim.opt_local.expandtab=false
  vim.opt_local.tabstop=2
  vim.opt_local.formatprg='goimports'
end})

local lspconfig=require('lspconfig')
local capabilities=vim.tbl_deep_extend('force',vim.lsp.protocol.make_client_capabilities(),require('cmp_nvim_lsp').default_capabilities())
local function on_attach(_,bufnr)
  require('folding').on_attach()
  local opts={buffer=bufnr}
  vim.keymap.set('n','gD',vim.lsp.buf.declaration,opts)
  vim.keymap.set('n','gd',vim.lsp.buf.definition,opts)
  vim.keymap.set('n','K',vim.lsp.buf.hover,opts)
  vim.keymap.set('n','gi',vim.lsp.buf.implementation,opts)
  vim.keymap.set('n','<M-i>',vim.lsp.buf.signature_help,opts)
  vim.keymap.set('i','<M-i>',vim.lsp.buf.signature_help,opts)
  vim.keymap.set('n','<leader>wa',vim.lsp.buf.add_workspace_folder,opts)
  vim.keymap.set('n','<leader>wr',vim.lsp.buf.remove_workspace_folder,opts)
  vim.keymap.set('n','<leader>wl',function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end,opts)
  vim.keymap.set('n','<leader>D',vim.lsp.buf.type_definition,opts)
  vim.keymap.set('n','<leader>rn',vim.lsp.buf.rename,opts)
  vim.keymap.set({'n','v'},'<leader>ca',vim.lsp.buf.code_action,opts)
  vim.keymap.set('n','gr',vim.lsp.buf.references,opts)
  vim.keymap.set('n','<leader>=',function() vim.lsp.buf.format{async=true} end,opts)
end

vim.api.nvim_create_autocmd('LspAttach',{group=vim.api.nvim_create_augroup('UserLspConfig',{}),callback=function(ev)
  vim.bo[ev.buf].omnifunc='v:lua.vim.lsp.omnifunc'
end})

local servers={tsserver='typescript-language-server',gopls='gopls',graphql='graphql-lsp',denols='deno',pylsp='pylsp',rust_analyzer='rust-analyzer',vuels='vls'}
for server,bin in pairs(servers) do
  if vim.fn.executable(bin)==1 then
    lspconfig[server].setup{capabilities=capabilities,on_attach=on_attach}
  end
end

require('typescript-tools').setup{
  settings={tsserver_file_preferences={includeInlayParameterNameHints='all'}},
  capabilities=capabilities,
  on_attach=on_attach,
  root_dir=function(fname)
    if lspconfig.util.root_pattern('vue.config.ts','vue.config.js','nuxt.config.ts','nuxt.config.js','deno.json')(fname) then return nil end
    return lspconfig.util.root_pattern('tsconfig.json')(fname)
  end,
  filetypes={'typescript','typescriptreact','typescript.tsx'},
  single_file_support=false,
  flags={debounce_text_changes=500},
}

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

vim.api.nvim_create_user_command('Qf',function(opts)
  local start_line=vim.fn.line("'<")
  local end_line=vim.fn.line("'>")
  local lines=vim.fn.getline(start_line,end_line)
  -- local gqlfmt='%E%*\sError\ %n:\ %m,%Z%*\sat\ %f:%l:%c'
  -- local tscfmt='%E%f(%l\,%c):\ error\ %m,%C\ \ %m'
  vim.ui.select({'graphql-codegen','tsc'},{},function(choice)
    local efm=choice=='graphql-codegen' and gqlfmt or choice=='tsc' and tscfmt or nil
    if not efm then vim.notify('error'); return end
    vim.fn.setqflist({},'r',{lines=lines,efm=efm})
    vim.cmd('copen')
  end)
end,{range=true})

vim.cmd('colorscheme mycolor')
vim.cmd('syntax on')
vim.api.nvim_create_autocmd({'BufRead','BufNewFile'},{pattern='*.graphql',command='setfiletype graphql'})
