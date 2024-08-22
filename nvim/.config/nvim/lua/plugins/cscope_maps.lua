local M = {}

function M.configure()
	require('cscope_maps').setup({
		skip_input_prompt = false,
		prefix = '<C-\\>',
		cscope = {
			picker = 'telescope',
			db_build_cmd_args = { '-bqRv' },
		}
	})
end

function M.setup()
	return {
		'dhananjaylatkar/cscope_maps.nvim',
		config = M.configure,
	}
end

return M
