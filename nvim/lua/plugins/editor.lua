return {
  -- Surround text objects: cs"' , ds( , ysiw) , etc.
  { "tpope/vim-surround", event = "VeryLazy" },

  -- Highlight, list, and jump between TODO/FIXME/HACK/etc. comments.
  {
    "folke/todo-comments.nvim",
    dependencies = "nvim-lua/plenary.nvim",
    -- Load on file open so comment highlighting/signs are active immediately;
    -- `keys` alone would only load the plugin once a mapping is pressed.
    event = { "BufReadPost", "BufNewFile" },
    opts = {},
    keys = {
      {
        "]t",
        function()
          require("todo-comments").jump_next()
        end,
        desc = "Next Todo Comment",
      },
      {
        "[t",
        function()
          require("todo-comments").jump_prev()
        end,
        desc = "Previous Todo Comment",
      },
      { "<leader>st", "<cmd>TodoTelescope<cr>", desc = "Todo (Telescope)" },
      { "<leader>xt", "<cmd>TodoQuickFix<cr>", desc = "Todo (Quickfix)" },
    },
  },

  -- Auto-insert/Delete matching brackets, quotes, etc. (Rust-fast).
  {
    "saghen/blink.pairs",
    dependencies = "saghen/blink.download",
    version = "^0.5",
    event = "InsertEnter",
    --- @module 'blink.pairs'
    --- @type blink.pairs.Config
    opts = {
      mappings = { enabled = true, cmdline = true },
      highlights = {
        enabled = true,
        groups = { "BlinkPairsOrange", "BlinkPairsPurple", "BlinkPairsBlue" },
        unmatched_group = "BlinkPairsUnmatched",
        matchparen = { enabled = true },
      },
    },
  },
}
