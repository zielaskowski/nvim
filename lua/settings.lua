-- [[ Setting options ]]
-- See `:help vim.opt`
-- For more options, you can see `:help option-list`

local o = vim.opt

o.number = true -- print the line number in front of each line
o.relativenumber = true -- show relative line number in front of each line
o.undofile = false -- save undo information in a file
o.ignorecase = true -- ignore case in search patterns
o.smartcase = true -- no ignore case when pattern has uppercase
o.timeoutlen = 500 -- key sequence time out time in milliseconds
o.mouse = 'a' -- Enable mouse mode, in all modes
o.showmode = false -- If in Insert, Replace or Visual mode put a message on the last line.
			-- Don't show the mode, since it's already in the status line
o.scrolloff = 10 -- Minimal number of screen lines to keep above and below the cursor.
vim.opt.confirm = true -- raise a dialog asking if you wish to save the current file(s)
vim.o.winbar = "%{%v:lua.require'nvim-navic'.get_location()%}" -- code context on top bar


-- Highlight when yanking (copying) text
-- See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

--  Sync clipboard between OS and Neovim.
--  Schedule the setting after `UiEnter` because it can increase startup-time.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.schedule(function()
  vim.opt.clipboard = 'unnamedplus'
end)

-- treesitter folding
vim.wo.foldmethod = 'expr'
vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
vim.opt.foldenable = false -- disable folding all when opening a file


-- inherited from kickstart, not reviewed
-- Enable break indent
vim.opt.breakindent = true

-- Save undo history
vim.opt.undofile = true


-- Keep signcolumn on by default
vim.opt.signcolumn = 'yes'

-- Decrease update time
vim.opt.updatetime = 250


-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Preview substitutions live, as you type!
vim.opt.inccommand = 'split'

-- Show which line your cursor is on
-- vim.opt.cursorline = true



-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

