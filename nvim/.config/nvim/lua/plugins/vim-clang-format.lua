local M = {}

function M.configure()
	vim.cmd[[
	let g:clang_format#enable_fallback_style = 0
	let g:clang_format#detect_style_file = 1
	]]
end

function M.setup()
	require 'packer'.use {
		'rhysd/vim-clang-format',
		config = M.configure,
		cmd = 'ClangFormat',
	}
end

return M
