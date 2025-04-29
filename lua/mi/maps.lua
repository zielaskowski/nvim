-- keys mapping

-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

local map = function(keys, func, desc, mode)
  mode = mode or 'n'
  if type(desc) == 'table' then
    vim.keymap.set(mode, keys, func, desc)
  elseif type(desc) == 'string' then
    vim.keymap.set(mode, keys, func, { desc = desc })
  end
end

-- Netrw (default Vim file  explorer)
map('<C-p>', vim.cmd.Ex, 'file Explore')

-- Move selection
map('<A-k>', ":m '<-2<CR>gv=gv", 'Move selection up')
map('<A-j>', ":m '>+1<CR>gv=gv", 'Move selection down')

-- indentation of visual selection
map('<Tab>', '>gv', 'indent by 1 Tab the selection', 'v')
map('<S-Tab>', '<gv', 'un-indent by 1 Tab the selection', 'v')

-- find char before and aftter word under cursor
local bonds_n_mode = function()
  local line = vim.fn.getline '.' -- get string of current line
  local col = vim.fn.col '.' -- get cursor position (column)

  -- find bounderis of 'word' under cursor. word is defined as alphanumerc_ (included underscore)
  local char_left_pos = line:sub(1, col):find '[%w_]+$' -- find word at end of string
  local _, char_right_pos = line:sub(col, -1):find '^[%w_]+' -- find word from begining  of string

  if char_left_pos == nil or char_right_pos == nil then
    return
  end

  local char_right = line:sub(char_right_pos + col, char_right_pos + col)
  local char_left = line:sub(char_left_pos - 1, char_left_pos - 1)
  return char_left, char_right
end

-- find char at begining and end of selection
local bonds_v_mode = function()
  -- refresh marks so below cmds actualy work
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Esc>', true, false, true), 'x', true)
  local sel_left = vim.fn.getpos "'<" -- retrun table {bufnum, lnum, col, off}
  local sel_right = vim.fn.getpos "'>"

  local line_start = vim.fn.getline(sel_left[2])
  local line_end = vim.fn.getline(sel_right[2])

  local char_left = line_start:sub(sel_left[3] - 1, sel_left[3] - 1)
  local char_right = line_end:sub(sel_right[3] + 1, sel_right[3] + 1)

  return char_left, char_right
end

-- switch bonding char to next in table
-- argument shall be a table like this: {"'",'"'}
local switch_char = function(c)
  local mode = vim.api.nvim_get_mode().mode
  local char_left
  local char_right
  local nc
  local prefix
  local suffix

  local char_in_list = function(str, i)
    for _, v in ipairs(c) do
      if str == string.sub(v, i, i) then
        return true
      end
    end
    return false
  end

  if mode == 'n' then
    prefix = 'ciw'
    suffix = '<Esc>p'
    char_left, char_right = bonds_n_mode()
  elseif mode == 'v' then
    prefix = 'gvc'
    suffix = '<Esc>p`[v`]'
    char_left, char_right = bonds_v_mode()
  end
  if char_left == nil or char_right == nil then
    return
  end
  if (not char_in_list(char_left, 1)) and (not char_in_list(char_right, 2)) then
    -- no char, insert first char
    -- in normal mode: ciw''<Left><Esc>p
    -- in visual mode: gvc''<Left><Esc>p`[v`]
    return prefix .. string.sub(c[1], 1, 1) .. string.sub(c[1], 2, 2) .. '<Left>' .. suffix
  end
  for i, v in ipairs(c) do
    if char_left == string.sub(v, 1, 1) and char_right == string.sub(v, 2, 2) then
      -- replace char with next from list
      if i ~= #c then -- not last item on list
        nc = string.sub(c[i + 1], 1, 1) .. string.sub(c[i + 1], 2, 2) .. '<Left>'
      else
        nc = '' -- no more chars, remove
      end
      -- in normal mode: ciw<BS><DEL>''<Left><Esc>p
      -- in visual mode: gvc<BS><DEL>''<Left><Esc>p`[v`]
      return prefix .. '<BS><DEL>' .. nc .. suffix
    end
  end
end

-- in normal mode
-- insert 'single' quot mark around current word
-- and double quote if single already there
-- in visual mode
-- insert single quot mark around current selection
-- and double quote if single already there
map("'", function()
  return switch_char { "''", '""' }
end, { expr = true, desc = 'add quote to the word or selection' }, { 'v', 'n' })
map('9', function()
  return switch_char { '()', '{}', '[]', '<>' }
end, { expr = true, desc = 'add quote to the word or selection' }, { 'v', 'n' })
