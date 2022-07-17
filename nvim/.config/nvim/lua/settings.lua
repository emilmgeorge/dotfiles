-- Set vim leader key
vim.g.mapleader = " "

vim.opt.termguicolors = true

-- Line Numbers
-- Normal numbers in insert mode
-- Relative numbers in other modes
vim.opt.number = true
local augNumberToggle = vim.api.nvim_create_augroup("numbertoggle", {})
vim.api.nvim_create_autocmd({"BufEnter", "FocusGained", "InsertLeave"}, {
	group = augNumberToggle,
	pattern = "*",
	command = "set relativenumber",
})
vim.api.nvim_create_autocmd({"BufLeave", "FocusLost", "InsertEnter"}, {
	group = augNumberToggle,
	pattern = "*",
	command = "set norelativenumber",
})

-- Command completion settings
vim.opt.wildmode = 'longest,full'

-- Blink cursor on error instead of beeping (grr)
vim.opt.visualbell = true

-- Keep cursor away from top/bottom when scrolling
vim.opt.scrolloff = 5

-- Match pairs using %
-- vim.opt.matchpairs += <:> -- Use matchup plugin

-- Disable folding by default
vim.opt.foldenable = false

