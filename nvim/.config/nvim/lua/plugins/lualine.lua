return {
	'nvim-lualine/lualine.nvim',
	dependencies = { 'nvim-tree/nvim-web-devicons' },
	config = function()
		require("lualine").setup({
			disabled_filetypes = { 'packer', 'NvimTree', "neo-tree", 'lazy' }
		})
		--vim.opt.laststatus = 3
	end
}
