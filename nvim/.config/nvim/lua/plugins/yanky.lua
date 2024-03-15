local M = {}

function M.configure()
	local config = {
		ring = {
			history_length = 100,
		},
		highlight = {
			timer = 100,
		},
	}
	require 'yanky'.setup(config)
	require 'telescope'.load_extension 'yank_history'
end

function M.setup()
	return {
		'gbprod/yanky.nvim',
		config = M.configure,
	}
end

return M
