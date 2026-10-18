-- TypeScript / JavaScript / Vue toolchain.
-- vtsls is the single TS server; the @vue/typescript-plugin is loaded into it
-- and vue_ls handles Vue-specific features.
local ts_filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" }
local vue_plugin_location = vim.fn.stdpath("data")
  .. "/mason/packages/vue-language-server/node_modules/@vue/language-server"

-- One formatter per project, chosen by root markers: biome and deno_fmt are
-- gated on their config files (conditions live in plugins/formatting.lua), so
-- a Deno project isn't reformatted by biome. Order below is the precedence —
-- biome wins when a project somehow has both — and prettier is the fallback.
local js_formatters = { "biome-check", "deno_fmt", "prettier", stop_after_first = true }

return {
  -- LSP servers
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
		denols = {
			root_markers = {"deno.json", "deno.jsonc"},
			workspace_required = true,
		},
        vtsls = {
          filetypes = ts_filetypes,
		  root_markers = {"package.json", "tsconfig.json", "jsconfig.json"},
		  workspace_required = true,
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
        -- biome only reports diagnostics here; formatting still goes through
        -- conform's biome/biome-organize-imports formatters below.
        biome = {
      root_markers = { "biome.json", "biome.jsonc" },
		  workspace_required = true,
          filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact", "vue", "json" },
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
    opts = { ensure_installed = { "vtsls", "vue-language-server", "deno", "biome" } },
  },
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        javascript = js_formatters,
        javascriptreact = js_formatters,
        typescript = js_formatters,
        typescriptreact = js_formatters,
        vue = js_formatters,
        json = js_formatters,
        jsonc = js_formatters,
      },
    },
  },
}
