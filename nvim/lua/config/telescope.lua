local dump = require("helpers.dump").dump
local pickers = require("telescope.pickers")
local finders = require("telescope.finders")

local M = {}

function construct_table_args(prompt)
	local pieces = vim.split(prompt, "  ")
	local args = { "rg" }
	print("pieces", dump(pieces))
	if pieces[1] then
		table.insert(args, "-e")
		table.insert(args, pieces[1])
	end
	if pieces[2] then
		table.insert(args, "-g")
		table.insert(args, pieces[2])
	end
	-- dump("args" .. dump(args))
end

local live_multigrep = function(opts)
	opts = opts or {}
	opts.cwd = opts.cwd or vim.uv.cwd()

	finders.new_async_job({
		command_generator = function(prompt)
			if not prompt or prompt == "" then
				return nil
			end
			print(prompt)
			construct_table_args(prompt)
		end,
	})
end

M.setup = function() end

return M
