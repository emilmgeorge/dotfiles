local M = {}

ATTEMPT_KEY_PREFIX = '<leader>ma'

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

	local attempt = require 'attempt'
	require 'which-key'.register({
		[ATTEMPT_KEY_PREFIX] = { name = "+attempt", },
		[ATTEMPT_KEY_PREFIX .. 'n'] = { attempt.new_select, "New attempt" },
		[ATTEMPT_KEY_PREFIX .. 'i'] = { attempt.new_input_ext, "New attempt (custom ext)" },
		[ATTEMPT_KEY_PREFIX .. 'r'] = { attempt.run, "Run attempt" },
		[ATTEMPT_KEY_PREFIX .. 'd'] = { attempt.delete_buf, "Delete attempt" },
		[ATTEMPT_KEY_PREFIX .. 'c'] = { attempt.rename_buf, "Rename attempt" },
		[ATTEMPT_KEY_PREFIX .. 'l'] = { '<cmd>Telescope attempt<cr>', "List attempts" },
		-- [ATTEMPT_KEY_PREFIX .. 'l'] = { attempt.open_select, "ui.select instead of Telescope" },
	}, {mode = 'n', silent = true})
end

function M.setup()
	require 'packer'.use {
		'm-demare/attempt.nvim',
		requires = 'nvim-lua/plenary.nvim',
		keys = ATTEMPT_KEY_PREFIX,
		config = M.configure,
	}
end

return M
