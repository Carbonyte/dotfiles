local map = require("util").keymap
local res = {}

local isVersion10 = vim.version.cmp(vim.version(), {0, 10}) >= 0
if not isVersion10 then
	res[#res+1] = {
		"folke/neodev.nvim", opts = {},
		config = function()
			require("neodev").setup({})
		end
	}
else
	res[#res+1] = {
		'folke/lazydev.nvim',
		ft = 'lua',
		opts = {
			library = {
				-- Load luvit types when the `vim.uv` word is found
				{ path = '${3rd}/luv/library', words = { 'vim%.uv' } },
				{ "nvim-dap-ui" }
			},
		}
	}
end

res[#res+1] = {
	-- Main LSP Configuration
	'neovim/nvim-lspconfig',
	dependencies = {
		{ 'mason-org/mason.nvim', version = "^1.0.0", opts = {} },
		{ 'williamboman/mason-lspconfig.nvim', version = "^1.0.0"},
		'WhoIsSethDaniel/mason-tool-installer.nvim',

		-- Useful status updates for LSP.
		{ 'j-hui/fidget.nvim', opts = {} },

		-- Allows extra capabilities provided by nvim-cmp
		'hrsh7th/cmp-nvim-lsp',
	},
	config = function()
		-- This function gets run when an LSP attaches to a particular buffer.
		vim.api.nvim_create_autocmd('LspAttach', {
			group = vim.api.nvim_create_augroup(
				'kickstart-lsp-attach',
				{ clear = true }
			),
			callback = function(event)
				-- The following two autocommands are used to highlight references of the
				-- word under your cursor when your cursor rests there for a little while.
				--		See `:help CursorHold` for information about when this is executed
				--
				-- When you move your cursor, the highlights will be cleared (the second autocommand).
				local client = vim.lsp.get_client_by_id(event.data.client_id)
				if client and client.supports_method('textDocument/documentHighlight') then
					local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
					vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
						buffer = event.buf,
						group = highlight_augroup,
						callback = vim.lsp.buf.document_highlight,
					})

					vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
						buffer = event.buf,
						group = highlight_augroup,
						callback = vim.lsp.buf.clear_references,
					})

					vim.api.nvim_create_autocmd('LspDetach', {
						group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
						callback = function(event2)
							vim.lsp.buf.clear_references()
							vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
						end,
					})
				end
			end,
		})

		-- Change diagnostic symbols in the sign column (gutter)
		if vim.g.have_nerd_font then
			local signs = { ERROR = '', WARN = '', INFO = '', HINT = '' }
			local diagnostic_signs = {}
			for type, icon in pairs(signs) do
				diagnostic_signs[vim.diagnostic.severity[type]] = icon
			end
			vim.diagnostic.config { signs = { text = diagnostic_signs } }
		end

		-- LSP servers and clients are able to communicate to each other what features they support.
		--	By default, Neovim doesn't support everything that is in the LSP specification.
		--	When you add nvim-cmp, luasnip, etc. Neovim now has *more* capabilities.
		--	So, we create new capabilities with nvim cmp, and then broadcast that to the servers.
		local capabilities = vim.lsp.protocol.make_client_capabilities()
		capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

		-- Enable the following language servers
		--	Feel free to add/remove any LSPs that you want here. They will automatically be installed.
		--
		--	Add any additional override configuration in the following tables. Available keys are:
		--	- cmd (table): Override the default command used to start the server
		--	- filetypes (table): Override the default list of associated filetypes for the server
		--	- capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
		--	- settings (table): Override the default settings passed when initializing the server.
		--				For example, to see the options for `lua_ls`, you could go to: https://luals.github.io/wiki/settings/
		local servers = {
			-- clangd = {},
			-- gopls = {},
			-- pyright = {},
			rust_analyzer = {},
			-- ... etc. See `:help lspconfig-all` for a list of all the pre-configured LSPs
			--
			-- Some languages (like typescript) have entire language plugins that can be useful:
			--		https://github.com/pmizio/typescript-tools.nvim
			--
			-- But for many setups, the LSP (`ts_ls`) will work just fine
			-- ts_ls = {},
			--

			lua_ls = {
				-- cmd = { ... },
				-- filetypes = { ... },
				-- capabilities = {},
				settings = {
					Lua = {
						completion = {
							callSnippet = 'Replace',
						},
						-- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
						diagnostics = { disable = { 'missing-fields' } },
					},
				},
			},
		}

		-- Ensure the servers and tools above are installed
		--
		-- To check the current status of installed tools and/or manually install
		-- other tools, you can run
		--		:Mason
		--
		-- You can press `g?` for help in this menu.
		--
		-- `mason` had to be setup earlier: to configure its options see the
		-- `dependencies` table for `nvim-lspconfig` above.
		--
		-- You can add other tools here that you want Mason to install
		-- for you, so that they are available from within Neovim.
		local ensure_installed = vim.tbl_keys(servers or {})
		vim.list_extend(ensure_installed, {
			'stylua', -- Used to format Lua code
		})
		require('mason-tool-installer').setup { ensure_installed = ensure_installed }

		require('mason-lspconfig').setup {
			handlers = {
				function(server_name)
					local server = servers[server_name] or {}
					-- This handles overriding only values explicitly passed
					-- by the server configuration above. Useful when disabling
					-- certain features of an LSP (for example, turning off formatting for ts_ls)
					server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
					require('lspconfig')[server_name].setup(server)
				end,
			},
			}
	end,
}

-- Autocompletion
res[#res + 1] = {
	'hrsh7th/nvim-cmp',
	event = 'InsertEnter',
	dependencies = {
		{
			'L3MON4D3/LuaSnip',
			build = (function()
				if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
					return
				end
				return 'make install_jsregexp'
			end)(),
			dependencies = {
				-- `friendly-snippets` contains a variety of premade snippets
				-- See: https://github.com/rafamadriz/friendly-snippets
				-- {
				--	 'rafamadriz/friendly-snippets',
				--	 config = function()
				--		 require('luasnip.loaders.from_vscode').lazy_load()
				--	 end,
				-- },
			},
		},
		'saadparwaiz1/cmp_luasnip',

		-- Adds other completion capabilities.
		--	nvim-cmp does not ship with all sources by default. They are split
		--	into multiple repos for maintenance purposes.
		'hrsh7th/cmp-nvim-lsp',
		'hrsh7th/cmp-path',
	},
	config = function()
		-- See `:help cmp`
		local cmp = require 'cmp'
		local luasnip = require 'luasnip'
		luasnip.config.setup {}

		cmp.setup {
			snippet = {
				expand = function(args)
					luasnip.lsp_expand(args.body)
				end,
			},
			completion = { completeopt = 'menu,menuone,noinsert' },

			-- For an understanding of why these mappings were
			-- chosen, you will need to read `:help ins-completion`
			mapping = cmp.mapping.preset.insert {
				-- Select the [n]ext item
				--['<C-n>'] = cmp.mapping.select_next_item(),
				-- Select the [p]revious item
				--['<C-p>'] = cmp.mapping.select_prev_item(),

				-- Scroll the documentation window [b]ack / [f]orward
				['<C-b>'] = cmp.mapping.scroll_docs(-4),
				['<C-f>'] = cmp.mapping.scroll_docs(4),

				-- Accept ([c]onfirm) the completion.
				--	This will auto-import if your LSP supports it.
				--	This will expand snippets if the LSP sent a snippet.
				['<C-c>'] = cmp.mapping.confirm { select = true },

				-- If you prefer more traditional completion keymaps,
				-- you can uncomment the following lines
				-- ['<CR>'] = cmp.mapping.confirm { select = true },
				['<Tab>'] = cmp.mapping.select_next_item(),
				['<S-Tab>'] = cmp.mapping.select_prev_item(),

				-- Manually trigger a completion from nvim-cmp.
				--	Generally you don't need this, because nvim-cmp will display
				--	completions whenever it has completion options available.
				['<C-Space>'] = cmp.mapping.complete {},

				-- Think of <c-l> as moving to the right of your snippet expansion.
				--	So if you have a snippet that's like:
				--	function $name($args)
				--		$body
				--	end
				--
				-- <c-l> will move you to the right of each of the expansion locations.
				-- <c-h> is similar, except moving you backwards.
				['<C-l>'] = cmp.mapping(function()
					if luasnip.expand_or_locally_jumpable() then
						luasnip.expand_or_jump()
					end
				end, { 'i', 's' }),
				['<C-h>'] = cmp.mapping(function()
					if luasnip.locally_jumpable(-1) then
						luasnip.jump(-1)
					end
				end, { 'i', 's' }),

			},
			sources = {
				{
					name = 'lazydev',
					-- set group index to 0 to skip loading LuaLS completions as lazydev recommends it
					group_index = 0,
				},
				{ name = 'nvim_lsp' },
				{ name = 'luasnip' },
				{ name = 'path' },
			},
		}
	end,
}

return res
