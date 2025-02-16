local Util = {}

function Util.keymap(lhs, rhs, opts, mode)
	opts = type(opts) == "string" and { desc = opts } or opts
	mode = mode or "n"

	vim.keymap.set(mode, lhs, rhs, opts)
end

function Util.neotreeToggle()
	if vim.g.neotreeEnabled then
		vim.cmd("Neotree show reveal filesystem left")
	else
		vim.cmd("Neotree close")
	end
end

return Util
