return {
  -- Snacks: pickers, input/notifier UI, statuscolumn, scroll, indent guides,
  -- and the GitHub pickers. Loaded eagerly so the `Snacks` global is available.
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    opts = {
      input = { enabled = true },
      picker = { enabled = true },
      notifier = { enabled = true },
      quickfile = { enabled = true },
      scope = { enabled = true },
      scroll = { enabled = true },
      statuscolumn = { enabled = true },
      indent = { enabled = true }, -- indent guides (replaces blink.indent)
      words = { enabled = true },
      github = { enabled = true },
    },
    keys = {
      { "<leader>gi", function() Snacks.picker.gh_issue() end, desc = "GitHub issues" },
      { "<leader>gp", function() Snacks.picker.gh_pr() end, desc = "GitHub PRs" },
    },
  },

  -- Buffer tabline, themed by catppuccin.
  {
    "akinsho/bufferline.nvim",
    version = "*",
    dependencies = { "nvim-tree/nvim-web-devicons", "catppuccin/nvim" },
    event = "VeryLazy",
    config = function()
      require("bufferline").setup({
        highlights = require("catppuccin.special.bufferline").get_theme(),
      })
    end,
  },
}
