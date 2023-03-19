local M = {}

function M.configure()
	require 'trouble'.setup {}
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
