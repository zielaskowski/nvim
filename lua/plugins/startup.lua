return {
  'startup-nvim/startup.nvim',
  dependencies = { 'nvim-telescope/telescope.nvim', 'nvim-telescope/telescope-file-browser.nvim' },
  config = function()
    require('startup').setup { theme = 'my_dashboard' }
  end,
}
