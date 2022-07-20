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

	require('plugins/impatient')
	require('plugins/which-key').setup()

	require('plugins/catppuccin').setup()
	require('plugins/lualine').setup()

	require('plugins/nvim-lspconfig')
	require('plugins/nvim-treesitter')
	require('plugins/nvim-cmp').setup()
	require('plugins/ultisnips')

	require('plugins/telescope')
	require('plugins/nvim-tree').setup()

	require('plugins/yanky')
	require('plugins/nvim-surround')
	require('plugins/Comment')

	require('plugins/notify')
end

-- Automatically set up your configuration after cloning packer.nvim
-- Put this at the end after all plugins
if packer_bootstrap then
	require('packer').sync()
end
