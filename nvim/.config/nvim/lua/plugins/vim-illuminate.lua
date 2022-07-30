local M = {}

function M.configure()
	-- Time in milliseconds (default 0)
	vim.g.Illuminate_delay = 0
	vim.cmd[[highlight illuminatedWord guibg=NONE cterm=underline gui=underline]]
	vim.cmd[[highlight illuminatedCurWord guibg=NONE cterm=underline gui=underline]]
end

function M.setup()
	require 'packer'.use {
		'RRethy/vim-illuminate',
		config = M.configure,
	}
end

return M
