-- Global autocommands not tied to a single plugin.
local augroup = vim.api.nvim_create_augroup("core_autocmds", { clear = true })

-- Open the file picker on startup when nvim is launched without a file argument.
vim.api.nvim_create_autocmd("VimEnter", {
  group = augroup,
  callback = function()
    if vim.fn.argc() == 0 then
      pcall(function()
        require("telescope.builtin").find_files()
      end)
    end
  end,
})

-- Briefly highlight yanked text.
vim.api.nvim_create_autocmd("TextYankPost", {
  group = augroup,
  callback = function()
    vim.hl.on_yank()
  end,
})
