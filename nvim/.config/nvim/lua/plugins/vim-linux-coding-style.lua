local M = {}

function M.configure()
	vim.cmd ([[
	" Disable automatic activation
	let g:linuxsty_patterns = []
	]])
end

function M.setup()
	require 'packer'.use {
		'vivien/vim-linux-coding-style',
		config = M.configure,
		cmd = 'LinuxCodingStyle'
	}
end

return M
