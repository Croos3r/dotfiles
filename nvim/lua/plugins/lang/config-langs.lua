-- Servers/tools for the config & infra file types (JSON, YAML, shell, Docker).
return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        jsonls = {},
        yamlls = {},
        bashls = {},
        -- Correct lspconfig name uses underscores (the old config used dashes,
        -- which silently never started).
        docker_language_server = {},
        docker_compose_language_service = {},
      },
    },
  },

  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "json", "yaml", "dockerfile" } },
  },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    opts = {
      ensure_installed = {
        "json-lsp",
        "yaml-language-server",
        "bash-language-server",
        "docker-language-server",
        "docker-compose-language-service",
        "shfmt",
      },
    },
  },
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        sh = { "shfmt" },
        bash = { "shfmt" },
        json = { "prettierd", "prettier", stop_after_first = true },
        jsonc = { "prettierd", "prettier", stop_after_first = true },
        yaml = { "prettierd", "prettier", stop_after_first = true },
      },
    },
  },
}
