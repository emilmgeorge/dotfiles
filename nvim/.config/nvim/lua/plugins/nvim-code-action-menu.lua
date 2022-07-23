local M = {}

function M.configure()
	-- Default configuration
	-- vim.g.code_action_menu_window_border = 'single'
	-- vim.g.code_action_menu_show_details = true
	-- vim.g.code_action_menu_show_diff = true

	require 'which-key'.register({
		["<leader>ga"] = { ":CodeActionMenu<cr>", "Code Action" },
	}, {remap = false, silent = true})
end

function M.setup()
	require 'packer'.use {
		'weilbith/nvim-code-action-menu',
		after = 'which-key.nvim',
		config = M.configure,
	}
end

return M
