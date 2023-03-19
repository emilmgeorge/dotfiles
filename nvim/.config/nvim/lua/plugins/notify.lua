local M = {}

function M.configure()
	require 'notify'.setup {}
	vim.notify = require 'notify'
end

function M.setup()
	require 'packer'.use {
		'rcarriga/nvim-notify',
		config = M.configure,
	}
end

return M
