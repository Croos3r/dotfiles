local M = {}

function M.reload_config()
  local init = vim.fn.stdpath("config") .. "/init.lua"
  local ok, err = pcall(vim.cmd.source, init)
  if not ok then
    vim.notify("Failed to reload init.lua: " .. err, vim.log.levels.ERROR)
    return
  end

  require("lazy.manage.reloader").check(false)
  vim.notify("Reloaded init.lua and lazy.nvim plugin specs")
end

vim.api.nvim_create_user_command("ReloadConfig", M.reload_config, {
  desc = "Reload init.lua and lazy.nvim plugin specs",
})

return M
