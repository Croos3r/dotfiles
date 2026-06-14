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
        -- Tailwind class autocompletion + hovers. Activates when the project has
        -- a tailwind config (v3) or a CSS file with `@import "tailwindcss"` (v4).
        tailwindcss = {},
      },
    },
  },

  { "nvim-treesitter/nvim-treesitter", opts = { ensure_installed = { "css", "scss", "html" } } },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    opts = {
      ensure_installed = {
        "css-lsp",
        "html-lsp",
        "emmet-language-server",
        "unocss-language-server",
        "tailwindcss-language-server",
      },
    },
  },
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        css = { "prettier" },
        scss = { "prettier" },
        html = { "prettier" },
      },
    },
  },
}
