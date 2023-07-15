local M = {}

TELESCOPE_KEY_PREFIX = '<leader>t'

function M.configure()
	require 'todo-comments'.setup {}

	-- Mappings
	require('which-key').register {
		[TELESCOPE_KEY_PREFIX .. 't'] = { "<cmd>TodoTelescope<cr>", "TODO Telescope" },
	}
end

function M.setup()
	require 'packer'.use {
		'folke/todo-comments.nvim',
		requires = 'nvim-lua/plenary.nvim',
		config = M.configure,
	}
end

return M
