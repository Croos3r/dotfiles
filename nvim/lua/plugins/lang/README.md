# Language modules

Each file in this directory adds **one language's full toolchain** by extending the
shared plugins. lazy.nvim merges the `opts` tables across every spec that targets
the same plugin, so a language module never edits a central list — it just
contributes its piece.

Adding a new language = create one file here. Nothing else to touch.

## What a module can contribute

| Concern              | Plugin to extend                              | How it merges |
| -------------------- | --------------------------------------------- | ------------- |
| LSP server           | `neovim/nvim-lspconfig` → `opts.servers.<name>` | map merge (server name is the lspconfig name) |
| Treesitter parser    | `nvim-treesitter/nvim-treesitter` → `opts.ensure_installed` | list concat (`opts_extend`) |
| Install a tool       | `WhoIsSethDaniel/mason-tool-installer.nvim` → `opts.ensure_installed` | list concat (mason package names) |
| Formatter mapping    | `stevearc/conform.nvim` → `opts.formatters_by_ft.<ft>` | map merge |
| Anything else        | a normal lazy spec (e.g. `rustaceanvim`, `go.nvim`) | — |

Notes:
- Servers in `opts.servers` are configured via `core.lsp` → `lspconfig.setup`, which
  is what lets **neoconf** inject per-project settings. Don't use `vim.lsp.enable`.
- Formatter *arguments* (e.g. indent width) are customized once in
  `lua/plugins/formatting.lua` under `formatters = {}`; modules only map filetypes.
- Some servers manage themselves (e.g. `rustaceanvim` owns rust-analyzer). Those are
  plain plugin specs, not `opts.servers` entries.

## Template

```lua
-- lua/plugins/lang/<language>.lua
return {
  -- 1. LSP server (skip if a dedicated plugin manages it)
  { "neovim/nvim-lspconfig", opts = { servers = { my_server = { settings = {} } } } },

  -- 2. Treesitter parser(s)
  { "nvim-treesitter/nvim-treesitter", opts = { ensure_installed = { "mylang" } } },

  -- 3. Tools to install (mason package names: servers, formatters, linters)
  { "WhoIsSethDaniel/mason-tool-installer.nvim", opts = { ensure_installed = { "my-formatter" } } },

  -- 4. Format-on-save mapping
  { "stevearc/conform.nvim", opts = { formatters_by_ft = { mylang = { "my-formatter" } } } },
}
```

Find server names with `:h lspconfig-all`, mason package names with `:Mason`,
and available conform formatters in `:h conform-formatters`.
