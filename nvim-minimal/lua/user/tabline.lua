-- Tab labels show just the file name ("main.py") instead of nvim's default
-- one-letter-per-folder path ("a/m/a/s/main.py"). When two tabs would show
-- the same label, both add parent folders until they differ:
--   ai-api/src/main.py   deid-labeler/src/main.py
local M = {}

-- Path components of the tab's current buffer, e.g. {"Users", ..., "main.py"}.
local function components(tabnr)
	local bufnr = vim.fn.tabpagebuflist(tabnr)[vim.fn.tabpagewinnr(tabnr)]
	local name = vim.fn.bufname(bufnr)
	if name == "" then
		return { "[No Name]" }, bufnr
	end
	-- oil:///path/to/dir/ -> /path/to/dir, shown as "dir/"
	local is_dir = name:sub(-1) == "/"
	name = vim.fn.fnamemodify((name:gsub("^%a+://", "")), ":p"):gsub("/$", "")
	local parts = vim.split(name, "/", { trimempty = true })
	if is_dir and #parts > 0 then
		parts[#parts] = parts[#parts] .. "/"
	end
	return parts, bufnr
end

local function label(parts, depth)
	return table.concat(parts, "/", math.max(1, #parts - depth + 1))
end

function M.render()
	local tabs = {}
	for i = 1, vim.fn.tabpagenr("$") do
		local parts, bufnr = components(i)
		tabs[i] = { parts = parts, bufnr = bufnr, depth = 1 }
	end

	-- Lengthen colliding labels one folder at a time until all are distinct
	-- (or a label already shows its whole path).
	for _ = 1, 20 do
		local seen = {}
		for _, tab in ipairs(tabs) do
			tab.label = label(tab.parts, tab.depth)
			seen[tab.label] = (seen[tab.label] or 0) + 1
		end
		local grew = false
		for _, tab in ipairs(tabs) do
			if seen[tab.label] > 1 and tab.depth < #tab.parts then
				tab.depth = tab.depth + 1
				grew = true
			end
		end
		if not grew then
			break
		end
	end

	local current = vim.fn.tabpagenr()
	local out = {}
	for i, tab in ipairs(tabs) do
		local text = tab.label .. (vim.bo[tab.bufnr].modified and " +" or "")
		local hl = i == current and "%#TabLineSel#" or "%#TabLine#"
		-- %{n}T makes the label clickable
		table.insert(out, hl .. "%" .. i .. "T " .. text .. " ")
	end
	return table.concat(out) .. "%#TabLineFill#%T"
end

function M.setup()
	vim.o.tabline = "%!v:lua.require'user.tabline'.render()"
end

return M
