return {
  -- LSP: basedpyright for types/navigation, ruff for linting.
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        basedpyright = {
          settings = {
            basedpyright = {
              analysis = {
                typeCheckingMode = "standard",
                autoImportCompletions = true,
              },
            },
          },
        },
        ruff = {
          -- Let basedpyright own hover; ruff focuses on lint + code actions.
          on_attach = function(client)
            client.server_capabilities.hoverProvider = false
          end,
        },
      },
    },
  },

  -- Treesitter parser
  { "nvim-treesitter/nvim-treesitter", opts = { ensure_installed = { "python" } } },
  -- Tools
  { "WhoIsSethDaniel/mason-tool-installer.nvim", opts = { ensure_installed = { "basedpyright", "ruff" } } },
  -- Formatting: ruff replaces black + isort.
  {
    "stevearc/conform.nvim",
    opts = { formatters_by_ft = { python = { "ruff_organize_imports", "ruff_format" } } },
  },
}
