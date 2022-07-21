local M = {}

function M.configure()
	require 'impatient'
end

function M.setup()
	require 'packer'.use {
		'lewis6991/impatient.nvim',
		config = M.configure,
	}
end

return M
