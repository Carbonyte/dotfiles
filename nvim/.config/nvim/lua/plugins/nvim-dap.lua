return {
{
	"mfussenegger/nvim-dap",
	dependencies = {
		{ "stevearc/overseer.nvim", config = true }
	},
	keys = {
		{
			"<leader>ds",
			function()
				local widgets = require("dap.ui.widgets")
				widgets.centered_float(widgets.scopes, { border = "rounded" })
			end,
			desc = "DAP Scopes",
		},
		{
			"<F1>",
			function() require("dap.ui.widgets").hover(nil, { border = "rounded" }) end,
			desc = "DAP Hover",
		},
		{ "<F4>", "<CMD>DapTerminate<CR>", desc = "DAP Terminate" },
		{ "<F5>", "<CMD>DapContinue<CR>", desc = "DAP Continue" },
		{ "<F6>", function() require("dap").run_to_cursor() end, desc = "Run to Cursor" },
		{ "<F9>", "<CMD>DapToggleBreakpoint<CR>", desc = "Toggle Breakpoint" },
		{ "<F10>", "<CMD>DapStepOver<CR>", desc = "Step Over" },
		{ "<F11>", "<CMD>DapStepInto<CR>", desc = "Step Into" },
		{ "<F12>", "<CMD>DapStepOut<CR>", desc = "Step Out" },
		{ "<A-F6>", function() require("dap").run_last() end, desc = "Run Last" },
		{
			"<A-F9>",
			function()
				vim.ui.input(
					{ prompt = "Breakpoint condition: " },
					function(input) require("dap").set_breakpoint(input) end
				)
			end,
			desc = "Conditional Breakpoint",
		},
		{
			"<A-r>",
			function() require("dap").repl.toggle(nil, "tab split") end,
			desc = "Toggle DAP REPL",
		},
	},
	config = function()
		for _, group in pairs({
			"DapBreakpoint",
			"DapBreakpointCondition",
			"DapBreakpointRejected",
			"DapLogPoint",
		}) do
			vim.fn.sign_define(group, { text = "●", texthl = group })
		end

		local dap = require("dap")
		-- Setup

		-- Decides when and how to jump when stopping at a breakpoint
		-- The order matters!
		--
		-- (1) If the line with the breakpoint is visible, don't jump at all
		-- (2) If the buffer is opened in a tab, jump to it instead
		-- (3) Else, create a new tab with the buffer
		--
		-- This avoid unnecessary jumps
		dap.defaults.fallback.switchbuf = "usevisible,usetab,newtab"

		dap.configurations.cpp = {
			{
				name = "Launch file",
				type = "codelldb",
				request = "launch",
				program = function()
					return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
				end,
				cwd = '${workspaceFolder}',
				stopOnEntry = false,
			},
		}
		dap.configurations.c = dap.configurations.cpp

		dap.adapters.codelldb = {
			type = "server",
			port = "${port}",
			executable = {
				command = "codelldb",
				args = {"--port", "${port}"}
			}
		}
	end
},
{
	"rcarriga/nvim-dap-ui",
	dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
	config = function()
		local dap, dapui = require("dap"), require("dapui")
		dapui.setup()

		dap.listeners.after.event_initialized["dapui_config"] = function()
			dapui.open()
		end
		dap.listeners.before.event_terminated["dapui_config"] = function()
			dapui.close()
		end
		dap.listeners.before.event_exited["dapui_config"] = function()
			dapui.close()
		end
	end
}
}

