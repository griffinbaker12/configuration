return {
	{
		"nvim-treesitter/nvim-treesitter",
		event = { "BufReadPre", "BufNewFile" },
		build = ":TSUpdate",
		dependencies = {
			"windwp/nvim-ts-autotag",
			"nvim-treesitter/nvim-treesitter-textobjects", -- Add this dependency
		},
		config = function()
			-- setup autotag
			require("nvim-ts-autotag").setup()
			-- import nvim-treesitter plugin
			local treesitter = require("nvim-treesitter.configs")
			-- configure treesitter
			treesitter.setup({
				-- Add the missing fields
				modules = {},
				ignore_install = {},
				-- enable syntax highlighting
				highlight = {
					enable = true,
				},
				sync_install = false,
				auto_install = true,
				-- enable indentation
				indent = { enable = true },
				-- ensure these language parsers are installed
				ensure_installed = {
					"json",
					"javascript",
					"typescript",
					"tsx",
					"yaml",
					"html",
					"css",
					"prisma",
					"markdown",
					"markdown_inline",
					"svelte",
					"graphql",
					"bash",
					"lua",
					"vim",
					"dockerfile",
					"gitignore",
					"query",
					"vimdoc",
					"c",
					"python",
					"cpp",
				},
			})
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter-context",
		after = "nvim-treesitter",
		-- NOTE: Calling setup is optional, so no need to call, but here is the relevant config should you want to change anything
		-- config = function()
		-- 	require("treesitter-context").setup({
		-- 		enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
		-- 		multiwindow = false, -- Enable multiwindow support.
		-- 		max_lines = 0, -- How many lines the window should span. Values <= 0 mean no limit.
		-- 		min_window_height = 0, -- Minimum editor window height to enable context. Values <= 0 mean no limit.
		-- 		line_numbers = true,
		-- 		multiline_threshold = 20, -- Maximum number of lines to show for a single context
		-- 		trim_scope = "outer", -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
		-- 		mode = "cursor", -- Line used to calculate context. Choices: 'cursor', 'topline'
		-- 		-- Separator between context and content. Should be a single character string, like '-'.
		-- 		-- When separator is set, the context will only show up when there are at least 2 lines above cursorline.
		-- 		separator = nil,
		-- 		zindex = 20, -- The Z-index of the context window
		-- 		on_attach = nil, -- (fun(buf: integer): boolean) return false to disable attaching
		-- 	})
		-- end,
	},
}
