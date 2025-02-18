local keymap = require("util").keymap

--- TELESCOPE ---
local builtin = require("telescope.builtin")
keymap("<leader>ff", builtin.find_files, "Telescope [f]ind [f]iles")
keymap('<leader>fg', builtin.live_grep, "Telescope [f]ind [g]rep")
keymap('<leader>fb', builtin.buffers, 'Telescope [f]ind [b]uffers')
keymap('<leader>fh', builtin.help_tags, 'Telescope [f]ind [h]elp tags')

--- NAVIGATE WINDOWS ---
keymap('<c-k>', ':wincmd k<CR>', { desc = "Up window" })
keymap('<c-j>', ':wincmd j<CR>', { desc = "Down window" })
keymap('<c-h>', ':wincmd h<CR>', { desc = "Left window" })
keymap('<c-l>', ':wincmd l<CR>', { desc = "Right window" })

keymap('<c-up>', ':wincmd k<CR>', { desc = "Up window" })
keymap('<c-down>', ':wincmd j<CR>', { desc = "Down window" })
keymap('<c-left>', ':wincmd h<CR>', { desc = "Left window" })
keymap('<c-right>', ':wincmd l<CR>', { desc = "Right window" })

--- TABS ---
for i = 1, 9 do
	keymap(string.format("T%s", i), string.format("%sgt", i), string.format("[T]ab [%s]", i))
end
keymap("T0", ":tablast<CR>", "[T]ab last")
keymap("TT", ":tabnext<CR>", "[T]ab next")
keymap("Tt", ":tabprev<CR>", "[T]ab prev")
keymap("T-", ":tabm-<CR>", "[T]ab to the left")
keymap("T=", ":tabm+<CR>", "[T]ab to the right")
keymap("Tn", ":tabe<CR>", "[T]ab [n]ew")
keymap("Ts", ":tab split<CR>", "[T]ab [s]plit")
keymap("Tq", ":tabclose<CR>", "[T]ab [q]uit")

--- TOGGLES ---
keymap("<leader>tt", ":lua vim.g.neotreeEnabled = not vim.g.neotreeEnabled; require('util').neotreeToggle()<CR>", "[T]oggle [T]ree")

--- LSP SHORTCUTS ---
vim.api.nvim_create_autocmd('LspAttach', {
	group = vim.api.nvim_create_augroup(
		'kickstart-lsp-attach',
		{ clear = true }
	),
	callback = function(event)
		-- Jump to the definition of the word under your cursor.
		--	This is where a variable was first declared, or where a function is defined, etc.
		--	To jump back, press <C-t>.
		keymap('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')

		-- Find references for the word under your cursor.
		keymap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')

		-- Jump to the implementation of the word under your cursor.
		--	Useful when your language has ways of declaring types without an actual implementation.
		keymap('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')

		-- Jump to the type of the word under your cursor.
		--	Useful when you're not sure what type a variable is and you want to see
		--	the definition of its *type*, not where it was *defined*.
		--	NOTE: this overrides a default keybinding (goto next tab).
		keymap('gt', require('telescope.builtin').lsp_type_definitions, '[G]oto Type')

		-- Fuzzy find all the symbols in your current document.
		--	Symbols are things like variables, functions, types, etc.
		keymap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')

		-- Fuzzy find all the symbols in your current workspace.
		--	Similar to document symbols, except searches over your entire project.
		keymap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

		-- Rename the variable under your cursor.
		--	Most Language Servers support renaming across files, etc.
		keymap('<leader>cr', vim.lsp.buf.rename, '[C]ode [R]ename')

		-- Execute a code action, usually your cursor needs to be on top of an error
		-- or a suggestion from your LSP for this to activate.
		keymap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction', { 'n', 'x' })

		-- WARN: This is not Goto Definition, this is Goto Declaration.
		--	For example, in C this would take you to the header.
		keymap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

		local client = vim.lsp.get_client_by_id(event.data.client_id)

		-- The following code creates a keymap to toggle inlay hints in your
		-- code, if the language server you are using supports them
		--
		-- This may be unwanted, since they displace some of your code
		if client and client.supports_method('textDocument/inlayHint') then
			keymap('<leader>th', function()
				vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
			end, '[T]oggle Inlay [H]ints')
		end
	end
})
--- TRANSFORM COMMANDS ---
keymap('tu', 'gu', { desc = '[T]ransform lowercase', noremap = true }, {'n', 'v'})
keymap('tU', 'gU', { desc = '[T]ransform uppercase', noremap = true }, {'n', 'v'})



