local M = {}

function M.configure()
	require 'cscope_maps'
end

function M.setup()
	return {
		'emilmgeorge/cscope_maps.nvim',
		config = M.configure,
	}
end

return M
