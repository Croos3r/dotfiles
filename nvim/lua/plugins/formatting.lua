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
      stylua = { append_args = { "--indent-type", "Spaces", "--indent-width", "2" } },
      sqlfluff = { args = { "format", "--dialect=ansi", "-" } },
    },
  },
  init = function()
    vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
  end,
}
