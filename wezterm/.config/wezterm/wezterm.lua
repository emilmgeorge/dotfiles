local wezterm = require 'wezterm'
local config = {}
config.keys = {}
config.default_prog = { 'wsl.exe' }
config.font_size = 11

-- Tabs
config.hide_tab_bar_if_only_one_tab = true
config.prefer_to_spawn_tabs = true
config.use_fancy_tab_bar = false

-- Window
config.window_background_opacity = 0.95
--config.window_decorations = 'NONE'

-- Disable ligatures
config.harfbuzz_features = { 'calt=0', 'clig=0', 'liga=0' }

local G = require("globals")
local scheme = wezterm.color.get_builtin_schemes()[G.color_scheme]
scheme.background = G.background or scheme.background
local color_scheme_overrides = {
  ["Poimandres"] = { background = "#0E0F15" },
  ["catppuccin-mocha"] = { background = "#11111b" },
  ["rose-pine"] = { background = "#12101A" },
  ["rose-pine-moon"] = { background = "#12101A" },
  ["tokyonight"] = { background = "#15161F" },
  ["tokyonight_moon"] = { background = "#15161F" },
  ["Gruvbox Material (Gogh)"] = { background = "#0f0f0f" },
  ["Nightfly (Gogh)"] = { background = "#010F1A" },
  ["Andromeda"] = { background = "#000000" },
}
if color_scheme_overrides[G.color_scheme] then
  for property, value in pairs(color_scheme_overrides[G.color_scheme]) do
    scheme[property] = value
    scheme.background = G.background or value
  end
end
config.color_scheme = "Custom"
config.color_schemes = { ["Custom"] = scheme }

-- Key bindings ---------------------------------------------------------------|
-- Disable default bindings
config.disable_default_key_bindings = true

-- Clipboard
table.insert(config.keys, { key = 'c', mods = 'CTRL|SHIFT', action = wezterm.action.CopyTo('ClipboardAndPrimarySelection') })
table.insert(config.keys, { key = 'v', mods = 'CTRL|SHIFT', action = wezterm.action.PasteFrom('Clipboard') })
table.insert(config.keys, { key = 'Insert', mods = 'SHIFT', action = wezterm.action.PasteFrom('Clipboard') })

-- Set leader key
local leader_mod = 'CTRL'
local leader_root = 'q'
config.leader = { key = leader_root, mods = leader_mod, timeout_milliseconds = 5000 }
table.insert(config.keys, { key = leader_root, mods = 'LEADER|' .. leader_mod, action = wezterm.action.SendKey { key = leader_root, mods = leader_mod }})

-- View
table.insert(config.keys, { key = 'z', mods = 'LEADER', action = wezterm.action.ToggleFullScreen })
table.insert(config.keys, { key = '+', mods = 'LEADER|SHIFT', action = wezterm.action.IncreaseFontSize })
table.insert(config.keys, { key = '-', mods = 'LEADER', action = wezterm.action.DecreaseFontSize })
table.insert(config.keys, { key = '=', mods = 'LEADER', action = wezterm.action.ResetFontSize })

-- Modes
table.insert(config.keys, { key = '[', mods = 'LEADER', action = wezterm.action.ActivateCopyMode})
table.insert(config.keys, { key = '/', mods = 'LEADER', action = wezterm.action.Search('CurrentSelectionOrEmptyString')})

-- Misc
table.insert(config.keys, { key = 'u', mods = 'LEADER|CTRL|SHIFT', action = wezterm.action.CharSelect({ copy_on_select = true, copy_to = 'ClipboardAndPrimarySelection' }) })
table.insert(config.keys, { key = 'Space', mods = 'LEADER', action = wezterm.action.QuickSelect })

-- Tab control
for i = 1,9 do
  table.insert(config.keys, { key = tostring(i), mods = 'LEADER', action = wezterm.action.ActivateTab(i - 1) })
end
table.insert(config.keys, { key = 'p', mods = 'LEADER', action = wezterm.action.ActivateTabRelative(-1) })
table.insert(config.keys, { key = 'n', mods = 'LEADER', action = wezterm.action.ActivateTabRelative(1) })
table.insert(config.keys, { key = 'H', mods = 'LEADER|SHIFT', action = wezterm.action.MoveTabRelative(-1) })
table.insert(config.keys, { key = 'L', mods = 'LEADER|SHIFT', action = wezterm.action.MoveTabRelative(1) })
table.insert(config.keys, { key = '&', mods = 'LEADER', action = wezterm.action.CloseCurrentTab { confirm = true }})
table.insert(config.keys, { key = "c", mods = "LEADER", action = wezterm.action.SpawnCommandInNewTab({
    args = { "wsl.exe" },
    set_environment_variables = { SKIP_MUX_INIT = "1" },
}) })

-- Pane control
table.insert(config.keys, { key = "h", mods = "LEADER", action = wezterm.action.ActivatePaneDirection("Left") })
table.insert(config.keys, { key = "l", mods = "LEADER", action = wezterm.action.ActivatePaneDirection("Right") })
table.insert(config.keys, { key = "k", mods = "LEADER", action = wezterm.action.ActivatePaneDirection("Up") })
table.insert(config.keys, { key = "j", mods = "LEADER", action = wezterm.action.ActivatePaneDirection("Down") })
table.insert(config.keys, { key = "x", mods = "LEADER", action = wezterm.action.CloseCurrentPane({ confirm = true }) })
table.insert(config.keys, { key = '%', mods = "LEADER|SHIFT", action = wezterm.action.SplitHorizontal({
    args = config.default_prog,
    set_environment_variables = { SKIP_MUX_INIT = "1" },
}) })
table.insert(config.keys, { key = "\"", mods = "LEADER|SHIFT", action = wezterm.action.SplitVertical({
    args = config.default_prog,
    set_environment_variables = { SKIP_MUX_INIT = "1" },
}) })

-- Launch menu
local launch_menu = {}
if wezterm.target_triple == 'x86_64-unknown-linux-gnu' then
  table.insert(launch_menu, { label = 'zsh without tmux', args = { 'zsh', '-l' }, set_environment_variables = { SKIP_MUX_INIT = '1' } })
  table.insert(launch_menu, { label = 'bash without tmux', args = { 'bash', '-l' }, set_environment_variables = { SKIP_MUX_INIT = '1' } })
elseif wezterm.target_triple == 'x86_64-pc-windows-msvc' then
  table.insert(launch_menu, { label = 'WSL', args = { 'wsl.exe' }, })
  table.insert(launch_menu, { label = 'Git Bash', args = { 'C:\\Users\\egeorge\\AppData\\Local\\Programs\\Git\\bin\\bash.exe', '--login' }, })
  table.insert(launch_menu, { label = 'Powershell', args = { 'powershell.exe' }, })
  table.insert(launch_menu, { label = 'Cmd', args = { 'cmd.exe' }, })
end
config.launch_menu = launch_menu
table.insert(config.keys, { key = 'l', mods = 'LEADER|CTRL', action = wezterm.action.ShowLauncher })

-- On the fly configuration
local features = require('features')
table.insert(config.keys, { key = "c", mods = "LEADER|CTRL", action = wezterm.action_callback(features.theme_switcher) })
table.insert(config.keys, { key = "f", mods = "LEADER|CTRL", action = wezterm.action_callback(features.font_switcher) })

-- Wezterm-related
table.insert(config.keys, { key = 'p', mods = 'LEADER|CTRL', action = wezterm.action.ActivateCommandPalette})
table.insert(config.keys, { key = 's', mods = 'LEADER', action = wezterm.action.ReloadConfiguration})
table.insert(config.keys, { key = 'd', mods = 'LEADER|ALT', action = wezterm.action.ShowDebugOverlay})

-- Covers task bar also :(
--
-- local mux = wezterm.mux
-- wezterm.on("gui-startup", function(cmd)
--     local tab, pane, window = mux.spawn_window(cmd or {})
--     window:gui_window():maximize()
-- end)

return config
