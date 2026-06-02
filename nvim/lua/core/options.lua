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
opt.wrap = true
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
