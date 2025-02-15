local Util = {}

function Util.keymap(lhs, rhs, opts, mode)
	opts = type(opts) == "string" and { desc = opts } or opts
	mode = mode or "n"

	vim.keymap.set(mode, lhs, rhs, opts)
end

return Util
