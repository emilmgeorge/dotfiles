local M = {}

function M.configure()
	---- Add here the packages you want to make sure that they are installed
	--local nvim_rocks = require "nvim_rocks"
	--nvim_rocks.ensure_installed "uuid
end

function M.setup()
	return {
		"theHamsta/nvim_rocks",
		build = "python3 -mhererocks . -j2.1.0-beta3 -r3.0.0 && cp nvim_rocks.lua lua",
		config = M.configure,
	}
end

return M
