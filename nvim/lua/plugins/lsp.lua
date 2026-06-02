return {
  -- Mason: installs LSP servers, formatters and linters.
  { "mason-org/mason.nvim", opts = {} },

  -- Auto-install the tools each language module declares. Language modules
  -- extend `ensure_installed` with mason package names.
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    dependencies = { "mason-org/mason.nvim" },
    opts = {
      ensure_installed = {},
      run_on_start = true,
    },
    opts_extend = { "ensure_installed" },
    config = function(_, opts)
      require("mason-tool-installer").setup(opts)
    end,
  },

  -- Per-project LSP settings via .neoconf.json. We read these through neoconf's
  -- public API in core.lsp's before_init (neoconf only auto-hooks the deprecated
  -- lspconfig framework, which we don't use).
  { "folke/neoconf.nvim", cmd = "Neoconf", opts = {} },

  -- LSP configs. Servers are contributed by language modules through
  -- `opts.servers` and configured via core.lsp, which uses the native
  -- vim.lsp.config/enable API and merges neoconf project settings itself.
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "folke/neoconf.nvim",
      "mason-org/mason.nvim",
      "saghen/blink.cmp",
    },
    opts = {
      servers = {}, -- e.g. servers.basedpyright = { settings = {...} }
    },
    config = function(_, opts)
      -- Initialize neoconf so its API is ready for core.lsp's before_init.
      require("neoconf").setup({})

      -- Diagnostics: no inline virtual text; show details in a float instead.
      vim.diagnostic.config({ virtual_text = false, virtual_lines = false, float = true })

      -- Buffer-local LSP keymaps, bound only once a server attaches.
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("lsp_attach_keymaps", { clear = true }),
        callback = function(args)
          local function map(lhs, rhs, desc)
            vim.keymap.set("n", lhs, rhs, { buffer = args.buf, desc = desc })
          end
          map("K", vim.lsp.buf.hover, "Hover docs")
          map("<c-k>", vim.diagnostic.open_float, "Show diagnostic")
          map("gD", vim.lsp.buf.definition, "Go to definition")
          map("gd", vim.lsp.buf.declaration, "Go to declaration")
          map("gI", vim.lsp.buf.implementation, "Go to implementation")
          map("gr", vim.lsp.buf.references, "References")
          map("gtd", vim.lsp.buf.type_definition, "Type definition")
        end,
      })

      -- Configure each server contributed by the language modules.
      for name, server_cfg in pairs(opts.servers or {}) do
        require("core.lsp").setup(name, server_cfg)
      end
    end,
  },
}
