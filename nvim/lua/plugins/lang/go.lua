return {
  -- gopls configured through the shared LSP path (blink caps + neoconf).
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        gopls = {
          settings = {
            gopls = {
              analyses = { unusedparams = true, unreachable = true },
              staticcheck = true,
              gofumpt = true,
            },
          },
        },
      },
    },
  },

  -- go.nvim for the extra workflow commands (:GoTest, :GoAddTag, etc.).
  -- LSP and formatting are handled elsewhere, so lsp_cfg is disabled and we do
  -- NOT register its format-on-save autocmd (conform owns formatting).
  {
    "ray-x/go.nvim",
    dependencies = { "ray-x/guihua.lua" },
    ft = { "go", "gomod" },
    build = ':lua require("go.install").update_all_sync()',
    opts = { lsp_cfg = false, lsp_keymaps = false },
    config = function(_, opts)
      require("go").setup(opts)
    end,
  },

  -- Treesitter parsers
  { "nvim-treesitter/nvim-treesitter", opts = { ensure_installed = { "go", "gomod", "gosum", "gowork" } } },
  -- Tools
  { "WhoIsSethDaniel/mason-tool-installer.nvim", opts = { ensure_installed = { "gopls", "goimports" } } },
  -- Formatting
  { "stevearc/conform.nvim", opts = { formatters_by_ft = { go = { "goimports", "gofmt" } } } },
}
