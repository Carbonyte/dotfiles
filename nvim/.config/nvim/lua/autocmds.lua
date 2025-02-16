local util = require("util")

vim.api.nvim_create_autocmd({"TabEnter", "VimEnter"}, {
	callback = util.neotreeToggle
})
