-- TypeScript / JavaScript / Vue toolchain.
-- vtsls is the single TS server; the @vue/typescript-plugin is loaded into it
-- and vue_ls handles Vue-specific features.
local ts_filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" }
local vue_plugin_location = vim.fn.stdpath("data")
  .. "/mason/packages/vue-language-server/node_modules/@vue/language-server"

return {
  -- LSP servers
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        vtsls = {
          filetypes = ts_filetypes,
          settings = {
            vtsls = {
              tsserver = {
                globalPlugins = {
                  {
                    name = "@vue/typescript-plugin",
                    location = vue_plugin_location,
                    languages = { "vue" },
                    configNamespace = "typescript",
                  },
                },
              },
            },
          },
        },
        vue_ls = {
          settings = {
            vue = {
              suggest = {
                componentNameCasing = "preferKebabCase",
                propNameCasing = "preferKebabCase",
              },
            },
          },
        },
      },
    },
  },

  -- Auto close/rename HTML/JSX/Vue tags.
  {
    "windwp/nvim-ts-autotag",
    ft = { "html", "javascriptreact", "typescriptreact", "vue", "xml", "markdown" },
    opts = {},
  },

  -- Treesitter parsers
  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "typescript", "tsx", "javascript", "vue", "html", "css", "json" } },
  },
  -- Tools + formatting
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    opts = { ensure_installed = { "vtsls", "vue-language-server" } },
  },
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        javascript = { "prettier" },
        javascriptreact = { "prettier" },
        typescript = { "prettier" },
        typescriptreact = { "prettier" },
        vue = { "prettier" },
      },
    },
  },
}
