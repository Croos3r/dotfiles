-- Global editor options and leader keys.
-- Leader must be set before lazy.nvim loads (see init.lua).
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

local opt = vim.opt

-- UI
opt.number = true
opt.relativenumber = true
opt.signcolumn = "yes" -- avoid layout shift when diagnostics/gitsigns appear
opt.termguicolors = true -- required for catppuccin truecolors
opt.wrap = false
opt.scrolloff = 8
opt.splitright = true
opt.splitbelow = true

-- Indentation (tabs, width 4 — matches your previous setup)
opt.expandtab = false
opt.tabstop = 4
opt.shiftwidth = 4
opt.softtabstop = 0

-- Search
opt.ignorecase = true
opt.smartcase = true

-- Files / responsiveness
opt.undofile = true -- persistent undo
opt.updatetime = 250 -- faster CursorHold / diagnostics
opt.timeoutlen = 400 -- which-key style mapping timeout

-- Treeseitter folding
opt.foldmethod = "expr"
opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"

opt.foldlevel = 99
opt.foldlevelstart = 99
opt.foldnestmax = 10

opt.foldcolumn = "1"
opt.fillchars = { eob = " ", fold = " ", foldopen = "", foldsep = " ", foldclose = "" }
