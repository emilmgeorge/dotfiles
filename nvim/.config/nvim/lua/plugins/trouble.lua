local M = {}

LSP_KEY_PREFIX = '<leader>l'

function M.configure()
	require 'trouble'.setup {}
	require 'which-key'.register({
		[LSP_KEY_PREFIX .. 't'] = { ":TroubleToggle<cr>", "Show trouble" },
	}, {remap = false, silent = true})
end

function M.setup()
	require 'packer'.use {
		'folke/trouble.nvim',
		requires = "kyazdani42/nvim-web-devicons",
		config = M.configure,
	}
end

return M
