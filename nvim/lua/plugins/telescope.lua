return {
  "nvim-telescope/telescope.nvim",
  version = "*",
  dependencies = {
    "nvim-lua/plenary.nvim",
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
  },
  config = function()
    local telescope = require("telescope")
    telescope.setup({})
    pcall(telescope.load_extension, "fzf")
  end,
  keys = {
    -- File / project navigation
    { "ff", function() require("telescope.builtin").find_files() end, desc = "Telescope find files" },
    { "fg", function() require("telescope.builtin").live_grep() end, desc = "Telescope live grep" },
    { "fb", function() require("telescope.builtin").buffers() end, desc = "Telescope buffers" },
    { "fh", function() require("telescope.builtin").help_tags() end, desc = "Telescope help tags" },
    -- Search every keybind (your requested keymap finder)
    { "fk", function() require("telescope.builtin").keymaps() end, desc = "Telescope keymaps" },
  },
}
