local M = {}

-- Normalize key names (case-insensitive for special keys)
local function normalize_key_name(key_name)
  if type(key_name) ~= "string" then return key_name end
  -- Lowercase all special keys inside <>
  key_name = key_name:gsub("<[^>]+>", function(part)
    return part:lower()
  end)
  key_name = key_name:gsub(" ", "<space>")
  return key_name
end

local function normalize_keycodes(key)
  return vim.api.nvim_replace_termcodes(key, true, true, true)
end

local function format_map_rhs(map)
  if map.callback and type(map.callback) == "function" then
    local info = debug.getinfo(map.callback)
    return string.format("function %s:%d", info.source, info.linedefined)
  elseif type(map.rhs) == "string" then
    return map.rhs
  else
    return string.format("<%s>", type(map.rhs))
  end
end

function M.init()
  local keymap_set = vim.keymap.set
  ---@diagnostic disable-next-line: duplicate-set-field
  vim.keymap.set = function(mode, lhs, rhs, opts)
    local keyname = normalize_key_name(lhs)
    opts = opts or {}
    -- opts.unique = true
    local modes = type(mode) == "table" and mode or { mode }
    for _, m in ipairs(modes) do
      ---@diagnostic disable-next-line: param-type-mismatch
      for _, map in ipairs(vim.api.nvim_get_keymap(m)) do
        if map.lhs == normalize_keycodes(keyname) then
          local message = "🔁 Replacing mapping:\n"
          message = message .. string.format("  Mode: %s Key: %s\n", m, keyname)
          message = message .. string.format("  Old: %s\n", format_map_rhs(map))
          message = message .. string.format("  New: %s", format_map_rhs({rhs = rhs, callback = rhs}))
          vim.notify(message, vim.log.levels.WARN)
        end
      end
    end
    return keymap_set(mode, keyname, rhs, opts)
  end
end

function M.check_lazy_keys()
  local lazy_config = require("lazy.core.config")
  local specs = lazy_config.spec.plugins
  -- Track all normalized keymap entries
  local keymap_index = {}
  -- Index all key mappings
  for plugin_name, plugin in pairs(specs) do
    if plugin.keys and type(plugin.keys) == "table" then
      for _, keymap in ipairs(plugin.keys) do
        local lhs, mode = nil, "n"
        if type(keymap) == "table" then
          lhs = keymap[1]
          mode = keymap.mode or "n"
        else
          lhs = keymap
        end

        if lhs then
          local norm_lhs = normalize_key_name(lhs)
          keymap_index[norm_lhs] = keymap_index[norm_lhs] or {}
          keymap_index[norm_lhs][mode] = keymap_index[norm_lhs][mode] or {}
          table.insert(keymap_index[norm_lhs][mode], {
            plugin = plugin_name,
            keymap = keymap,
            original_lhs = lhs
          })
        end
      end
    end
  end
  -- Report duplicates by normalized (key, mode)
  for norm_lhs, modes in pairs(keymap_index) do
    for mode, entries in pairs(modes) do
      local ndups = #entries
      for _, entry in ipairs(entries) do
        if entry.keymap.ignoredup then
          ndups = ndups - 1
        end
      end
      if ndups > 1 then
        local message = "🔁 Duplicate key mapping:\n"
        message = message .. string.format("Mode: %s Key: %s\n", mode, norm_lhs)
        for _, entry in ipairs(entries) do
          local rhs = entry.keymap[2]
          local rhs_info = format_map_rhs({rhs = rhs, callback = rhs})
          -- if type(rhs) == "function" then
          --   local info = debug.getinfo(rhs, "S")
          --   rhs_info = string.format("function at %s:%d", info.source, info.linedefined)
          -- elseif type(rhs) == "string" then
          --   rhs_info = rhs
          -- else
          --   rhs_info = "<none>"
          -- end
          message = message .. string.format("\n  Plugin: %s => %s",
            entry.plugin, rhs_info)
        end
        vim.notify(message, vim.log.levels.WARN)
      end
    end
  end
end

return M
