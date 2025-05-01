local M = {}

-- Internal stores for warnings
local runtime_replacements = {} -- { mode, lhs, old_map, new_map }
local lazy_duplicates = {} -- { mode, lhs, entries = { {plugin, rhs}, ... } }

-- Normalize key names (case-insensitive for special keys)
local function normalize_key_name(key_name)
  if type(key_name) ~= "string" then
    return key_name
  end
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

-- Patch `vim.keymap.set` to detect runtime overrides
function M.init()
  local keymap_set = vim.keymap.set
  ---@diagnostic disable-next-line: duplicate-set-field
  vim.keymap.set = function(mode, lhs, rhs, opts)
    local keyname = normalize_key_name(lhs)
    opts = opts or {}
    local modes = type(mode) == "table" and mode or { mode }
    for _, m in ipairs(modes) do
      ---@diagnostic disable-next-line: param-type-mismatch
      for _, map in ipairs(vim.api.nvim_get_keymap(m)) do
        if map.lhs == normalize_keycodes(keyname) then
          table.insert(runtime_replacements, {
            mode = m,
            lhs = keyname,
            old = map,
            new = { rhs = rhs, callback = rhs },
          })
        end
      end
    end
    return keymap_set(mode, keyname, rhs, opts)
  end
  vim.api.nvim_create_autocmd("User", {
    pattern = "LazyDone",
    callback = function()
      require("keycheck").check_lazy_keys()
    end,
  })
end

-- Detect duplicate keys in Lazy plugin definitions
function M.check_lazy_keys()
  local ok, lazy_config = pcall(require, "lazy.core.config")
  if not ok then
    return
  end

  local specs = lazy_config.spec.plugins
  local keymap_index = {}

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
            rhs = keymap[2],
            keymap = keymap,
          })
        end
      end
    end
  end

  for norm_lhs, modes in pairs(keymap_index) do
    for mode, entries in pairs(modes) do
      local ndups = #entries
      for _, entry in ipairs(entries) do
        if entry.keymap.ignoredup then
          ndups = ndups - 1
        end
      end
      if ndups > 1 then
        table.insert(lazy_duplicates, {
          mode = mode,
          lhs = norm_lhs,
          entries = entries,
        })
      end
    end
  end
end

-- CheckHealth reporter
function M.check()
  local health = vim.health or require("vim.health") -- compat

  -- Lazy.nvim section
  health.start("Lazy.nvim: plugin spec keymap conflicts")
  if #lazy_duplicates == 0 then
    health.ok("No duplicate Lazy.nvim keymaps found.")
  else
    for _, dup in ipairs(lazy_duplicates) do
      local msg = string.format("🔁 Duplicate keymap in mode %s for %s", dup.mode, dup.lhs)
      for _, entry in ipairs(dup.entries) do
        msg = msg
          .. string.format(
            "\n  Plugin: %s => %s",
            entry.plugin,
            format_map_rhs({ rhs = entry.rhs, callback = entry.rhs })
          )
      end
      health.warn(msg)
    end
  end

  -- Runtime section
  health.start("Runtime: Live vim.keymap.set replacements")
  if #runtime_replacements == 0 then
    health.ok("No keymaps replaced at runtime.")
  else
    for _, entry in ipairs(runtime_replacements) do
      local msg = string.format(
        "🔁 Replacing keymap in mode %s for %s\n  Old: %s\n  New: %s",
        entry.mode,
        entry.lhs,
        format_map_rhs(entry.old),
        format_map_rhs(entry.new)
      )
      health.warn(msg)
    end
  end
end

return M
