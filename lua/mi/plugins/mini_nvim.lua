--[[
Library of 40+ independent Lua modules improving overall Neovim (version 0.9 and higher) experience with minimal effort. They all share same configuration approaches and general design principles.

Think about this project as "Swiss Army knife" among Neovim plugins: it has many different independent tools (modules) suitable for most common tasks. Each module can be used separately without any startup and usage overhead.
]]
return {
  'echasnovski/mini.nvim',
  config = function()
    -- closing pairs: <([{'"``"'}])>
    require('mini.pairs').setup {
      mappings = {
        ['<'] = { action = 'open', pair = '<>', neigh_pattern = '[^\\].' },
      },
    }
    require('mini.icons').setup() -- allow mini.statusline to use icons
    require('mini.statusline').setup {
      use_icons = true,
    }
  end,
}
