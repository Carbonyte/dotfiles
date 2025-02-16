local keymap = require("util").keymap

-- Telescope
local builtin = require("telescope.builtin")
keymap("<leader>ff", builtin.find_files, "Telescope find files")
keymap('<leader>fg', builtin.live_grep, "Telescope live grep")
keymap('<leader>fb', builtin.buffers, 'Telescope buffers')
keymap('<leader>fh', builtin.help_tags, 'Telescope help tags')

-- Navigate windows
keymap('<c-k>', ':wincmd k<CR>', { desc = "Up window" })
keymap('<c-j>', ':wincmd j<CR>', { desc = "Down window" })
keymap('<c-h>', ':wincmd h<CR>', { desc = "Left window" })
keymap('<c-l>', ':wincmd l<CR>', { desc = "Right window" })

keymap('<c-up>', ':wincmd k<CR>', { desc = "Up window" })
keymap('<c-down>', ':wincmd j<CR>', { desc = "Down window" })
keymap('<c-left>', ':wincmd h<CR>', { desc = "Left window" })
keymap('<c-right>', ':wincmd l<CR>', { desc = "Right window" })

-- Navigate tabs
for i = 1, 9 do
	keymap(string.format("T%s", i), string.format("%sgt", i), string.format("Goto tab %s", i))
end
keymap("T0", ":tablast<CR>", "Goto last tab")
keymap("T.", ":tabnext<CR>", "Goto next tab")
keymap("T,", ":tabprev<CR>", "Goto prev tab")
keymap("T-", ":tabm-<CR>", "Move tab to the left")
keymap("T=", ":tabm+<CR>", "Move tab to the right")
keymap("Tn", ":tabe<CR>", "Open new tab")
keymap("Ts", ":tab split<CR>", "Clone window in new tab")
keymap("Tq", ":tabclose<CR>", "Close tab")

keymap("<leader>t", ":lua vim.g.neotreeEnabled = not vim.g.neotreeEnabled; require('util').neotreeToggle()<CR>", "Toggle filesystem tree")
