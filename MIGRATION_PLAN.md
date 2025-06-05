# Migration Plan

This document describes a precise process for porting every feature from the
original **init.vim** into the modern **init.lua** configuration. The goal is to
retain full functionality while removing legacy or redundant settings.

## 1. Build a complete inventory

- Extract every plugin listed in `init.vim`.
- Catalogue all key mappings, autocommands and user commands.
- List custom functions and helper utilities.
- Record all option settings.
- Note which settings became defaults in recent Neovim versions.

Having this exhaustive inventory is critical so that nothing is missed during
the migration.

## 2. Migrate plugins to lazy.nvim

- Replace the old minpac block with `lazy.nvim` declarations.
- Ensure each plugin from the inventory is represented.
- Skip intentionally removed plugins (`insx` and `nvim-dap`).
- Translate per‑plugin configuration snippets to Lua.

## 3. Translate configuration

- Convert every option from Vimscript to the Lua API, dropping those that are no
  longer necessary.
- Rewrite custom functions in Lua and expose them via
  `vim.api.nvim_create_user_command` where appropriate.
- Convert all autocommands with `vim.api.nvim_create_autocmd`.
- Recreate key mappings using `vim.keymap.set`.

## 4. Update LSP and completion

- Follow the current `lspconfig` setup style.
- Use built‑in features of Neovim where possible and remove obsolete wrappers.

## 5. Verification checklist

- [ ] Run `nvim --headless -u init.lua +qa` and confirm no errors appear.
- [ ] Manually test key mappings, autocommands and commands in an interactive
  Neovim session.
- [ ] Compare the new behaviour with `init.vim` to ensure feature parity.
- [ ] Once parity is confirmed, keep `init.vim` in the repository as a backup.

Following this plan will ensure that the Lua configuration faithfully reproduces
all features of the old Vimscript setup while modernising the parts that no
longer match current Neovim defaults.
