local M = {}

LSP_KEY_PREFIX = '<leader>l'
TROUBLE_KEY = LSP_KEY_PREFIX .. 't'

function M.configure()
	require 'trouble'.setup {}
	require 'which-key'.register({
		[TROUBLE_KEY] = { ":TroubleToggle<cr>", "Show trouble" },
	}, {remap = false, silent = true})
end

function M.setup()
	require 'packer'.use {
		'folke/trouble.nvim',
		requires = "kyazdani42/nvim-web-devicons",
		config = M.configure,
		keys = TROUBLE_KEY,
	}
end

return M
