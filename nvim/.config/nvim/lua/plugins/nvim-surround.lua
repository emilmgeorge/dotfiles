local M = {}

function M.configure()
	require 'nvim-surround'.setup {}
end

function M.setup()
	return {
		'kylechui/nvim-surround',
		config = M.configure,
	}
end

return M
