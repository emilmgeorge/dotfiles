local M = {}

function M.configure()
	require 'todo-comments'.setup {}

	-- Mappings
	require('which-key').register {
		["<leader>gt"] = { "<cmd>TodoTelescope<cr>", "Go to definitions" },
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
