return {
  -- Rich Rust experience: inlay hints, runnables/debuggables, macro expansion.
  -- rustaceanvim manages rust-analyzer itself (do NOT also configure it via
  -- lspconfig). It auto-detects neoconf for per-project settings.
  {
    "mrcjkb/rustaceanvim",
    version = "^9",
    lazy = false, -- the plugin lazy-loads itself on rust files
    init = function()
      vim.g.rustaceanvim = {
        server = {
          default_settings = {
            ["rust-analyzer"] = {
              check = { command = "clippy" },
              cargo = { features = "all" },
              procMacro = { enable = true },
            },
          },
        },
      }
    end,
  },

  -- Treesitter parsers
  { "nvim-treesitter/nvim-treesitter", opts = { ensure_installed = { "rust", "toml" } } },
  -- Formatting: rustfmt ships with the toolchain (not installed via mason).
  { "stevearc/conform.nvim", opts = { formatters_by_ft = { rust = { "rustfmt" } } } },
}
