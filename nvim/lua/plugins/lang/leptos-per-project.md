# Leptos / maud / RSX, per project

The base config is plain Rust (rustaceanvim + rustfmt). Leptos-specific tooling
was removed from the global config so it doesn't run in every Rust project.
Re-enable it **per project** with the two mechanisms below.

There's an important split:

- **neoconf** handles per-project *LSP settings* (JSON merged into the language
  server). Good for the `rust-analyzer` proc-macro tweaks.
- **neoconf does NOT load plugins.** For project-local formatters
  (`leptosfmt`, `maud-fmt`) use a project `.nvim.lua` (`exrc`).

---

## 1. rust-analyzer settings → `.neoconf.json`

Drop a `.neoconf.json` at the project root. rustaceanvim auto-detects neoconf and
merges these into rust-analyzer:

```jsonc
{
  "lspconfig": {
    "rust_analyzer": {
      "rust-analyzer": {
        "procMacro": {
          "ignored": {
            "leptos_macro": ["component", "server"]
          }
        }
      }
    }
  }
}
```

This is the old `procMacro.ignore` for `leptos_macro` that used to live in the
global config — now scoped to the projects that actually need it.

> Verify it applied: open a Rust file in the project and run `:Neoconf` (shows the
> merged settings) or `:checkhealth neoconf`.

## 2. leptosfmt / maud formatting → project `.nvim.lua`

Enable `exrc` once globally so Neovim trusts project-local config:

```lua
-- in lua/core/options.lua (already a good place)
vim.opt.exrc = true
```

Then in the **project root**, add `.nvim.lua`:

```lua
-- Project-local: format Rust with leptosfmt instead of plain rustfmt.
require("conform").formatters_by_ft.rust = { "leptosfmt" }
require("conform").formatters.leptosfmt = { prepend_args = { "--rustfmt" } }
```

Install the binary in that project: `cargo install leptosfmt`.

The first time you open the project Neovim asks whether to trust `.nvim.lua`
(`:trust`). Commit `.nvim.lua` to the project repo, not to this dotfiles repo.

### maud-fmt

If you want `maud-fmt.nvim` (RSX/maud macro formatting), install it as a normal
plugin **inside that project's own Neovim overlay** — it isn't worth a global
plugin. Simplest: add it back as a `ft = "rust"` plugin guarded by a project marker,
e.g. only set it up when a `leptos.toml`/`Cargo.toml` with leptos is present. For
most workflows the `.nvim.lua` + leptosfmt path above is enough.
