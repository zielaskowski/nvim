-- provide information about cursor location context in status bar
-- class>module>function
return{
	'SmiteshP/nvim-navic',
	dependencies={'neovim/nvim-lspconfig'},
	config=function ()
		local navic = require('nvim-navic')
		require('lspconfig').pyright.setup({
			on_attach = function (client,bufnr)
				navic.attach(client,bufnr)
			end
		})
	end
}
