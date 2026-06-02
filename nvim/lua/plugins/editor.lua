return {
  -- Surround text objects: cs"' , ds( , ysiw) , etc.
  { "tpope/vim-surround", event = "VeryLazy" },

  -- Auto-insert/Delete matching brackets, quotes, etc. (Rust-fast).
  {
    "saghen/blink.pairs",
    version = "*",
    dependencies = "saghen/blink.download",
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
