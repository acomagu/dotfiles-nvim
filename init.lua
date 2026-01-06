-- lazy.nvim
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({ 'git', 'clone', '--filter=blob:none', 'https://github.com/folke/lazy.nvim.git', '--branch=stable', lazypath })
end
vim.opt.rtp:prepend(lazypath)

-- Set Leader key
vim.g.mapleader = ' '

-- General settings
vim.cmd('colorscheme minicomment')
vim.cmd('syntax on')

local opt = vim.opt
opt.breakindent = true
opt.breakindentopt = 'sbr'
-- opt.clipboard = 'unnamedplus'
opt.clipboard = '' -- Copy to clipboard by autocmd.
opt.expandtab = true
opt.foldenable = false
opt.guifont = 'Source Code Pro Regular:h11'
opt.ignorecase = true
opt.infercase = true
opt.laststatus = 0
opt.list = true
opt.listchars = { tab = '» ', trail = '-', extends = '»', precedes = '«', nbsp = '%' }
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

vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    local ev = vim.v.event
    if ev.operator == 'y' then
      local lines = vim.fn.getreg(ev.regname ~= '' and ev.regname or '"', 1, true)
      require('vim.ui.clipboard.osc52').copy('+')(lines, nil)
    end
  end,
})

local osc52 = require('vim.ui.clipboard.osc52')

vim.g.clipboard = {
  name = 'osc52+wl-paste',
  copy = {
    ['+'] = osc52.copy('+'),
    ['*'] = osc52.copy('*'),
  },
  paste = {
    ['+'] = function()
      local ok, out = pcall(vim.fn.systemlist, { 'wl-paste', '--no-newline' })
      if not ok then return { {}, 'v' } end
      return { out, 'v' }  -- {lines, regtype}
    end,
    ['*'] = function()
      return vim.g.clipboard.paste['+']()
    end,
  },
  cache_enabled = false,
}

-- lazy.nvim setup
require('lazy').setup({
  -- Core plugins
  'nvim-lua/plenary.nvim', -- Prerequisite for many plugins
  'neovim/nvim-lspconfig',

  -- UI / UX
  { 'j-hui/fidget.nvim',       tag = 'legacy', config = true },
  { 'lewis6991/satellite.nvim', config = function() require('satellite').setup({ handlers = { cursor = { enabled = false } } }) end },
  { 'Shougo/echodoc.vim',       init = function() vim.g.echodoc_enable_at_startup = 1 end },
  { 'base16-project/base16-vim' },
  { 'cocopon/inspecthi.vim' },
  'MunifTanjim/nui.nvim',

  -- Completion
  {
    'hrsh7th/nvim-cmp',
    dependencies = {
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-calc',
      'hrsh7th/vim-vsnip',
    },
    config = function()
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
          {
            name = 'nvim_lsp',
            option = {
              jtd = {
                keyword_pattern = [[\"\k*\"]],
              },
            },
          },
          { name = 'path' },
          { name = 'vsnip' },
        },
        view = { entries = 'native' },
        window = { documentation = { max_width = 100 } },
      }
    end
  },

  {
    'zbirenbaum/copilot.lua',
    opts = {
      suggestion = {
        trigger_on_accept = false,
        keymap = {
          accept = '<Tab>',
          -- Triggers by M-[
        },
      },
    },
    config = function(main, opts)
      require('copilot').setup(opts)

      local api         = require("copilot.api")
      local progress    = require("fidget.progress")
      local copilot_hdl -- 現在のハンドル（なければ nil）

      api.status.register_status_notification_handler(function(data)
        -- Copilot がコード生成を始めたら …
        if data.status == "InProgress" then
          if not copilot_hdl then
            copilot_hdl = progress.handle.create({
              title      = "Copilot",
              message    = "Loading …",
              lsp_client = { name = "Copilot" }, -- ←グループ名になる
            })
          else
            -- 途中経過を載せたければここで更新
            copilot_hdl:report({ message = data.message or "Thinking …" })
          end

        -- 通常状態 (= 完了) になったらスピナーを閉じる
        elseif data.status == "Normal" then
          if copilot_hdl then copilot_hdl:finish({}) end
          copilot_hdl = nil

        -- それ以外（エラー・オフラインなど）はキャンセル
        else
          if copilot_hdl then copilot_hdl:cancel() end
          copilot_hdl = nil
        end
      end)
    end,
  },

  -- Git
  { 'julienvincent/hunk.nvim', config = true },
  'tpope/vim-fugitive',
  'sindrets/diffview.nvim',
  'rhysd/git-messenger.vim',

  -- Fuzzy Find
  {
    'junegunn/fzf',
    build = function() vim.fn['fzf#install']() end,
  },
  {
    'junegunn/fzf.vim',
    dependencies = { 'junegunn/fzf' },
    config = function()
      function _G.GitGrep(kwd)
        vim.fn['fzf#vim#grep']('git grep --line-number ""', 0, { dir = vim.fn.systemlist('git rev-parse --show-toplevel')[1], options = '--query=' .. vim.fn.shellescape(kwd) })
      end
      vim.keymap.set('n', '<Leader>b', ':Buffers<CR>', { silent = true })
      vim.keymap.set('n', '<Leader>p', [[<Cmd>call fzf#run(fzf#wrap({'source': 'ag -l'}))<CR>]], { silent = true, noremap = true })
      vim.keymap.set('n', '<C-p>', ':Files<CR>', { silent = true, noremap = true })
      vim.keymap.set('n', '<Leader>g', function() GitGrep('') end, { silent = true })
      vim.keymap.set('v', '<Leader>g', function() GitGrep(vim.fn.getreg('"')) end, { silent = true })
      vim.api.nvim_create_autocmd('User', { pattern = 'FzfStatusLine', command = ':' })
    end
  },

  -- Editing aids
  'AndrewRadev/splitjoin.vim',
  'ThePrimeagen/refactoring.nvim',
  'andymass/vim-matchup',
  'tomtom/tcomment_vim',
  'tpope/vim-abolish',
  'tpope/vim-sleuth',
  'mbbill/undotree',
  { 'echasnovski/mini.bufremove' },
  { 'kana/vim-submode',
    init = function()
      vim.g.submode_keep_leaving_key = 1
      vim.g.submode_timeout = 0
    end,
    config = function()
      local enter = vim.fn['submode#enter_with']
      local map = vim.fn['submode#map']
      enter('winsize', 'n', '', '<C-w>>', '<C-w>>')
      enter('winsize', 'n', '', '<C-w><', '<C-w><')
      enter('winsize', 'n', '', '<C-w>+', '<C-w>-')
      enter('winsize', 'n', '', '<C-w>-', '<C-w>+')
      map('winsize', 'n', '', '>', '<C-w>>')
      map('winsize', 'n', '', '<', '<C-w><')
      map('winsize', 'n', '', '+', '<C-w>-')
      map('winsize', 'n', '', '-', '<C-w>+')

      enter('flc', 'n', '', '<Plug>(flc)', ':autocmd flc InsertEnter * noh<CR>')
      map('flc', 'n', '', 'n', 'n')
      map('flc', 'n', '', 'N', 'N')
    end
  },

  -- Filetype specific
  { 'arp242/gopher.vim',       ft = 'go',   init = function() vim.g.go_template_autocreate = 0 end },
  { 'dart-lang/dart-vim-plugin', ft = 'dart' },
  { 'dag/vim-fish',            ft = 'fish' },
  { 'niklasl/vim-rdf',           ft = 'rdf' },
  { 'plasticboy/vim-markdown',   ft = 'markdown', init = function() vim.g.vim_markdown_folding_disabled = 1 end },
  { 'storyn26383/vim-vue',       ft = 'vue' },
  -- {
  --   'pmizio/typescript-tools.nvim',
  --   ft = { 'typescript', 'typescriptreact', 'typescript.tsx' },
  --   dependencies = { 'nvim-lua/plenary.nvim', 'neovim/nvim-lspconfig' },
  --   opts = {
  --     settings = {
  --       tsserver_file_preferences = {
  --         includeInlayParameterNameHints = "all",
  --       },
  --     },
  --     root_dir = function(fname)
  --       if require('lspconfig').util.root_pattern('vue.config.ts', 'vue.config.js', 'nuxt.config.ts', 'nuxt.config.js', 'deno.json')(fname) then
  --         return nil
  --       end
  --       return require('lspconfig').util.root_pattern('tsconfig.json')(fname)
  --     end,
  --     filetypes = { 'typescript', 'typescriptreact', 'typescript.tsx' },
  --     single_file_support = false,
  --     flags = {
  --       debounce_text_changes = 500,
  --     },
  --   },
  -- },

  -- Other
  'lambdalisue/suda.vim',
  'chrisbra/Recover.vim',
  'dosimple/workspace.vim',
  'wakatime/vim-wakatime',
  { 'ojroques/nvim-lspfuzzy',    dependencies = { 'neovim/nvim-lspconfig' } },
  { 'pierreglaser/folding-nvim' },

})

-- LSP Configuration
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(args)
    local client = assert(vim.lsp.get_client_by_id(args.data.client_id))

    -- Below are settings to enable Neovim native auto-completion without nvim-cmp.
    -- if client:supports_method('textDocument/completion') then
    --   -- trigger autocompletion on EVERY keypress. May be slow!
    --   local chars = {}; for i = 32, 126 do table.insert(chars, string.char(i)) end
    --   client.server_capabilities.completionProvider.triggerCharacters = chars
    --
    --   vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = true })
    -- end
    -- -- Tab key to next completion item
    -- -- Tab: 直前が空白以外 or 補完メニュー表示中 → 次候補、それ以外はTab入力
    -- vim.keymap.set("i", "<Tab>", function()
    --   local col = vim.fn.col(".") - 2
    --   local prev_char = vim.fn.getline("."):sub(col + 1, col + 1) -- Luaは1始まり
    --   if prev_char:match("^%s?$") == nil or vim.fn.pumvisible() == 1 then
    --     return "<C-N>"
    --   else
    --     return "<Tab>"
    --   end
    -- end, { expr = true })
    -- 
    -- -- Shift-Tab: 補完メニュー表示中 or 直前が空白以外 → 前候補、それ以外はTab入力
    -- vim.keymap.set("i", "<S-Tab>", function()
    --   local col = vim.fn.col(".") - 2
    --   local prev_char = vim.fn.getline("."):sub(col + 1, col + 1)
    --   if vim.fn.pumvisible() == 1 or prev_char:match("^%s?$") == nil then
    --     return "<C-P>"
    --   else
    --     return "<Tab>"
    --   end
    -- end, { expr = true })
    -- 
    -- -- コマンドラインウィンドウ: Tabでファイル名補完
    -- vim.api.nvim_create_autocmd("CmdwinEnter", {
    --   callback = function()
    --     vim.keymap.set("i", "<Tab>", function()
    --       local col = vim.fn.col(".") - 2
    --       local prev_char = vim.fn.getline("."):sub(col + 1, col + 1)
    --       if prev_char:match("^%s?$") == nil or vim.fn.pumvisible() == 1 then
    --         return "<C-X><C-V>"
    --       else
    --         return "<Tab>"
    --       end
    --     end, { buffer = true, expr = true })
    --   end,
    -- })

    require('folding').on_attach(client, args.buf)
    -- Enable completion triggered by <c-x><c-o>
    vim.bo[args.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

    local opts = { buffer = args.buf }
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    vim.keymap.set({ 'n', 'i' }, '<M-i>', vim.lsp.buf.signature_help, opts)
    vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, opts)
    vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, opts)
    vim.keymap.set('n', '<leader>wl', function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end, opts)
    vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, opts)
    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
    vim.keymap.set({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', '<leader>=', function() vim.lsp.buf.format { async = true } end, opts)
  end,
})

vim.lsp.config('*', {
  capabilities = vim.tbl_deep_extend("force",
    vim.lsp.protocol.make_client_capabilities(),
    require('cmp_nvim_lsp').default_capabilities()
  ),
})

if vim.fn.executable('gopls') == 1 then
  vim.lsp.enable('gopls')
end
if vim.fn.executable('graphql-lsp') == 1 then
  vim.lsp.enable('graphql')
end
if vim.fn.executable('deno') == 1 then
  vim.lsp.config('denols', {
    root_markers = { 'deno.json' },
    init_options = { lint = true },
    workspace_required = true,
  })
  vim.lsp.enable('denols')
end
if vim.fn.executable('pylsp') == 1 then
  vim.lsp.enable('pylsp')
end
if vim.fn.executable('rust-analyzer') == 1 then
  vim.lsp.enable('rust_analyzer')
end
if vim.fn.executable('vls') == 1 then
  vim.lsp.config('vuels', {
    filetypes = { 'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue', 'json' },
    root_dir = function(fname) -- TODO: call on_dir
      local root_dir = require('lspconfig').util.root_pattern('package.json')(fname)
      if root_dir == nil then return nil end
      local package_json_str = table.concat(vim.fn.readfile(root_dir .. '/package.json'), '\n')
      if package_json_str == '' then return nil end
      local ok, package_json = pcall(vim.fn.json_decode, package_json_str)
      if not ok then return nil end
      if package_json.dependencies and package_json.dependencies.vue and string.find(package_json.dependencies.vue, "^%^?2") then return root_dir end
      if package_json.dependencies and package_json.dependencies.nuxt and string.find(package_json.dependencies.nuxt, "^%^?2") then return root_dir end
      return nil
    end,
    workspace_required = true,
  })
  vim.lsp.enable('vuels')
end
vim.lsp.config('tsgo', {
  cmd = { 'npx', '--package=@typescript/native-preview@latest', 'tsgo', '--lsp', '--stdio' },
  root_dir = function(bufnr, on_dir)
    if vim.fs.root(bufnr, {
      'vue.config.ts',  'vue.config.js',
      'nuxt.config.ts', 'nuxt.config.js',
      'deno.json',      'deno.jsonc',
    }) then
      return on_dir(nil) -- nil を渡すとそのバッファでは LSP を起動しない
    end
    on_dir(vim.fs.root(bufnr, { 'tsconfig.json', 'tsconfig.base.json' }))
  end,
  filetypes = { 'typescript', 'typescriptreact', 'typescript.tsx' },
  single_file_support = false,
})
vim.lsp.enable('tsgo')
if vim.fn.executable('jtd-lsp') == 1 then
  vim.lsp.config('jtd', {
    cmd = { 'lsp-devtools', 'agent', '--', 'jtd-lsp' },
    filetypes = { 'json' },
    root_markers = { 'test.jtd.json' },
    single_file_support = false,
  })
  vim.lsp.enable('jtd')
end

-- Keymaps
vim.keymap.set('n', '<Leader>w', '<cmd>w<CR>', { silent = true })
vim.keymap.set('n', '<Leader>e', '<cmd>enew<CR>', { silent = true })
vim.keymap.set('n', '<Leader>q', '<cmd>up<CR>:bp | bd #<CR>', { silent = true })
vim.keymap.set('n', '<Leader>x', '<cmd>q<CR>', { silent = true })
vim.keymap.set('n', '<Leader>c', '<cmd>enew<CR>:lua Term()<CR>', { silent = true })
vim.keymap.set({ 'n', 'v' }, '<Leader>h', '60h', { silent = true })
vim.keymap.set({ 'n', 'v' }, '<Leader>l', '60l', { silent = true })
vim.keymap.set({ 'n', 'v' }, '<Leader>k', '15k', { silent = true })
vim.keymap.set({ 'n', 'v' }, '<Leader>j', '15j', { silent = true })
vim.keymap.set('n', '<leader>i', function() vim.diagnostic.open_float() end, { silent = true })
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { silent = true })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { silent = true })
vim.keymap.set('n', '<C-j>', '<Esc>:noh<CR>', { silent = true })
vim.keymap.set({ 'v', 'i' }, '<C-j>', '<Esc>', { silent = true })
vim.keymap.set('n', 'n', 'nzz')
vim.keymap.set('t', '<C-j>', '<C-\\><C-n>')
vim.keymap.set('v', '//', [[<Esc>/\%V]])

function _G.Tabs()
  local tabs = vim.tbl_map(function(t) return t.tabnr end, vim.fn.gettabinfo())
  local current = vim.fn.tabpagenr()
  local others = vim.tbl_filter(function(n) return n ~= current end, tabs)
  vim.fn['fzf#run']({ source = others, sink = function(nr) vim.cmd('tabn ' .. nr) end, down = '30%' })
end
vim.keymap.set('n', '<Leader>t', '<cmd>lua Tabs()<CR>', { silent = true })
vim.keymap.set('n', '<Leader>n', ':tab split<CR>', { silent = true })


-- Zoom functions
function _G.Zoom(amount)
  local current = tonumber(vim.o.guifont:match('%d+$')) or 11
  _G.ZoomSet(current + amount)
end

function _G.ZoomSet(size)
  vim.o.guifont = vim.o.guifont:gsub('%d+$', '') .. size
end
vim.keymap.set('n', '<C-+>', function() Zoom(vim.v.count1) end, { silent = true })
vim.keymap.set('n', '<C-->', function() Zoom(-vim.v.count1) end, { silent = true })
vim.keymap.set('n', '<C-0>', function() ZoomSet(11) end, { silent = true })


-- Autocmds
local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- Colors
-- autocmd({ 'ColorScheme' }, {
--   pattern = '*',
--   callback = function()
--     vim.cmd([[hi NormalFloat guibg=#444444 guifg=#ffffff ctermbg=238 ctermfg=7]])
--     vim.cmd([[hi! link LspSignatureActiveParameter Search]])
--     vim.cmd([[hi! link @text.literal Normal]])
--   end
-- })

if vim.g.gonvim_running then
  vim.o.statusline = '%#Normal# '
end

-- Filetype settings
autocmd({ 'BufRead', 'BufNewFile' }, { pattern = '*.graphql', command = 'setfiletype graphql' })
autocmd({ 'BufNewFile', 'BufRead' }, { pattern = '*.es6', command = 'set filetype=javascript' })
autocmd('FileType', { pattern = 'netrw', command = 'setlocal bufhidden=wipe' })

local asm_grp = augroup('asmfile', { clear = true })
autocmd('FileType', { group = asm_grp, pattern = 'asm',
  callback = function()
    vim.opt_local.shiftwidth = 8
    vim.opt_local.expandtab = false
    vim.opt_local.tabstop = 8
  end
})

local go_grp = augroup('gofile', { clear = true })
autocmd('FileType', { group = go_grp, pattern = 'go',
  callback = function()
    vim.opt_local.shiftwidth = 2
    vim.opt_local.expandtab = false
    vim.opt_local.tabstop = 2
    vim.opt_local.formatprg = 'goimports'
  end
})

local config_grp = augroup('config', { clear = true })
autocmd('FileType', { group = config_grp, pattern = 'markdown',
  callback = function()
    vim.keymap.set('i', '<CR>', function()
      local l = vim.fn.getline('.')
      if l:match('^%s*-%s') then return '<CR>- ' end
      if l:match('^%s*[*]%s') then return '<CR>* ' end
      return '<CR>'
    end, { buffer = true, expr = true })
    vim.keymap.set('n', 'o', function()
      local l = vim.fn.getline('.')
      if l:match('^%s*-%s') then return 'o- ' end
      if l:match('^%s*[*]%s') then return 'o* ' end
      return 'o'
    end, { buffer = true, expr = true })
  end
})

-- Binary file handling
local binary_grp = augroup('BinaryXXD', { clear = true })
autocmd('BufReadPre', { group = binary_grp, pattern = '*.bin', command = 'let &binary=1' })
autocmd('BufReadPost', { group = binary_grp, pattern = '*',
  callback = function()
    if vim.o.binary then
      vim.cmd('%!xxd -g 1')
      vim.cmd('set ft=xxd')
    end
  end
})
autocmd('BufWritePre', { group = binary_grp, pattern = '*',
  callback = function()
    if vim.o.binary then vim.cmd('%!xxd -r') end
  end
})
autocmd('BufWritePost', { group = binary_grp, pattern = '*',
  callback = function()
    if vim.o.binary then
      vim.cmd('silent %!xxd -g 1')
      vim.cmd('set nomod')
    end
  end
})

-- Terminal handling
function _G.Term()
  vim.fn.termopen('fish')
  vim.cmd('setlocal nonumber norelativenumber scrolloff=0 nolist')
end
autocmd('VimEnter', {
  callback = function()
    if vim.fn.expand('%') == '' and (vim.fn.line2byte(vim.fn.line('$') + 1) == -1 and 0 or vim.fn.line2byte(vim.fn.line('$') + 1) - 1) == 0 then
      Term()
    end
  end
})
autocmd('BufEnter', {
  callback = function()
    if vim.bo.buftype == 'terminal' then
      vim.opt_local.scrolloff = 0
    else
      vim.opt_local.scrolloff = 5
    end
  end
})


-- User commands
vim.api.nvim_create_user_command('Qf', function(opts)
  local selected_lines = vim.fn.getline(opts.line1, opts.line2)
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
    vim.fn.setqflist({}, 'r', { lines = selected_lines, efm = error_format })
    vim.cmd('copen')
  end)
end, { range = true })

local lsp_commands = {
  LspDiagnostics = function() vim.diagnostic.setqflist() end,
  LspFormatting = function() vim.lsp.buf.format() end,
  LspRename = function() vim.lsp.buf.rename() end,
  LspIncomingCalls = function() vim.lsp.buf.incoming_calls() end,
  LspOutgoingCalls = function() vim.lsp.buf.outgoing_calls() end,
  LspTypeDefinition = function() vim.lsp.buf.type_definition() end,
  LspImplementation = function() vim.lsp.buf.implementation() end,
  LspHover = function() vim.lsp.buf.hover() end,
  LspSignatureHelp = function() vim.lsp.buf.signature_help() end,
  LspDefinition = function() vim.lsp.buf.definition() end,
  LspDocumentSymbol = function() vim.lsp.buf.document_symbol() end,
  LspWorkspaceSymbol = function() vim.lsp.buf.workspace_symbol() end,
  LspCodeAction = function() vim.lsp.buf.code_action() end,
}
for name, func in pairs(lsp_commands) do
  vim.api.nvim_create_user_command(name, func, { range = true })
end

-- Peek definition
local function preview_location_callback(_, method, result)
  if not result or vim.tbl_isempty(result) then
    vim.lsp.log.info(method, 'No location found')
    return
  end
  if vim.tbl_islist(result) then
    vim.lsp.util.preview_location(result[1])
  else
    vim.lsp.util.preview_location(result)
  end
end
function _G.peek_definition()
  local params = vim.lsp.util.make_position_params()
  vim.lsp.buf_request(0, 'textDocument/definition', params, preview_location_callback)
end
