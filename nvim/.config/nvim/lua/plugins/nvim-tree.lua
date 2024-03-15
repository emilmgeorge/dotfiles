local M = {}

function M.configure()
	local config = {
		view = {
			adaptive_size = true,
		},
		update_focused_file = {
			enable = true,
			update_root = true,
		},
	}
	require("nvim-tree").setup(config)
	vim.keymap.set('n', '<Leader>d', '<Cmd>NvimTreeFindFileToggle<CR>', { noremap=true, silent=true })
end

function M.setup()
	return {
		'kyazdani42/nvim-tree.lua',
		dependencies = {
			'kyazdani42/nvim-web-devicons', -- optional, for file icons
		},
		config = M.configure,
	}
end

return M
