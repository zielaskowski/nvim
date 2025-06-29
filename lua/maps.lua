-- keys mapping

-- Set <space> as the leader key
-- See `:help mapleader`
-- NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
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

-- esc before functional keys binding in insert mode
-- i always forget to enter normal mode which is frustrating
map('<F1>', '<Esc><F1>', 'Esceping before debug func keybindings', 'i')
map('<F2>', '<Esc><F2>', 'Esceping before debug func keybindings', 'i')
map('<F5>', '<Esc><F5>', 'Esceping before debug func keybindings', 'i')
map('<F10>', '<Esc><F10>', 'Esceping before debug func keybindings', 'i')

-- copy again after Paste, so multiple past is possible
map('p', 'pgvy', 'Copy again pasted text', 'v')

-- Netrw (default Vim file  explorer)
map('<C-p>', vim.cmd.Ex, 'file Explore')

-- Move selection
map('<A-k>', ":m '<-2<CR>gv=gv", 'Move selection up', 'v')
map('<A-j>', ":m '>+1<CR>gv=gv", 'Move selection down', 'v')
-- Move line under cursor
map('<A-k>', ":m '<-2<CR>", 'Move line under cursor up')
map('<A-j>', ":m '>+1<CR>", 'Move line under cursor down')

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
map('<A-p>', function()
  return switch_char { '()', '{}', '[]', '<>' }
end, { expr = true, desc = 'add parenthesis to the word or selection' }, { 'v', 'n' })

local function display_DataFrame()
  -- during python debuging with DAP and debugpy
  -- display DataFrame under the cursor
  -- print(df.to_string())
  -- in floating window

  -- checl if DAP session
  local dap = require 'dap'
  if not dap.session() then
    vim.notify('DAP session must be active', vim.log.levels.WARN)
    return
  end

  local dataframe = vim.fn.expand '<cword>'
  if not dataframe or dataframe == '' then
    vim.notify('No DataFrame under the cursor', vim.log.levels.WARN)
  end

  local expr =  dataframe .. '.to_string()'
  -- current session ID
  local frame = dap.session().current_frame
  if not frame then
  	vim.notify("No current frame",vim.log.levels.ERROR)
	return
  end
  -- DAP session
  dap.session():request('evaluate',
  {
	  expression = expr,
	  context = 'repl',
	  frameId = frame.id
  }, function(err, resp)
    if err then
      vim.notify('DAP eval error: ' .. err.message, vim.log.levels.ERROR)
      return
    end
    -- split results into lines
    local lines = vim.split(resp.result or '', '\\n',{plain=true})
    -- create buffer
    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
    -- calculate win size
    local width = vim.o.columns - 4
    local height = math.min(#lines+2, vim.o.lines - 4)
    -- display win
    local win = vim.api.nvim_open_win(buf, true, {
      relative = 'editor',
      width = width,
      height = height,
      row = 2,
      col = 2,
      style = 'minimal',
      border = 'rounded',
    })
    -- do not wrap text
    vim.api.nvim_set_option_value('wrap', false, {win=win})
  end)
end

map('<leader>df', display_DataFrame, 'dispalay DataFrame during python debug session (DAP)')
