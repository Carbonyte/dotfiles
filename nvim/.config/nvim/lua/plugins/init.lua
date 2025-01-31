return {
--[[	{
		"loctvl842/monokai-pro.nvim",
		name = "monokai-pro", 
		config = function(_, opts)
			require("monokai-pro").setup()
		end
	},]]
	{ 
		"catppuccin/nvim", name = "catppuccin", priority = 1000,
		config = function()
			require("catppuccin").setup()
			vim.cmd.colorscheme = "catppuccin"
		end
	}
}
