-- provide information about cursor location context in status bar
-- class>module>function

return {
  'SmiteshP/nvim-navic',
  dependencies = { 'neovim/nvim-lspconfig' },
  config = function()
    local navic = require 'nvim-navic'
    -- attach navic to any lsp server with capabilities
    vim.api.nvim_create_autocmd('LspAttach', {
      callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        local bufnr = args.buf

        if client.server_capabilities.documentSymbolProvider then
          navic.attach(client, bufnr)
        end
      end,
    })
  end,
}
