local wezterm = require("wezterm")
local globals = require("globals")

local M = {}
M.scriptsPath = wezterm.config_dir .. "/scripts"

-- fzf switcher which opens in a right split and executes a command
M.fzfSwitcher = function(window, pane, script, command, pos)
	-- execute fzf with update script on every cursor move
	local fzfCommand = "fzf --color=gutter:-1,bg+:-1 --reverse " ..
	"--preview-window=down,1 --bind=\"load:pos(" .. pos .. ")\"" ..
	" --preview='" .. script .. " {}'"

	window:perform_action(
		wezterm.action.SplitPane({
			direction = "Down",
			command = {
				args = {
					"bash",
					"-c",
					command .. fzfCommand,
				},
			},
			size = { Percent = 25 },
		}),
		pane
	)
end

M.font_switcher = function(window, pane)
	-- get system fonts by family name including only monospaced fonts,
	-- format and sort them
	local listCommand = "fc-list :spacing=100 family | grep -v '^\\.' " ..
	"| cut -d ',' -f1 | sort -u | "

	local pos = '$(' .. listCommand .. ' grep -xFn \'' .. globals.font ..
	'\' | cut -d: -f1)'

	M.fzfSwitcher(window, pane, M.scriptsPath .. "/updateFont.lua " ..
		wezterm.config_dir, listCommand, pos)
end

M.theme_switcher = function(window, pane)
	-- get builtin wezterm color schemes
	local builtinSchemes = wezterm.get_builtin_color_schemes()

	-- build a new table from the builtin wezterm color schemes names
	local schemes = {}

	for key, _ in pairs(builtinSchemes) do
		table.insert(schemes, tostring(key))
	end

	-- sort them alphabetically
	table.sort(schemes, function(c1, c2)
		return c1 < c2
	end)

	-- build the command from schemes table to be passed to fzf
	local listCommand = 'echo -e "' .. table.concat(schemes, "\n") .. '" | '

	local pos = '$(' .. listCommand .. ' grep -xFn \'' .. globals.color_scheme ..
	'\' | cut -d: -f1)'

	M.fzfSwitcher(window, pane, M.scriptsPath .. "/updateScheme.lua " ..
		wezterm.config_dir, listCommand, pos)
end

return M

