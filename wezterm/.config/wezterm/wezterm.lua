local wezterm = require 'wezterm'
local config = {}
config.keys = {}

-- Tabs
config.hide_tab_bar_if_only_one_tab = true
config.prefer_to_spawn_tabs = true
config.use_fancy_tab_bar = false

-- Window
config.window_background_opacity = 0.85
config.window_decorations = 'NONE'

-- Disable ligatures
config.harfbuzz_features = { 'calt=0', 'clig=0', 'liga=0' }

-- Key bindings
-- Tab control
for i = 1,9 do
  table.insert(config.keys, { key = tostring(i), mods = 'ALT', action = wezterm.action.ActivateTab(i - 1) })
end
table.insert(config.keys, { key = '[', mods = 'ALT', action = wezterm.action.ActivateTabRelative(-1) })
table.insert(config.keys, { key = ']', mods = 'ALT', action = wezterm.action.ActivateTabRelative(1) })
table.insert(config.keys, { key = '[', mods = 'ALT|SHIFT', action = wezterm.action.MoveTabRelative(-1) })
table.insert(config.keys, { key = ']', mods = 'ALT|SHIFT', action = wezterm.action.MoveTabRelative(1) })
table.insert(config.keys, { key = 'w', mods = 'ALT', action = wezterm.action.CloseCurrentTab { confirm = true }})

-- Add launch menu
local launch_menu = {}
if wezterm.target_triple == 'x86_64-unknown-linux-gnu' then
  table.insert(launch_menu, { label = 'zsh without tmux', args = { 'zsh', '-l' }, set_environment_variables = { TMUX = '1' } })
  table.insert(launch_menu, { label = 'bash without tmux', args = { 'bash', '-l' }, set_environment_variables = { TMUX = '1' } })
end
config.launch_menu = launch_menu
table.insert(config.keys, { key = 'l', mods = 'ALT', action = wezterm.action.ShowLauncherArgs { flags = 'LAUNCH_MENU_ITEMS' } })
table.insert(config.keys, { key = 'L', mods = 'ALT', action = wezterm.action.ShowLauncher })

return config
