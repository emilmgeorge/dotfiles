local M = {}

function M.configure()
	require 'cscope_maps'
end

function M.setup()
	require 'packer'.use {
		'emilmgeorge/cscope_maps.nvim',
		after = 'which-key.nvim',
		config = M.configure,
	}
end

return M
