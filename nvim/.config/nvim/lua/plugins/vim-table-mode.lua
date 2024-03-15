local M = {}

TABLE_MODE_KEY_PREFIX = '<Leader>mt'

function M.configure()
end

function M.setup()
	vim.cmd("let g:table_mode_map_prefix = '" .. TABLE_MODE_KEY_PREFIX .. "'")
	return {
		'dhruvasagar/vim-table-mode',
		config = M.configure,
	}
end



return M
