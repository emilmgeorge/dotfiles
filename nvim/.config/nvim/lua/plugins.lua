local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

local plugins = {
	-- Appearance
	require('themes').setup(),
	require('plugins/lualine').setup(),

	-- Editor
	require('plugins/which-key').setup(),
	require('plugins/notify').setup(),
	require('plugins/nvim_tree').setup(),

	-- Editing
	require('plugins/yanky').setup(),
	require('plugins/ultisnips').setup(),
	require('plugins/nvim-surround').setup(),
	require('plugins/vim-table-mode').setup(),
	require('plugins/todo-comments').setup(),
	require('plugins/vim-linux-coding-style').setup(),

	-- IDE/LSP tools
	require('plugins/nvim-lspconfig').setup(),
	require('plugins/nvim-treesitter').setup(),
	require('plugins/nvim-code-action-menu').setup(),
	require('plugins/nvim-navic').setup(),
	require('plugins/nvim-cmp').setup(),
	require('plugins/telescope').setup(),
	require('plugins/cscope_maps').setup(),
	require('plugins/trouble').setup(),
	require('plugins/vim-illuminate').setup(),
	require('plugins/Comment').setup(),
	require('plugins/gitsigns').setup(),
	require('plugins/nvim-autopairs').setup(),
	require('plugins/lsp-lines').setup(),
	require('plugins/vim-clang-format').setup(),

	-- Others
	require('plugins/nvim-neorg').setup(),
	require('plugins/attempt').setup(),
	require('plugins/markdown-preview').setup(),
}

require('lazy').setup(plugins)
