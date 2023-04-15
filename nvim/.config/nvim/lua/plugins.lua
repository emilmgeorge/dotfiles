local fn = vim.fn
local packer_bootstrap
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
	packer_bootstrap = fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
	vim.api.nvim_command('packadd packer.nvim')
end

local packer = require('packer')
if(packer) then
	packer.init()
	packer.reset()
	packer.use('wbthomason/packer.nvim')

	-- Appearance
	require('themes').setup()
	require('plugins/lualine').setup()

	-- Editor
	require('plugins/impatient').setup()
	require('plugins/which-key').setup()
	require('plugins/notify').setup()
	require('plugins/nvim-tree').setup()

	-- Editing
	require('plugins/yanky').setup()
	require('plugins/ultisnips').setup()
	require('plugins/nvim-surround').setup()
	require('plugins/vim-table-mode').setup()
	require('plugins/todo-comments').setup()
	require('plugins/vim-linux-coding-style').setup()

	-- IDE/LSP tools
	require('plugins/nvim-lspconfig').setup()
	require('plugins/nvim-treesitter').setup()
	require('plugins/nvim-code-action-menu').setup()
	require('plugins/nvim-navic').setup()
	require('plugins/nvim-cmp').setup()
	require('plugins/telescope').setup()
	require('plugins/cscope_maps').setup()
	require('plugins/trouble').setup()
	require('plugins/vim-illuminate').setup()
	require('plugins/Comment').setup()
	require('plugins/gitsigns').setup()
	require('plugins/nvim-autopairs').setup()
	require('plugins/lsp-lines').setup()

	-- Others
	require('plugins/vimwiki').setup()
	require('plugins/attempt').setup()
end

-- Automatically set up your configuration after cloning packer.nvim
-- Put this at the end after all plugins
if packer_bootstrap then
	require('packer').sync()
	vim.cmd[[autocmd User PackerComplete lua vim.notify("Please restart Neovim to load all plugins.")]]
end
