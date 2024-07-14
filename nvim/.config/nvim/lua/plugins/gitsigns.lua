local M = {}

GIT_KEY_PREFIX = '<leader>g'

function M.configure()
	local function on_attach(bufnr)
		local gs = package.loaded.gitsigns

		-- Text object
		vim.keymap.set({'o', 'x'}, 'ih', ':<C-U>Gitsigns select_hunk<CR>', {buffer=bufnr})

		vim.keymap.set('n', ']g', function() if vim.wo.diff then return ']g' end
			vim.schedule(function() gs.next_hunk() end)
			return '<Ignore>'
		end, {expr=true, buffer=bufnr })

		vim.keymap.set('n', '[g', function()
			if vim.wo.diff then return '[g' end
			vim.schedule(function() gs.prev_hunk() end)
			return '<Ignore>'
		end, {expr=true, buffer=bufnr})

		vim.keymap.set({'n', 'v'}, GIT_KEY_PREFIX .. 'a', gs.stage_hunk, { desc = "Stage hunk", buffer=bufnr })
		vim.keymap.set({'n', 'v'}, GIT_KEY_PREFIX .. 'r', gs.reset_hunk, { desc = "Reset hunk", buffer=bufnr })

		vim.keymap.set('n', GIT_KEY_PREFIX .. 'D', function() gs.diffthis('HEAD') end, { desc = "Diff this with HEAD", buffer=bufnr })
		vim.keymap.set('n', GIT_KEY_PREFIX .. 'd', gs.diffthis, { desc = "Diff this with index", buffer=bufnr })
		vim.keymap.set('n', GIT_KEY_PREFIX .. 'sb', function() gs.blame_line { full=true } end, { desc = "Show full blame", buffer=bufnr })
		vim.keymap.set('n', GIT_KEY_PREFIX .. 'sh', gs.preview_hunk, { desc = "Show hunk", buffer=bufnr })
		vim.keymap.set('n', GIT_KEY_PREFIX .. 'tb', gs.toggle_current_line_blame, { desc = "Toggle blame line", buffer=bufnr })
		vim.keymap.set('n', GIT_KEY_PREFIX .. 'td', gs.toggle_deleted, { desc = "Toggle deleted", buffer=bufnr })
		vim.keymap.set('n', GIT_KEY_PREFIX .. 'u', gs.undo_stage_hunk, { desc = "Undo stage hunk", buffer=bufnr })

	end
	local config = {
		current_line_blame = false,
		current_line_blame_opts = {
			virt_text = true,
			virt_text_pos = 'right_align', -- 'eol' | 'overlay' | 'right_align'
			delay = 100,
			ignore_whitespace = false,
		},
		current_line_blame_formatter = ' .. [<author_time:%d %b %Y>][<author>][<abbrev_sha>] -- <summary>',
		diff_opts = {
			algorithm = 'patience',
		},
		on_attach = on_attach
	}

	vim.cmd[[highlight GitSignsAdd guifg=#669A55 guibg=#1F2132]]
	vim.cmd[[highlight GitSignsChange guifg=#CEC55F guibg=#1F2132]]

	require 'gitsigns'.setup(config)
end

function M.setup()
	return {
		'lewis6991/gitsigns.nvim',
		config = M.configure,
	}
end

return M
