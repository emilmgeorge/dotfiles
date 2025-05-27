-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Toggle whitespace display
Snacks.toggle.option("list", { name = "Whitespace display" }):map("<leader>u<Space>")

-- Insert character
vim.keymap.set("n", "<Leader> ", "i<Space><Esc>r", { desc = "Insert character in normal mode", remap = false })

-- Copy/paste using system clipboard
vim.keymap.set({ "n", "v" }, "<Leader>pp", '"+p', { desc = "Paste from clipboard", remap = false })
vim.keymap.set({ "n", "v" }, "<Leader>yy", '"+y', { desc = "Yank to clipboard", remap = false })
vim.keymap.set({ "n", "v" }, "<Leader>pP", '"*p', { desc = "Paste from primary", remap = false })
vim.keymap.set({ "n", "v" }, "<Leader>yY", '"*y', { desc = "Yank to primary", remap = false })

-- Fix * and # (Search whole-word under cursor) to avoid jumping to next match.
-- This makes it inconsistent with the operator-pending mapping but oh well.
vim.keymap.set({ "n", "v" }, "*", function()
  if vim.v.count > 0 then
    vim.cmd("normal! " .. vim.v.count - 1 .. "*")
  else
    local pattern = [[\<]] .. vim.fn.expand("<cword>") .. [[\>]]
    vim.fn.setreg("/", [[\<]] .. pattern .. [[\>]])
    vim.opt.hlsearch = true
    -- Below line is not needed anymore, with the n, N mappings defined below
    -- Move to the start of the cword,
    -- so that the next "N" will work properly.
    -- vim.fn.search(pattern, "cb")
  end
end, { noremap = true })
vim.keymap.set({ "n", "v" }, "#", function()
  if vim.v.count > 0 then
    vim.cmd("normal! " .. vim.v.count - 1 .. "#")
  else
    local pattern = [[\<]] .. vim.fn.expand("<cword>") .. [[\>]]
    vim.fn.setreg("/", [[\<]] .. pattern .. [[\>]])
    vim.opt.hlsearch = true
    vim.v.searchforward = 0
    -- Below line is not needed anymore, with the n, N mappings defined below
    -- Move to the start of the cword,
    -- so that the next "n" will work properly.
    -- vim.fn.search(pattern, "cb")
  end
end, { noremap = true })

-- Perform a find(-and-replace) on the visual selection
vim.keymap.set(
  { "n", "v" },
  "<Leader>vf",
  "<Esc>:let @/ = v:lua.GetEscapedVisual()<CR>:set hlsearch<CR>",
  { desc = "Search selected text in file", silent = true }
)
-- Perform a find-and-replace on the visual selection
vim.keymap.set(
  { "n", "v" },
  "<Leader>vh",
  "<Esc>:%s/<C-r>=v:lua.GetEscapedVisual()<CR>//gc<Left><Left><Left>",
  { desc = "Replace selected text in file" }
)
-- Perform a find-and-replace on the visual selection with the same text
-- pre-filled. Useful for minor edits.
vim.keymap.set(
  { "n", "v" },
  "<Leader>vH",
  "<Esc>:%s/<C-r>=v:lua.GetEscapedVisual()<CR>/<C-r>=v:lua.GetEscapedVisual()<CR>/gc<Left><Left><Left>",
  { desc = "Replace selected text in file (pre-filled)" }
)
function GetEscapedVisual()
  -- Function to escape special characters
  local function escape_string(str)
    str = str:gsub("[%^%$%.%*%/%\\%[%]~]", "\\%1")
    str = str:gsub("\n", "\\n")
    return str
  end

  local start_pos = vim.fn.getpos("'<")
  local end_pos = vim.fn.getpos("'>")
  local start_row = start_pos[2] - 1
  local start_col = start_pos[3] - 1
  local end_row = end_pos[2] - 1
  local end_col = end_pos[3] - 1
  local lines = vim.api.nvim_buf_get_text(0, start_row, start_col, end_row, end_col + 1, {})
  local text = table.concat(lines, "\n")
  return escape_string(text)
end

-- During search navigation with 'n' and 'N' keys, preserve the offset of the
-- cursor within the search match.
local function search_jump_with_offset(direction)
  local function within_bounds(position, bound_start, bound_end)
    local start_line, start_col = bound_start[1], bound_start[2]
    local end_line, end_col = bound_end[1], bound_end[2]
    local pos_line, pos_col = position[1], position[2]

    if pos_line < start_line or pos_line > end_line then
      return false
    elseif pos_line == start_line and pos_col < start_col then
      return false
    elseif pos_line == end_line and pos_col > end_col then
      return false
    end
    return true
  end

  local search_pattern = vim.fn.getreg("/")
  if search_pattern == "" then
    return
  end

  -- Get current cursor position, and the start, end of the current/prev match.
  -- Note: vim cursor api uses 0-indexed column number
  local cursor_pos = vim.api.nvim_win_get_cursor(0)

  -- Get the start of the current/prev match.
  -- c: accept match at cursor, b: backward search
  local match_start = vim.fn.searchpos(search_pattern, "cb")
  if match_start[1] == 0 and match_start[2] == 0 then
    return -- if no matches
  end
  match_start[2] = match_start[2] - 1 -- convert column to 0-index
  vim.api.nvim_win_set_cursor(0, match_start)

  -- Get the end (inclusive) of the match found above.
  -- c: accept match at cursor, e: get end position of the (forward) match
  local match_end = vim.fn.searchpos(search_pattern, "ce")
  match_end[2] = match_end[2] - 1 -- convert column to 0-index
  vim.api.nvim_win_set_cursor(0, cursor_pos) -- return to original pos

  -- Calculate offset if search is a single line cursor is within a match.
  local offset = { 0, 0 }
  if within_bounds(cursor_pos, match_start, match_end) then
    offset = { cursor_pos[1] - match_start[1], cursor_pos[2] - match_start[2] }
  end
  -- Perform actual movement
  if direction == "n" or direction == "N" then
    vim.cmd("normal! " .. direction)
    -- If we are trying to move in the up/left direction of the file, and if we
    -- are not at the first offset, then we need to perform the movement twice.
    -- The first movement will only move us to the start of the current match.
    local up_direction = vim.v.searchforward == 1 and "N" or "n"
    if direction == up_direction and (offset[1] > 0 or offset[2] > 0) then
      vim.cmd("normal! " .. direction)
    end
  end
  -- Go to new match and apply offset
  cursor_pos = vim.api.nvim_win_get_cursor(0)
  cursor_pos[1] = cursor_pos[1] + offset[1]
  cursor_pos[2] = cursor_pos[2] + offset[2]
  vim.api.nvim_win_set_cursor(0, cursor_pos)
end
-- Note: LazyVim remaps these keys so that 'n' always moves forward and 'N'
-- always moves backward, regardless of the actual search direction. If these
-- mappings are removed, then LazyVim's mappings take effect. If you want to
-- prevent that, then the mappings for these keys should be explicitly deleted.
vim.keymap.set("n", "n", function() search_jump_with_offset("n") end, { desc = "Next Search Result", remap = false })
vim.keymap.set("n", "N", function() search_jump_with_offset("N") end, { desc = "Prev Search Result", remap = false })
vim.keymap.set("v", "n", function() search_jump_with_offset("n") end, { desc = "Next Search Result", remap = false })
vim.keymap.set("v", "N", function() search_jump_with_offset("N") end, { desc = "Prev Search Result", remap = false })

vim.keymap.set({ "n", "v" }, "<Leader>vp", "<Esc>`[v`]", { desc = "Select previously put/yanked text" })
vim.keymap.set({ "n", "v" }, "<Leader>vq", "<Esc>:'<,'>normal @", { desc = "Run a macro on each line in visual selection separately" })
