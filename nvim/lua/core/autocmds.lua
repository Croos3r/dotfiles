-- Global autocommands not tied to a single plugin.
local augroup = vim.api.nvim_create_augroup("core_autocmds", { clear = true })

-- Briefly highlight yanked text.
vim.api.nvim_create_autocmd("TextYankPost", {
  group = augroup,
  callback = function()
    vim.hl.on_yank()
  end,
})
