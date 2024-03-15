local M = {}

function M.configure()
	require 'Comment'.setup {}
end

function M.setup()
	return {
		'numToStr/Comment.nvim',
		config = M.configure,
	}
end

return M
