-- [[ Setting options ]]
-- See `:help vim.opt`
-- For more options, you can see `:help option-list`

local o = vim.opt

o.number = true 	-- print the line number in front of each line
o.relativenumber = true -- show relative line number in front of each line
o.undofile = false 	-- save undo information in a file
o.ignorecase = true 	-- ignore case in search patterns
o.smartcase = true 	-- no ignore case when pattern has uppercase
o.timeoutlen = 500 	-- key sequence time out time in milliseconds
o.mouse = 'a' 		-- Enable mouse mode, in all modes
o.showmode = false 	-- If in Insert, Replace or Visual mode put a message on the last line.
			-- Don't show the mode, since it's already in the status line

-- Highlight when yanking (copying) text
-- See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Sync clipboard between OS and Neovim.
--  Schedule the setting after `UiEnter` because it can increase startup-time.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.schedule(function()
  vim.opt.clipboard = 'unnamedplus'
end)
