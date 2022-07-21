local M = {}

function M.configure()
	-- Default configuration
	local default_config = {
		-- Configuration here, or leave empty to use defaults
	}

	local config = default_config
	require 'nvim-surround'.setup(config)
end

function M.setup()
	require 'packer'.use {
		'kylechui/nvim-surround',
		config = M.configure,
	}
end

return M
