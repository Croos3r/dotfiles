# Leptos / maud / RSX, per project

The base config is plain Rust (rustaceanvim + rustfmt). Leptos-specific tooling
is enabled **per project** with neoconf — everything lives in one `.neoconf.json`
at the project root. No `exrc`, no trusted Lua, no global state.

## 1. rust-analyzer settings → `.neoconf.json`

rustaceanvim auto-detects neoconf and merges `lspconfig.rust_analyzer` settings:

```jsonc
{
  "lspconfig": {
    "rust_analyzer": {
      "rust-analyzer": {
        "procMacro": {
          "ignored": { "leptos_macro": ["component", "server"] }
        }
      }
    }
  }
}
```

## 2. leptosfmt formatting → neoconf-driven conform

neoconf has no built-in conform support, but conform allows a *function* for a
filetype's formatter list, so we let it read neoconf.

**One-time wiring** (in `lua/plugins/lang/rust.lua`, conform spec) — make the
Rust formatter neoconf-aware:

```lua
{
  "stevearc/conform.nvim",
  opts = {
    formatters_by_ft = {
      rust = function(bufnr)
        local ok, neoconf = pcall(require, "neoconf")
        local fmts = ok and neoconf.get("conform.formatters_by_ft.rust", nil,
          { file = vim.api.nvim_buf_get_name(bufnr) })
        return fmts or { "rustfmt" }
      end,
    },
  },
},
```

and register leptosfmt once (in `lua/plugins/formatting.lua`, `formatters`):

```lua
leptosfmt = { prepend_args = { "--rustfmt" } },
```

**Per project** — add to that project's `.neoconf.json` (alongside section 1):

```jsonc
{
  "conform": { "formatters_by_ft": { "rust": ["leptosfmt"] } }
}
```

Install the binary in the project: `cargo install leptosfmt`.

Projects without that key keep `rustfmt`. neoconf's JSON schema may show a
cosmetic "unknown property" hint on the custom `conform` key — harmless, the
value is still read.

> The wiring above is optional in the base config; add it only if you actually
> work on Leptos projects. Until then, `lang/rust.lua` keeps the simple
> `rust = { "rustfmt" }` mapping.

## maud-fmt

For `maud-fmt.nvim` (RSX/maud macro formatting), add it as a `ft = "rust"`
plugin gated behind a project marker (e.g. only when a leptos dependency is
present). For most workflows the leptosfmt path above is enough.
