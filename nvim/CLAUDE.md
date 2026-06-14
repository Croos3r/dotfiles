# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

This is a personal Neovim configuration (Lua, lazy.nvim, Neovim 0.11+). There is no build or test suite — changes are verified by launching Neovim. Useful checks: `luac -p <file>` to syntax-check Lua, and inside Neovim `:Lazy` (plugins), `:Mason` (tool installs), `:checkhealth`, `:ConformInfo` (formatters), `:Neoconf` (per-project LSP). `lazy-lock.json` is the committed plugin lockfile — let lazy.nvim update it via `:Lazy update`, don't hand-edit.

## Load order

`init.lua` requires, in order: `core.options` (sets `<leader>` = space — must happen before lazy loads so plugin keymaps bind correctly), `core.autocmds`, then `config.lazy`. `config/lazy.lua` bootstraps lazy.nvim and imports two spec trees: `plugins/` (general) and `plugins.lang/` (per-language toolchains).

## The core architectural pattern: extend, don't centralize

Shared plugins (`lsp.lua`, `treesitter.lua`, `formatting.lua`) define an `opts` table with **empty** collections. Each language module in `lua/plugins/lang/` declares the *same plugin* again with its own `opts`, and lazy.nvim **merges** them. So adding a language touches exactly one new file — never a central list.

How each concern merges (see `lua/plugins/lang/README.md` for the authoritative table + template):

| Concern | Extend | Merge type |
| --- | --- | --- |
| LSP server | `neovim/nvim-lspconfig` → `opts.servers.<name>` | map merge (key = lspconfig server name) |
| Treesitter parser | `nvim-treesitter/nvim-treesitter` → `opts.ensure_installed` | list concat via `opts_extend` |
| Tool install | `WhoIsSethDaniel/mason-tool-installer.nvim` → `opts.ensure_installed` | list concat (mason package names) |
| Format-on-save | `stevearc/conform.nvim` → `opts.formatters_by_ft.<ft>` | map merge |
| Anything bespoke | a normal lazy spec (e.g. `rustaceanvim`) | — |

`config-langs.lua` is itself a "language" module covering config/infra filetypes (JSON, YAML, shell, Docker).

## LSP

`lua/core/lsp.lua` is the helper every server goes through. It uses Neovim 0.11's native `vim.lsp.config`/`vim.lsp.enable` (the deprecated `lspconfig.<name>.setup()` framework is deliberately avoided). `plugins/lsp.lua`'s `config` iterates `opts.servers` and calls `core.lsp.setup(name, cfg)` for each. So **just add to `opts.servers`** — never call `vim.lsp.config`/`enable` yourself. Some servers manage themselves (e.g. `rustaceanvim` owns rust-analyzer); those are plain plugin specs, not `opts.servers` entries.

Per-project settings come from `.neoconf.json` (`"lspconfig.<name>"` keys). neoconf only auto-hooks the deprecated framework, so `core.lsp` reads neoconf's API itself in a `before_init` merge. LSP keymaps (`K`, `gd`, `gr`, `gI`, `gtd`, etc.) are bound buffer-locally on `LspAttach` in `plugins/lsp.lua`. Diagnostics use a float (`<c-k>`), not inline virtual text.

## Formatting

conform.nvim, format-on-save enabled (1s timeout), LSP formatter as fallback when no conform formatter is mapped. Language modules only *map* filetypes → formatter names; the formatter **argument** tweaks live once in `plugins/formatting.lua` under `formatters = {}` (e.g. stylua/shfmt format to 2 spaces even though the global editor indent is tabs/width 4).

## Conventions

- Match the existing spec style: terse single-purpose files, a comment explaining *why* above non-obvious specs, `function() ... end` keys with `desc`.
- Indentation in the editor is tabs, width 4 (`core/options.lua`); Lua files in this repo are formatted by stylua to 2 spaces.
- Find names with: `:h lspconfig-all` (server names), `:Mason` (package names), `:h conform-formatters` (formatters).
