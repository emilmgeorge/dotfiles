local M = {}

function M.configure()
	local config = {
		current_line_blame = true,
		current_line_blame_opts = {
			virt_text = true,
			virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
			delay = 100,
			ignore_whitespace = false,
		},
		current_line_blame_formatter = '<author>, <author_time:%Y-%m-%d> - <summary>',
	}

	require 'gitsigns'.setup(config)
end

function M.setup()
	require 'packer'.use {
		'lewis6991/gitsigns.nvim',
		config = M.configure,
	}
end

return M
