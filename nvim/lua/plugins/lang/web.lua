return {
  -- Styling / markup language servers.
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        cssls = {},
        html = {},
        emmet_language_server = {},
        unocss = {},
      },
    },
  },

  { "nvim-treesitter/nvim-treesitter", opts = { ensure_installed = { "css", "scss", "html" } } },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    opts = { ensure_installed = { "css-lsp", "html-lsp", "emmet-language-server", "unocss-language-server" } },
  },
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        css = { "prettierd", "prettier", stop_after_first = true },
        scss = { "prettierd", "prettier", stop_after_first = true },
        html = { "prettierd", "prettier", stop_after_first = true },
      },
    },
  },
}
