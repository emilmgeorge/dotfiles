#!/usr/bin/env lua

local wezterm_dir = arg[1]
local u = dofile(wezterm_dir .. "/utils.lua")
local globalsPath = wezterm_dir .. "/globals.lua"

local lua = u.readLuaObject(globalsPath)
lua.color_scheme = tostring(arg[2])
u.writeLuaObject(globalsPath, lua)

print(lua.color_scheme)
