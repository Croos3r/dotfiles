-- Picker that lists directories under `root` and sets the selected one as cwd.
-- Used for both the ~/Projects switcher and the monorepo workspace switcher.
local function pick_dir_as_cwd(opts)
  opts = opts or {}
  local root = opts.root
  local prompt_title = opts.prompt_title or "Directories (set cwd)"

  local pickers = require("telescope.pickers")
  local finders = require("telescope.finders")
  local conf = require("telescope.config").values
  local actions = require("telescope.actions")
  local action_state = require("telescope.actions.state")

  local fd = (vim.fn.executable("fd") == 1 and "fd")
    or (vim.fn.executable("fdfind") == 1 and "fdfind")
  if not fd then
    vim.notify("Directory picker needs `fd` (or `fdfind`) installed", vim.log.levels.ERROR)
    return
  end

  pickers
    .new({}, {
      prompt_title = prompt_title,
      -- Depth 2 shows top-level projects and one level of subprojects
      -- (e.g. monorepo backends). fd honors .gitignore, so build dirs are skipped.
      finder = finders.new_oneshot_job({ fd, "--type", "d", "--max-depth", "2", ".", root }, {
        entry_maker = function(line)
          return {
            value = line,
            display = line:gsub("^" .. vim.pesc(root) .. "/?", ""),
            ordinal = line,
          }
        end,
      }),
      sorter = conf.generic_sorter({}),
      attach_mappings = function(bufnr)
        actions.select_default:replace(function()
          local entry = action_state.get_selected_entry()
          actions.close(bufnr)
          if entry and entry.value ~= "" then
            vim.cmd.cd(entry.value)
            vim.notify("cwd → " .. vim.fn.fnamemodify(entry.value, ":~"))
            require("telescope.builtin").find_files()
          end
        end)
        return true
      end,
    })
    :find()
end

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
    -- File / project navigation (rooted at cwd)
    { "ff", function() require("telescope.builtin").find_files() end, desc = "Telescope find files" },
    { "fg", function() require("telescope.builtin").live_grep() end, desc = "Telescope live grep" },
    { "fb", function() require("telescope.builtin").buffers() end, desc = "Telescope buffers" },
    { "fh", function() require("telescope.builtin").help_tags() end, desc = "Telescope help tags" },
    -- Search every keybind (your requested keymap finder)
    { "fk", function() require("telescope.builtin").keymaps() end, desc = "Telescope keymaps" },
    -- Find files across all of $HOME, regardless of the directory nvim opened in.
    {
      "<leader>ff",
      function()
        require("telescope.builtin").find_files({
          cwd = vim.fn.expand("~"),
          prompt_title = "Find Files ($HOME)",
        })
      end,
      desc = "Find files (global, $HOME)",
    },
    -- Change the cwd to a project directory under ~/Projects.
    {
      "<leader>fp",
      function()
        pick_dir_as_cwd({ root = vim.fn.expand("~/Projects"), prompt_title = "Projects (set cwd)" })
      end,
      desc = "Set cwd to a ~/Projects dir",
    },
    -- Hop between workspaces within the current dir (monorepo subdir switcher).
    {
      "<leader>fw",
      function()
        local root = vim.fn.getcwd()
        pick_dir_as_cwd({
          root = root,
          prompt_title = "Workspaces in " .. vim.fn.fnamemodify(root, ":~") .. " (set cwd)",
        })
      end,
      desc = "Set cwd to a workspace under current dir",
    },
  },
}
