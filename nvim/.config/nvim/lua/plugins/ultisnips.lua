local M = {}

function M.setup()
	return {
		'SirVer/ultisnips',
		dependencies = {
			'quangnguyen30192/cmp-nvim-ultisnips',
			config = function()
				require 'cmp_nvim_ultisnips'.setup {}
			end,
		},
	}
end

return M
