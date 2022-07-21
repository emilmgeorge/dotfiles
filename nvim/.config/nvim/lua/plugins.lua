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
	packer.use('tpope/vim-sleuth')

	require('plugins/impatient').setup()
	require('plugins/which-key').setup()

	require('plugins/catppuccin').setup()
	require('plugins/nightfox').setup()
	require('plugins/lualine').setup()

	require('plugins/nvim-lspconfig').setup()
	require('plugins/nvim-lsp-installer').setup()
	require('plugins/nvim-treesitter').setup()
	require('plugins/nvim-cmp').setup()
	require('plugins/telescope').setup()
	require('plugins/aerial').setup()
	require('plugins/vim-illuminate').setup()

	require('plugins/nvim-tree').setup()
	require('plugins/ultisnips').setup()
	require('plugins/yanky').setup()

	require('plugins/nvim-surround').setup()
	require('plugins/Comment').setup()

	require('plugins/notify').setup()
end

-- Automatically set up your configuration after cloning packer.nvim
-- Put this at the end after all plugins
if packer_bootstrap then
	require('packer').sync()
end
