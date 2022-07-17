local fn = vim.fn
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
	packer_bootstrap = fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
	vim.api.nvim_command('packadd packer.nvim')
end

packer = require('packer')
if(packer) then
	packer.init()
	packer.reset()

	packer.use('wbthomason/packer.nvim')

	require('plugins/impatient')
	require('plugins/which-key')
	require('plugins/mapx')

	require('plugins/catppuccin')
	require('plugins/feline')

	require('plugins/nvim-lspconfig')
	require('plugins/nvim-treesitter')

	require('plugins/telescope')
	require('plugins/nvim-tree')

	require('plugins/Comment')

	require('plugins/notify')
end

-- Automatically set up your configuration after cloning packer.nvim
-- Put this at the end after all plugins
if packer_bootstrap then
	require('packer').sync()
end
