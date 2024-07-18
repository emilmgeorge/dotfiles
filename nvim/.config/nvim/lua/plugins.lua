-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	-- Get lazy.nvim commit from lazy-lock.json (if present)
	local lazycommit = "HEAD"
	local lazylockpath = vim.fn.stdpath("config") .. "/lazy-lock.json"
	if (vim.uv or vim.loop).fs_stat(lazylockpath) then
		local file = io.open(lazylockpath, "r")
		if file then
			local content = file:read("*all")
			file:close()
			local data = vim.json.decode(content)
			if data and data["lazy.nvim"] and data["lazy.nvim"].commit then
				lazycommit = data["lazy.nvim"].commit
			end
		end
	end
	-- Clone lazy.nvim
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
	-- Checkout to SHA (from above - if required)
	out = vim.fn.system({ "git", "-C", lazypath, "checkout", lazycommit })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to checkout lazy.nvim commit " .. lazycommit .. ":\n", "ErrorMsg" },
			{ out, "WarningMsg" },
		}, true, {})
		vim.ui.input({prompt='Do you want to continue (y/n)[n]:'}, function(s)
			if vim.fn.tolower(s) ~= "y" then
				os.execute("rm -rf " .. lazypath)
				os.exit(1)
			end
		end)
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
	require('plugins/image').setup(),
	require('plugins/nvim-neorg').setup(),
	require('plugins/attempt').setup(),
	require('plugins/markdown-preview').setup(),
}

require('lazy').setup({
	spec = plugins,
	ui = {
		border = "rounded",
	},
	rocks = {
		hererocks = true,
	},
})
