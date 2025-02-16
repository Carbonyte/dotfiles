return {
	"nvim-treesitter/nvim-treesitter",
	version = "0.9.x",
	build = ":TSUpdate",
	config = function()
		local configs = require("nvim-treesitter.configs")

		configs.setup({
			ensure_installed = {
				"c", "cpp", "make",
				"lua", "vim", "vimdoc",
				"javascript", "html", "css", "json", "typescript",
				"python",
				"rust",
				"bash", "fish",
				"markdown", "markdown_inline",
				"zig"
			},
			auto_install = true,
			sync_install = false,
			highlight = { enable = true },
			indent = { enable = false },
		})
	end
}

