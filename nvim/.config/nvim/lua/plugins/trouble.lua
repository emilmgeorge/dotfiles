local M = {}

function M.configure()
	-- Default configuration
	local default_config = {
	}

	local config = default_config
	require 'trouble'.setup(config)
	require 'which-key'.register({
		["<leader>gl"] = { ":TroubleToggle<cr>", "Show trouble" },
	}, {remap = false, silent = true})
end

function M.setup()
	require 'packer'.use {
		'folke/trouble.nvim',
		after = 'which-key.nvim',
		requires = "kyazdani42/nvim-web-devicons",
		config = M.configure,
	}
end

return M
