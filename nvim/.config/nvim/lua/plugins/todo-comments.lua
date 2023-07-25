local M = {}

TELESCOPE_KEY_PREFIX = '<leader>t'
TODO_COMMENTS_KEY = TELESCOPE_KEY_PREFIX .. 't'

function M.configure()
	require 'todo-comments'.setup {}

	-- Mappings
	require('which-key').register {
		[TODO_COMMENTS_KEY] = { "<cmd>TodoTelescope<cr>", "TODO Telescope" },
	}
end

function M.setup()
	require 'packer'.use {
		'folke/todo-comments.nvim',
		requires = 'nvim-lua/plenary.nvim',
		config = M.configure,
		keys = TODO_COMMENTS_KEY,
	}
end

return M
