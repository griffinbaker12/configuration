-- :ResetConfig -- reload config without restarting nvim.
--
-- Scope, honestly: a full "reload everything" is not achievable in nvim.
-- Plugin setup() calls create autocmds, keymaps and highlights that a plain
-- re-require does not undo, so re-running them stacks duplicates. What this
-- does instead:
--
--   :ResetConfig           reload user.* + config.* modules, reapply colorscheme
--   :ResetConfig <plugin>  hand off to lazy's own reloader, which unloads the
--                          plugin properly before loading it again
--
-- For a change to a file under lua/plugins/, prefer `:ResetConfig <plugin>`
-- (or `:Lazy reload <plugin>`); a bare :ResetConfig will NOT re-run its setup().

local M = {}

--- Drop cached lua modules matching any of the given prefixes.
---@param prefixes string[]
---@return integer count
local function unload(prefixes)
	local n = 0
	for name, _ in pairs(package.loaded) do
		for _, prefix in ipairs(prefixes) do
			if name == prefix or name:sub(1, #prefix + 1) == prefix .. "." then
				package.loaded[name] = nil
				n = n + 1
				break
			end
		end
	end
	return n
end

--- Names of plugins lazy currently knows about, for completion.
---@return string[]
local function plugin_names()
	local ok, lazy_config = pcall(require, "lazy.core.config")
	if not ok then
		return {}
	end
	local names = {}
	for name, _ in pairs(lazy_config.plugins) do
		names[#names + 1] = name
	end
	table.sort(names)
	return names
end

function M.setup()
	vim.api.nvim_create_user_command("ResetConfig", function(opts)
		local target = vim.trim(opts.args or "")

		if target ~= "" then
			-- lazy unloads and reloads the plugin properly, including its setup()
			vim.cmd("Lazy reload " .. target)
			return
		end

		local count = unload({ "user", "config" })

		-- Re-run the settings that live outside plugin specs.
		local ok, err = pcall(function()
			require("user.remap")
			require("user.set")
		end)
		if not ok then
			vim.notify("ResetConfig failed: " .. tostring(err), vim.log.levels.ERROR)
			return
		end

		-- Reapply the colorscheme so highlight tweaks (and the italic sweep)
		-- run again.
		local scheme = vim.g.colors_name
		if scheme then
			pcall(vim.cmd.colorscheme, scheme)
		end

		vim.notify(
			("ResetConfig: cleared %d modules, reloaded user.*, reapplied %s")
				:format(count, scheme or "no colorscheme"),
			vim.log.levels.INFO
		)
	end, {
		nargs = "?",
		desc = "Reload user config; with an argument, reload that plugin via lazy",
		complete = function(arg)
			local out = {}
			for _, name in ipairs(plugin_names()) do
				if name:lower():find(arg:lower(), 1, true) then
					out[#out + 1] = name
				end
			end
			return out
		end,
	})
end

return M
