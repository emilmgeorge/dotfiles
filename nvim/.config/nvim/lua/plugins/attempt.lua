local M = {}

function M.configure()
	local config = {
		dir = '/home/emil/data/scratch/',
		autosave = true,
		ext_options = { 'md', 'py', 'sh', 'cpp', 'c', 'js', 'lua', '' },
	}
	require 'attempt'.setup(config)
	require 'telescope'.load_extension 'attempt'

	local attempt = require 'attempt'
	require 'which-key'.register({
		['<leader>an'] = { attempt.new_select, "New attempt" },
		['<leader>ai'] = { attempt.new_input_ext, "New attempt (custom ext)" },
		['<leader>ar'] = { attempt.run, "Run attempt" },
		['<leader>ad'] = { attempt.delete_buf, "Delete attempt" },
		['<leader>ac'] = { attempt.rename_buf, "Rename attempt" },
		['<leader>al'] = { '<cmd>Telescope attempt<cr>', "List attempts" },
		-- ['<leader>al'] = { attempt.open_select, "ui.select instead of Telescope" },
	}, {mode = 'n', silent = true})
end

function M.setup()
	require 'packer'.use {
		'm-demare/attempt.nvim',
		requires = 'nvim-lua/plenary.nvim',
		keys = '<leader>a',
		config = M.configure,
	}
end

return M
