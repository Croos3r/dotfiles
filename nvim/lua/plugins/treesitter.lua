return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main", -- the rewrite: parsers via install(), highlight via autocmd
  lazy = false,
  build = ":TSUpdate",
  -- ensure_installed is extended by each language module (opts_extend below).
  opts = {
    ensure_installed = {
      "lua",
      "vim",
      "vimdoc",
      "query",
      "bash",
      "markdown",
      "markdown_inline",
      "regex",
    },
  },
  opts_extend = { "ensure_installed" },
  config = function(_, opts)
    local ts = require("nvim-treesitter")
    ts.setup({})
    -- Install any missing parsers for the aggregated list.
    ts.install(opts.ensure_installed)

    -- Enable treesitter highlighting for any filetype that has a parser
    -- installed. pcall keeps it quiet for filetypes without a parser.
    vim.api.nvim_create_autocmd("FileType", {
      group = vim.api.nvim_create_augroup("treesitter_highlight", { clear = true }),
      callback = function()
        pcall(vim.treesitter.start)
      end,
    })
  end,
}
