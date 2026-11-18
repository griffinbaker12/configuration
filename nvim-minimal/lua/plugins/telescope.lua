-- <leader>ps: live grep where two spaces separate the pattern from file
-- globs, each extra piece adding another -g, e.g.
--   pypdf  poetry.lock  !.claude/**  ->  rg -e pypdf -g poetry.lock -g !.claude/**
local function live_multigrep(opts)
	local pickers = require("telescope.pickers")
	local finders = require("telescope.finders")
	local make_entry = require("telescope.make_entry")
	local conf = require("telescope.config").values

	opts = opts or {}
	opts.cwd = opts.cwd or vim.uv.cwd()

	local finder = finders.new_async_job({
		command_generator = function(prompt)
			if not prompt or prompt == "" then
				return nil
			end
			local pieces = vim.split(prompt, "  ")
			local args = { "rg" }
			if pieces[1] then
				vim.list_extend(args, { "-e", pieces[1] })
			end
			for i = 2, #pieces do
				if pieces[i] ~= "" then
					vim.list_extend(args, { "-g", vim.trim(pieces[i]) })
				end
			end
			return vim.list_extend(
				args,
				{ "--color=never", "--no-heading", "--with-filename", "--line-number", "--column", "--smart-case" }
			)
		end,
		entry_maker = make_entry.gen_from_vimgrep(opts),
		cwd = opts.cwd,
	})

	pickers
		.new(opts, {
			debounce = 100,
			prompt_title = "Multi Grep",
			finder = finder,
			previewer = conf.grep_previewer(opts),
			sorter = require("telescope.sorters").empty(),
		})
		:find()
end

return {
	"nvim-telescope/telescope.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		-- Faster sorting plus fzf's operators in every picker: 'exact ^prefix
		-- suffix$ !exclude, and spaces separate terms matched in any order.
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
	},
	config = function()
		local telescope = require("telescope")
		local actions = require("telescope.actions")
		local builtin = require("telescope.builtin")

		telescope.setup({
			defaults = {
				-- "main.py  apps/alpha/backend/src": file name, then its full folder
				-- (dimmed). "smart" shortened folders to ../ so you couldn't tell
				-- which main.py or which poetry.lock a result was.
				path_display = { "filename_first" },
				mappings = {
					i = {
						["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
						["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
						-- Clear the prompt like everywhere else, instead of
						-- telescope's preview-scroll-up. The preview scrolls with
						-- <C-b>/<C-f> instead, same as nvim-cmp's docs popup
						-- (<C-d> still scrolls down too).
						["<C-u>"] = false,
						["<C-b>"] = actions.preview_scrolling_up,
						["<C-f>"] = actions.preview_scrolling_down,
					},
				},
			},
			extensions = {
				fzf = {},
			},
		})
		telescope.load_extension("fzf")

		local find_command = { "rg", "--files", "--hidden", "--no-ignore", "--glob", ".env*" }
		for _, dir in ipairs({
			"node_modules",
			".next",
			"__pycache__",
			".git",
			"build",
			"dist",
			".venv",
			"venv",
			".pytest_cache",
			".mypy_cache",
		}) do
			vim.list_extend(find_command, { "--glob", "!" .. dir .. "/*" })
		end
		vim.list_extend(find_command, { "--glob", "!.DS_Store" })

		vim.keymap.set("n", "<leader>pf", builtin.find_files, { desc = "Find files" })
		vim.keymap.set("n", "<leader>pe", function()
			builtin.find_files({ find_command = find_command, prompt_title = "Find .env Files" })
		end, { desc = "Find .env* files" })
		vim.keymap.set("n", "<leader>gf", builtin.git_files, { desc = "Find git files" })
		vim.keymap.set("n", "<leader>pb", builtin.buffers, { desc = "List open buffers" })
		vim.keymap.set("n", "<leader>vh", builtin.help_tags, { desc = "List vim help tags" })
		vim.keymap.set("n", "<leader>ls", builtin.live_grep, { desc = "Live grep" })
		vim.keymap.set("n", "<leader>fr", builtin.oldfiles, { desc = "Recent files" })
		vim.keymap.set("n", "<leader>fc", builtin.grep_string, { desc = "Grep word under cursor" })
		vim.keymap.set("n", "<leader>ps", live_multigrep, { desc = "Multi grep (pattern  glob)" })

		vim.keymap.set("n", "<leader>qo", "<cmd>copen<cr>", { desc = "Open quickfix list" })
		vim.keymap.set("n", "<leader>qc", "<cmd>cclose<cr>", { desc = "Close quickfix list" })
		vim.keymap.set("n", "[q", "<cmd>cprevious<cr>", { desc = "Previous quickfix item" })
		vim.keymap.set("n", "]q", "<cmd>cnext<cr>", { desc = "Next quickfix item" })
	end,
}
