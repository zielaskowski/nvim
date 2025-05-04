-- Useful plugin to show you pending keybinds.
-- WhichKey helps you remember your Neovim keymaps, by showing available keybindings in a popup as you type.

return {
  'folke/which-key.nvim',
  event = 'VimEnter', -- Sets the loading event to 'VimEnter'
  opts = {
    -- delay between pressing a key and opening which-key (milliseconds)
    -- this setting is independent of vim.opt.timeoutlen
    delay = 0,
    icons = {
      -- set icon mappings to true if you have a Nerd Font
      mappings = vim.g.have_nerd_font,
      -- If you are using a Nerd Font: set icons.keys to an empty table which will use the
      -- default which-key.nvim defined Nerd Font icons, otherwise define a string table
      keys = {},
    },
    --Document existing key chains
    spec = {
      { '<leader>s', group = '[S]earch' },
      { '<leader>t', group = '[T]oggle' },
    },
  },
}
