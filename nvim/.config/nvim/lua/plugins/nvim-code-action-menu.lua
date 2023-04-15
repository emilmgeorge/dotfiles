local M = {}

function M.configure()
	require 'which-key'.register({
		["<leader>ga"] = { ":CodeActionMenu<cr>", "Code Action" },
	}, {remap = false, silent = true})
end

function M.setup()
	require 'packer'.use {
		'weilbith/nvim-code-action-menu',
		config = M.configure,
	}
end

return M
