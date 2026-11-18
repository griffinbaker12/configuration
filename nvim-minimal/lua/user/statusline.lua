-- nvim's default status line (file name, flags, line,col, %) plus this
-- buffer's error and warning counts, using the same icons as the sign column.
-- nvim 0.12 has vim.diagnostic.status() for this; 0.11 doesn't.
local M = {}

local severity = vim.diagnostic.severity
local parts = {
	{ severity.ERROR, "StatusLineDiagError", "DiagnosticError" },
	{ severity.WARN, "StatusLineDiagWarn", "DiagnosticWarn" },
}

-- Diagnostic colors on the status line's background (the plain Diagnostic*
-- groups would paint their own background, or none, in the middle of the bar).
local function set_highlights()
	local bar = vim.api.nvim_get_hl(0, { name = "StatusLine", link = false })
	for _, p in ipairs(parts) do
		local diag = vim.api.nvim_get_hl(0, { name = p[3], link = false })
		vim.api.nvim_set_hl(0, p[2], {
			fg = diag.fg,
			bg = bar.bg,
			ctermfg = diag.ctermfg,
			ctermbg = bar.ctermbg,
		})
	end
end

function M.diagnostics()
	local buf = vim.api.nvim_win_get_buf(vim.g.statusline_winid or 0)
	local counts = vim.diagnostic.count(buf)
	-- signs is just `true` until lsp.lua sets its icons, so check the type.
	local signs = vim.diagnostic.config().signs
	signs = type(signs) == "table" and signs.text or {}
	local out = {}
	for _, p in ipairs(parts) do
		local n = counts[p[1]]
		if n and n > 0 then
			local icon = vim.trim(signs[p[1]] or (p[1] == severity.ERROR and "E" or "W"))
			table.insert(out, "%#" .. p[2] .. "#" .. icon .. " " .. n .. "%*")
		end
	end
	return #out > 0 and table.concat(out, " ") .. "  " or ""
end

function M.setup()
	vim.o.statusline = "%<%f %h%w%m%r%=%{%v:lua.require'user.statusline'.diagnostics()%}%-14.(%l,%c%V%) %P"

	local group = vim.api.nvim_create_augroup("UserStatusline", { clear = true })
	vim.api.nvim_create_autocmd("ColorScheme", { group = group, callback = set_highlights })
	vim.api.nvim_create_autocmd("DiagnosticChanged", {
		group = group,
		callback = function()
			vim.cmd.redrawstatus({ bang = true })
		end,
	})
	set_highlights()
end

return M
