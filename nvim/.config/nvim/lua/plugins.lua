-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
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
	require('plugins/headlines').setup(),
	require('plugins/nvim-neorg').setup(),
	require('plugins/attempt').setup(),
	require('plugins/markdown-preview').setup(),
}

require('lazy').setup({
	spec = plugins,
	ui = {
		border = "rounded",
	},
})
