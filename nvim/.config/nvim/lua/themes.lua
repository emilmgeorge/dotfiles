local M = {}

local catppuccin = require 'plugins/catppuccin'
local nightfox = require 'plugins/nightfox'
M.initialized = false

function M.init()
	if M.initialized then
		return
	end
	M.initialized = true

	catppuccin.init()

	vim.cmd[[highlight LspReferenceText guibg=NONE cterm=underline gui=underline]]
	vim.cmd[[highlight LspReferenceRead guibg=NONE cterm=underline gui=underline]]
	vim.cmd[[highlight LspReferenceWrite guibg=NONE cterm=underline gui=underline]]
end

function M.setup()
	catppuccin.setup()
	nightfox.setup()
end

return M
