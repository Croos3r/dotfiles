-- Entry point. Order matters: options sets <leader>, which must be set before
-- lazy.nvim loads so that plugin-defined mappings bind to the right leader.
require("core.options")
require("core.autocmds")
require("config.lazy")
