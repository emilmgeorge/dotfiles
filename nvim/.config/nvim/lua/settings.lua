vim.opt.termguicolors = true

-- Line Numbers
-- Normal numbers in insert mode
-- Relative numbers in other modes
vim.opt.number = true
local augNumberToggle = vim.api.nvim_create_augroup("numbertoggle", {})
vim.api.nvim_create_autocmd({"BufEnter", "FocusGained", "InsertLeave"}, {
	group = augNumberToggle,
	pattern = "*",
	command = "if &ft != 'NvimTree' | set relativenumber | endif",
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

-- Allow moving to one char position beyond last char in a line
vim.opt.virtualedit = 'onemore'

-- Search settings
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Indent options
vim.opt.tabstop = 4			-- tabs are these many characters
vim.opt.softtabstop = 4		-- Pressing tab key inserts these many characters
vim.opt.shiftwidth = 4		-- indenting (eg. > and < operations)
vim.opt.shiftround = true	-- Round to 'shiftwidth' chars

-- Formatting options
vim.opt.wrap = true
vim.opt.textwidth = 79
vim.opt.formatoptions = 'tcqrn1j'

-- Split below and right by default
vim.opt.splitbelow = true
vim.opt.splitright = true

-- Whitespace display
vim.opt.listchars = 'tab:│ ,extends:›,precedes:‹,nbsp:·,trail:█,space:·'
