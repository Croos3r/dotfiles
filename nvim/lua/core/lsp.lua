-- Shared LSP helpers used by every language module.
--
-- Servers use the native vim.lsp.config / vim.lsp.enable API (Neovim 0.11+),
-- which reads the default config from nvim-lspconfig's lsp/<name>.lua files.
-- The deprecated `require("lspconfig").<name>.setup()` framework is avoided: it
-- prints a deprecation warning and is missing the newer servers (vue_ls,
-- docker_language_server, ...).
--
-- neoconf only hooks the deprecated framework, so we apply its per-project
-- settings ourselves via a before_init merge (see neoconf_before_init).
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

-- Returns a before_init that merges per-project settings from neoconf
-- (.neoconf.json -> "lspconfig.<name>") into the server's settings on startup.
local function neoconf_before_init(name)
  return function(params, config)
    local ok, neoconf = pcall(require, "neoconf")
    if not ok then
      return
    end
    -- Resolve the workspace root, preferring the most reliable source.
    -- rootPath is deprecated; rootUri and workspaceFolders are what modern
    -- clients populate, so check all three.
    local root = params.rootPath
    if params.rootUri then
      root = vim.uri_to_fname(params.rootUri)
    end
    if params.workspaceFolders and params.workspaceFolders[1] then
      root = vim.uri_to_fname(params.workspaceFolders[1].uri)
    end
    local project = neoconf.get("lspconfig." .. name, nil, root and { file = root } or nil)
    if type(project) == "table" then
      config.settings = vim.tbl_deep_extend("force", config.settings or {}, project)
    end
  end
end

-- Configure and enable a language server by its nvim-lspconfig name.
--   name: server name (e.g. "basedpyright", "vtsls", "vue_ls")
--   cfg:  optional config table (settings, filetypes, on_attach, ...)
function M.setup(name, cfg)
  cfg = cfg or {}
  cfg.capabilities = vim.tbl_deep_extend("force", M.capabilities(), cfg.capabilities or {})

  -- Chain the neoconf merge with any caller-provided before_init.
  local user_before_init = cfg.before_init
  local nc = neoconf_before_init(name)
  cfg.before_init = function(params, config)
    nc(params, config)
    if user_before_init then
      user_before_init(params, config)
    end
  end

  vim.lsp.config(name, cfg)
  vim.lsp.enable(name)
end

return M
