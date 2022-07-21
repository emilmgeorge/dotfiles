local M = {}

function M.setup()
	require 'packer'.use {
		'SirVer/ultisnips',
		requires = {
			'quangnguyen30192/cmp-nvim-ultisnips',
			config = function()
				require 'cmp_nvim_ultisnips'.setup {}
			end,
		},
	}
end

return M
