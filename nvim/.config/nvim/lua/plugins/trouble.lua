local M = {}

LSP_KEY_PREFIX = '<Leader>l'
TROUBLE_KEY = LSP_KEY_PREFIX .. 't'

function M.configure()
	require 'trouble'.setup {}
	vim.keymap.set('n', TROUBLE_KEY, ":TroubleToggle<CR>", { desc = "Show trouble" })
end

function M.setup()
	return {
		'folke/trouble.nvim',
		dependencies = "kyazdani42/nvim-web-devicons",
		config = M.configure,
	}
end

return M
