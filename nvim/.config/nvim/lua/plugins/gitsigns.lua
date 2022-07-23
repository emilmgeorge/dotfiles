local M = {}

function M.configure()
	-- Default configuration
	local default_config = {
	}

	local config = default_config
	require 'gitsigns'.setup(config)
end

function M.setup()
	require 'packer'.use {
		'lewis6991/gitsigns.nvim',
		config = M.configure,
	}
end

return M
