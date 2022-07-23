local M = {}

function M.configure()
	vim.cmd ([[
	" Use markdown syntax
	let g:vimwiki_list = [{'syntax': 'markdown', 'ext': '.md'}]

	" Use vimwiki filetype only for md files under wiki directory
	let g:vimwiki_global_ext = 0
	]])
end

function M.setup()
	require 'packer'.use {
		'vimwiki/vimwiki',
		config = M.configure,
	}
end

return M
