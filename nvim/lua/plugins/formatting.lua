return {
  "stevearc/conform.nvim",
  event = { "BufWritePre" },
  cmd = { "ConformInfo" },
  keys = {
    {
      "<leader>f",
      function() require("conform").format({ async = true }) end,
      mode = "",
      desc = "Format buffer",
    },
  },
  ---@module "conform"
  ---@type conform.setupOpts
  opts = {
    -- formatters_by_ft is populated per-language in lua/plugins/lang/*.lua.
    formatters_by_ft = {},
    default_format_opts = {
      -- Fall back to the LSP formatter when no conform formatter is configured.
      lsp_format = "fallback",
    },
    format_on_save = { timeout_ms = 1000 },
    -- Shared formatter argument tweaks. Formatters are referenced by name from
    -- the language modules; their argument customizations live here.
    formatters = {
      shfmt = { append_args = { "-i", "2" } },
      -- Root markers decide which JS/TS toolchain formats a project; see
      -- lang/typescript.lua for the precedence order. `biome check --write`
      -- also organizes imports, so no separate pass is needed.
      ["biome-check"] = {
        condition = function(_, ctx) return vim.fs.root(ctx.buf, { "biome.json", "biome.jsonc" }) ~= nil end,
      },
      deno_fmt = {
        condition = function(_, ctx) return vim.fs.root(ctx.buf, { "deno.json", "deno.jsonc" }) ~= nil end,
      },
      -- stylua = { append_args = { "--indent-type", "Spaces", "--indent-width", "2" } },
      sqlfluff = { args = { "format", "--dialect=ansi", "-" } },
    },
  },
  init = function()
    vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
  end,
}
