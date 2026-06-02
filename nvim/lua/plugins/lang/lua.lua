return {
  -- Neovim Lua API types + completion for your config itself.
  {
    "folke/lazydev.nvim",
    ft = "lua",
    opts = {
      library = {
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      },
    },
  },
  -- lazydev completion source for blink (top priority on lua files).
  {
    "saghen/blink.cmp",
    opts = {
      sources = {
        default = { "lazydev" },
        providers = {
          lazydev = { name = "LazyDev", module = "lazydev.integrations.blink", score_offset = 100 },
        },
      },
    },
  },

  -- LSP
  { "neovim/nvim-lspconfig", opts = { servers = { lua_ls = {} } } },
  -- Treesitter parser
  { "nvim-treesitter/nvim-treesitter", opts = { ensure_installed = { "luadoc" } } },
  -- Tools (formatter) + format mapping
  { "WhoIsSethDaniel/mason-tool-installer.nvim", opts = { ensure_installed = { "stylua" } } },
  { "stevearc/conform.nvim", opts = { formatters_by_ft = { lua = { "stylua" } } } },
}
