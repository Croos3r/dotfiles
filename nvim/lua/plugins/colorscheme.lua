return {
  "catppuccin/nvim",
  name = "catppuccin",
  priority = 1000, -- load before other plugins so highlights are ready
  lazy = false,
  opts = {
    flavour = "mocha",
    background = { light = "latte", dark = "mocha" },
    transparent_background = true,
    float = { transparent = true, solid = true },
    show_end_of_buffer = false,
    term_colors = true,
    dim_inactive = { enabled = false, shade = "dark", percentage = 0.15 },
    styles = {
      comments = { "italic" },
      conditionals = { "italic" },
    },
    custom_highlights = function(colors)
      return {
        LineNrAbove = { fg = colors.overlay2 },
        LineNr = { bg = colors.flamingo },
        LineNrBelow = { fg = colors.overlay2 },
      }
    end,
    -- auto_integrations picks up installed plugins (telescope, gitsigns, blink,
    -- snacks, mason, etc.) automatically, so we don't maintain a manual list.
    default_integrations = true,
    auto_integrations = true,
  },
  config = function(_, opts)
    require("catppuccin").setup(opts)
    vim.cmd.colorscheme("catppuccin")
  end,
}
