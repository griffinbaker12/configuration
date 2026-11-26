-- :Theme -- pick a colorscheme variant; the choice is saved and used on every
-- start. No argument opens a picker; :Theme sonokai-truecolor switches directly.
--
-- To add a variant, add an entry to M.themes:
--   name          what you type / pick
--   description   shown next to the name in the picker
--   colorscheme   passed to :colorscheme
--   termguicolors true = exact hex colors from the theme; false = 256-color
--                 palette numbers, which kitty/sonokai.conf maps to sonokai's
--                 hex values (so only the default sonokai style matches kitty)
--   globals       vim.g values set before loading, e.g. { sonokai_style = "atlantis" }
local M = {}

M.themes = {
	{
		name = "sonokai",
		description = "256 colors, painted by kitty's sonokai palette",
		colorscheme = "sonokai",
		termguicolors = false,
		globals = { sonokai_style = "default" },
	},
	{
		name = "sonokai-truecolor",
		description = "exact hex colors from sonokai (termguicolors on)",
		colorscheme = "sonokai",
		termguicolors = true,
		globals = { sonokai_style = "default" },
	},
}

local state_file = vim.fn.stdpath("state") .. "/theme"

local function find(name)
	for _, theme in ipairs(M.themes) do
		if theme.name:lower() == name:lower() then
			return theme
		end
	end
end

local function saved()
	local ok, lines = pcall(vim.fn.readfile, state_file)
	return ok and lines[1] and find(lines[1]) or nil
end

local function apply(theme)
	for key, value in pairs(theme.globals or {}) do
		vim.g[key] = value
	end
	vim.o.termguicolors = theme.termguicolors
	vim.cmd.colorscheme(theme.colorscheme)
	M.current = theme.name
end

-- Called from lua/plugins/colorscheme.lua once the colorscheme plugin is set up.
function M.load()
	apply(saved() or M.themes[1])
end

local function switch(theme)
	apply(theme)
	vim.fn.mkdir(vim.fn.fnamemodify(state_file, ":h"), "p")
	vim.fn.writefile({ theme.name }, state_file)
	vim.notify("Theme: " .. theme.name)
end

function M.setup()
	vim.api.nvim_create_user_command("Theme", function(opts)
		local arg = vim.trim(opts.args)
		if arg == "" then
			vim.ui.select(M.themes, {
				prompt = "Theme",
				format_item = function(theme)
					local mark = theme.name == M.current and "  (current)" or ""
					return theme.name .. "  " .. theme.description .. mark
				end,
			}, function(choice)
				if choice then
					switch(choice)
				end
			end)
			return
		end
		local theme = find(arg)
		if not theme then
			local names = vim.tbl_map(function(t)
				return t.name
			end, M.themes)
			return vim.notify("Theme: pick one of " .. table.concat(names, ", "), vim.log.levels.ERROR)
		end
		switch(theme)
	end, {
		nargs = "?",
		desc = "Switch colorscheme variant",
		complete = function(lead)
			local names = {}
			for _, theme in ipairs(M.themes) do
				if theme.name:lower():find(lead:lower(), 1, true) == 1 then
					table.insert(names, theme.name)
				end
			end
			return names
		end,
	})
end

return M
