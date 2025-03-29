return {
	{
		"nvim-treesitter/nvim-treesitter",
		event = { "BufReadPre", "BufNewFile" },
		build = ":TSUpdate",
		dependencies = {
			"windwp/nvim-ts-autotag",
			"nvim-treesitter/nvim-treesitter-textobjects",
			-- "nvim-treesitter/nvim-treesitter-context",
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
			-- require("treesitter-context").setup({
			-- 	enable = true,
			-- 	max_lines = 0, -- No limit on the context display
			-- 	trim_scope = "outer",
			-- 	zindex = 20,
			-- })
		end,
	},
}
