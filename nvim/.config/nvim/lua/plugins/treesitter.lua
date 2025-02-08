return {
	"nvim-treesitter/nvim-treesitter",
	version = "0.9.x",
	build = ":TSUpdate",
	config = function()
		local configs = require("nvim-treesitter.configs")

		configs.setup({
			ensure_installed = {
				"c", "lua", "vim", "vimdoc", "query", "javascript", "html",
				"cpp", "rust", "bash"
			},
			auto_install = true,
			sync_install = false,
			highlight = { enable = true },
			indent = { enable = true },
		})
	end
}

