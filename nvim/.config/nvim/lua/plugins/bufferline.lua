local M = {}

function M.configure()
	vim.opt.termguicolors = true
	require('bufferline').setup{}

	local opts = function(d)
		return { remap = false, silent = true, desc = d }
	end
	vim.keymap.set('n', '[t', '<Cmd>BufferLineCyclePrev<CR>', opts('Go to previous tab'))
	vim.keymap.set('n', ']t', '<Cmd>BufferLineCycleNext<CR>', opts('Go to next tab'))
	vim.keymap.set('n', '<Leader>1', '<Cmd>BufferLineGoToBuffer 1<CR>', opts('Go to tab 1'))
	vim.keymap.set('n', '<Leader>2', '<Cmd>BufferLineGoToBuffer 2<CR>', opts('Go to tab 2'))
	vim.keymap.set('n', '<Leader>3', '<Cmd>BufferLineGoToBuffer 3<CR>', opts('Go to tab 3'))
	vim.keymap.set('n', '<Leader>4', '<Cmd>BufferLineGoToBuffer 4<CR>', opts('Go to tab 4'))
	vim.keymap.set('n', '<Leader>5', '<Cmd>BufferLineGoToBuffer 5<CR>', opts('Go to tab 5'))
	vim.keymap.set('n', '<Leader>6', '<Cmd>BufferLineGoToBuffer 6<CR>', opts('Go to tab 6'))
	vim.keymap.set('n', '<Leader>7', '<Cmd>BufferLineGoToBuffer 7<CR>', opts('Go to tab 7'))
	vim.keymap.set('n', '<Leader>8', '<Cmd>BufferLineGoToBuffer 8<CR>', opts('Go to tab 8'))
	vim.keymap.set('n', '<Leader>9', '<Cmd>BufferLineGoToBuffer 9<CR>', opts('Go to tab 9'))
	vim.keymap.set('n', '<Leader>0', '<Cmd>BufferLineGoToBuffer -1<CR>', opts('Go to tab -1'))
end

function M.setup()
	return {
		'akinsho/bufferline.nvim',
		version = '*',
		dependencies = 'nvim-tree/nvim-web-devicons',
		config = M.configure,
	}
end

return M
