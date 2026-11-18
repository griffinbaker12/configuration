-- :Font [name] switches kitty's font between the three below. It rewrites the
-- font lines in kitty.conf (so the choice sticks for new windows) and tells
-- every running kitty to reload its config. No name opens a picker.

local M = {}

local fonts = {
	["JetBrains Mono"] = { "JetBrainsMono-Regular", "JetBrainsMono-Bold", "JetBrainsMono-Italic", "JetBrainsMono-BoldItalic" },
	["Berkeley Mono"] = { "BerkeleyMono-Regular", "BerkeleyMono-Bold", "BerkeleyMono-Oblique", "BerkeleyMono-BoldOblique" },
	["SF Mono"] = { "SFMono-Regular", "SFMono-Bold", "SFMono-RegularItalic", "SFMono-BoldItalic" },
}
local names = { "JetBrains Mono", "Berkeley Mono", "SF Mono" }
local keys = { "font_family", "bold_font", "italic_font", "bold_italic_font" }

local function kitty_conf()
	-- ~/.config/kitty/kitty.conf is a symlink into dotfiles; edit the real file.
	return vim.uv.fs_realpath(vim.fn.expand("~/.config/kitty/kitty.conf"))
end

local function current(path)
	for _, line in ipairs(vim.fn.readfile(path)) do
		local face = line:match("^font_family%s+(%S+)")
		if face then
			for _, name in ipairs(names) do
				if fonts[name][1] == face then
					return name
				end
			end
		end
	end
end

--- Point kitty.conf's four font lines at `name`. Returns an error string on failure.
---@param name string
---@param path string
function M.write(name, path)
	local faces = fonts[name]
	local lines = vim.fn.readfile(path)
	local replaced = 0
	for i, line in ipairs(lines) do
		for k, key in ipairs(keys) do
			if line:match("^" .. key .. "%s") then
				lines[i] = string.format("%-16s %s", key, faces[k])
				replaced = replaced + 1
			end
		end
	end
	if replaced ~= #keys then
		return ("expected %d font lines in %s, found %d"):format(#keys, path, replaced)
	end
	vim.fn.writefile(lines, path)
end

-- Kitty reloads kitty.conf on SIGUSR1. Found via ps, not pgrep: macOS lists
-- the process as /Applications/kitty.app/Contents/MacOS/kitty, which
-- `pgrep -x kitty` never matches.
local function reload_kitty()
	for _, line in ipairs(vim.fn.systemlist({ "ps", "-axo", "pid=,comm=" })) do
		local pid, comm = line:match("^%s*(%d+)%s+(.+)$")
		if comm and comm:match("/kitty$") then
			vim.uv.kill(tonumber(pid), "sigusr1")
		end
	end
end

local function apply(name)
	local path = kitty_conf()
	if not path then
		return vim.notify("Font: no ~/.config/kitty/kitty.conf", vim.log.levels.ERROR)
	end
	local err = M.write(name, path)
	if err then
		return vim.notify("Font: " .. err, vim.log.levels.ERROR)
	end
	reload_kitty()
	vim.notify("Font: kitty now uses " .. name)
end

function M.setup()
	vim.api.nvim_create_user_command("Font", function(opts)
		local arg = vim.trim(opts.args)
		if arg == "" then
			local path = kitty_conf()
			local now = path and current(path)
			vim.ui.select(names, {
				prompt = "Kitty font",
				format_item = function(name)
					return name == now and (name .. "  (current)") or name
				end,
			}, function(choice)
				if choice then
					apply(choice)
				end
			end)
			return
		end
		for _, name in ipairs(names) do
			if name:lower() == arg:lower() then
				return apply(name)
			end
		end
		vim.notify("Font: pick one of " .. table.concat(names, ", "), vim.log.levels.ERROR)
	end, {
		nargs = "*",
		desc = "Switch kitty's font",
		complete = function(lead)
			return vim.tbl_filter(function(name)
				return name:lower():find(lead:lower(), 1, true) == 1
			end, names)
		end,
	})
end

return M
