local M = {}

ATTEMPT_KEY_PREFIX = '<Leader>ma'

function M.configure()
	local config = {
		dir = '/home/emil/data/scratch/',
		autosave = true,
		ext_options = { 'md', 'py', 'sh', 'cpp', 'c', 'js', 'lua', '' },
		run = {
			md = 'MarkdownPreview',
		}
	}
	require 'attempt'.setup(config)
	require 'telescope'.load_extension 'attempt'

	require 'which-key'.add({
		{ ATTEMPT_KEY_PREFIX, group = "attempt" },
	})
	local attempt = require('attempt')
	vim.keymap.set("n", ATTEMPT_KEY_PREFIX .. 'c', attempt.rename_buf, { desc = "Rename attempt" })
	vim.keymap.set("n", ATTEMPT_KEY_PREFIX .. 'd', attempt.delete_buf, { desc = "Delete attempt" })
	vim.keymap.set("n", ATTEMPT_KEY_PREFIX .. 'i', attempt.new_input_ext, { desc = "New attempt (custom ext)" })
	vim.keymap.set("n", ATTEMPT_KEY_PREFIX .. 'l', "<Cmd>Telescope attempt<CR>", { desc = "List attempts" })
	vim.keymap.set("n", ATTEMPT_KEY_PREFIX .. 'n', attempt.new_select, { desc = "New attempt" })
	vim.keymap.set("n", ATTEMPT_KEY_PREFIX .. 'r', attempt.run, { desc = "Run attempt" })
end

function M.setup()
	return {
		'm-demare/attempt.nvim',
		dependencies = 'nvim-lua/plenary.nvim',
		config = M.configure,
	}
end

return M
