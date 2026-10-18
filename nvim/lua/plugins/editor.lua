return {
  -- Surround text objects: cs"' , ds( , ysiw) , etc.
  { "tpope/vim-surround", event = "VeryLazy" },

  -- Case-aware search/replace (:S/:Subvert) and case coercion (crs snake_case,
  -- crc camelCase, crm MixedCase, cru UPPER, cr- dash, cr. dot, cr<space>).
  -- `keys = "cr"` loads the plugin on the coercion prefix.
  {
    "tpope/vim-abolish",
    cmd = { "Abolish", "Subvert", "S" },
    keys = { { "cr", desc = "Coerce case" } },
  },

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
    config = function(_, opts)
      require("blink.pairs").setup(opts)
      vim.keymap.set("i", "<", function()
        local line = vim.api.nvim_get_current_line()
        local column = vim.api.nvim_win_get_cursor(0)[2] + 1
        if line:sub(column, column) == ">" then
          return "<"
        end
        return "<><Left>"
      end, { expr = true, desc = "Insert matching chevrons" })
    end,
  },
}
