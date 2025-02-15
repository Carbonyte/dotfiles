local keymap = require("util").keymap

-- Telescope
local builtin = require("telescope.builtin")
keymap("<C-p>", builtin.find_files, {desc = "Telescope find files"})
keymap('<leader>fg', builtin.live_grep, {desc = "Telescope live grep"})
keymap('<leader>fb', builtin.buffers, {desc = 'Telescope buffers'})
keymap('<leader>fh', builtin.help_tags, {desc = 'Telescope help tags'})

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
keymap("T0", "<CMD>tablast<CR>", "Goto last tab")
keymap("T.", "<CMD>tabnext<CR>", "Goto next tab")
keymap("T,", "<CMD>tabprev<CR>", "Goto prev tab")
keymap("T-", "<CMD>tabm-<CR>", "Move tab to the left")
keymap("T=", "<CMD>tabm+<CR>", "Move tab to the right")
keymap("Tn", "<CMD>tabe<CR>", "Open new tab")
keymap("Ts", "<CMD>tab split<CR>", "Clone window in new tab")

