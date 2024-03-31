local M = {}

function M.configure()
	require("image").setup({
		tmux_show_only_in_active_window = true,
	})
end

function M.setup()
	return {
		"3rd/image.nvim",
		cond = function()
			return vim.fn.has 'win32' ~= 1
		end,
		dependencies = {
			'leafo/magick',
		},
		config = M.configure,
	}
end

return M
