local M = {}

TELESCOPE_KEY_PREFIX = '<Leader>t'
TODO_COMMENTS_KEY = TELESCOPE_KEY_PREFIX .. 't'

function M.configure()
	require 'todo-comments'.setup {}

	-- Mappings
	vim.keymap.set('n', TODO_COMMENTS_KEY, "<Cmd>TodoTelescope<CR>", { desc = "TODO Telescope" })
end

function M.setup()
	return {
		'folke/todo-comments.nvim',
		dependencies = 'nvim-lua/plenary.nvim',
		config = M.configure,
	}
end

return M
