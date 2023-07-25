local M = {}

TABLE_MODE_KEY_PREFIX = '<Leader>mt'

function M.configure()
end

function M.setup()
	vim.cmd("let g:table_mode_map_prefix = '" .. TABLE_MODE_KEY_PREFIX .. "'")
	require 'packer'.use {
		'dhruvasagar/vim-table-mode',
		config = M.configure,
		keys = {
			TABLE_MODE_KEY_PREFIX .. 'm', -- Toggle Table Mode
			TABLE_MODE_KEY_PREFIX .. 't', -- Tableize
		},
	}
end

return M
