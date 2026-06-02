-- Shared LSP helpers used by every language module.
--
-- Servers are configured through nvim-lspconfig's `setup()` (NOT the native
-- vim.lsp.enable) on purpose: neoconf hooks into lspconfig's setup pipeline to
-- inject per-project `.neoconf.json` settings. Going through setup() is what
-- makes neoconf actually apply project-local LSP settings.
local M = {}

-- Build completion capabilities, merging in blink.cmp's extras when present.
function M.capabilities()
  local caps = vim.lsp.protocol.make_client_capabilities()
  local ok, blink = pcall(require, "blink.cmp")
  if ok then
    caps = blink.get_lsp_capabilities(caps)
  end
  return caps
end

-- Configure and start a language server by its lspconfig name.
--   name: lspconfig server name (e.g. "basedpyright", "vtsls")
--   cfg:  optional lspconfig setup table (settings, filetypes, etc.)
function M.setup(name, cfg)
  cfg = cfg or {}
  cfg.capabilities = vim.tbl_deep_extend("force", M.capabilities(), cfg.capabilities or {})
  require("lspconfig")[name].setup(cfg)
end

return M
