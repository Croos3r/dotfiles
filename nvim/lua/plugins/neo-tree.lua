return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    cmd = "Neotree",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "nvim-tree/nvim-web-devicons",
    },
    keys = {
      {
        "<leader>e",
        "<cmd>Neotree toggle<cr>",
        desc = "Toggle Neo-tree",
      },
    },
    opts = {
      filesystem = {
        follow_current_file = {
          enabled = true,
        },
        hijack_netrw_behavior = "open_default",
      },
      window = {
        mappings = {
          ["j"] = "move_cursor_down",
          ["k"] = "move_cursor_up",
          ["<Down>"] = "move_cursor_down",
          ["<Up>"] = "move_cursor_up",
          ["<C-v>"] = "open_vsplit",
          ["<C-x>"] = "open_split",
          ["<C-t>"] = "open_tabnew",
          ["<C-r>"] = "refresh",
          ["<C-c>"] = "close_window",
        },
      },
    },
  },
}
