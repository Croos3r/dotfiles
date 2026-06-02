return {
  "saghen/blink.cmp",
  dependencies = { "rafamadriz/friendly-snippets" },
  version = "1.*",
  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = {
    keymap = {
      ["<c-x>"] = { "show", "show_documentation", "hide_documentation" },
      ["<c-e>"] = { "cancel", "fallback" },
      ["<tab>"] = { "snippet_forward", "accept", "fallback" },
      ["<c-y>"] = { "select_and_accept", "fallback" },
      ["<c-k>"] = { "select_prev", "fallback" },
      ["<up>"] = { "select_prev", "fallback" },
      ["<c-j>"] = { "select_next", "fallback" },
      ["<down>"] = { "select_next", "fallback" },
    },
    appearance = { nerd_font_variant = "mono" },
    completion = { documentation = { auto_show = true } },
    sources = {
      default = { "lsp", "path", "snippets", "buffer" },
      -- Per-language/plugin sources (lazydev, dadbod, ...) are added by their
      -- own modules via opts_extend on sources.default.
      providers = {},
    },
    fuzzy = { implementation = "prefer_rust" },
  },
  opts_extend = { "sources.default" },
}
