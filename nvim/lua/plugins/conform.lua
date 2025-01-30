return {
	"stevearc/conform.nvim",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local conform = require("conform")

		conform.setup({
			formatters_by_ft = {
				javascript = { "prettier" },
				typescript = { "prettier" },
				javascriptreact = { "prettier" },
				typescriptreact = { "prettier" },
				svelte = { "prettier" },
				css = { "prettier" },
				html = { "prettier" },
				json = { "prettier" },
				yaml = { "prettier" },
				markdown = { "prettier" },
				graphql = { "prettier" },
				liquid = { "prettier" },
				lua = { "stylua" },
				-- python = { "ruff_format" },
				cpp = { "clang_format" },
				hpp = { "clang_format" },
				c = { "clang_format" },
				h = { "clang_format" },
			},
			formatters = {
				clang_format = {
					args = { "--fallback-style=Google" },
				},
			},
			format_after_save = { lsp_fallback = true, timeout_ms = 1000 },
		})

		vim.keymap.set({ "n", "v" }, "<leader>mp", function()
			conform.format({
				lsp_fallback = true,
				async = false,
				timeout_ms = 1000,
			})
		end, { desc = "Format file or range (in visual mode)" })

		vim.keymap.set("n", "<leader>si", function()
			conform.format({
				formatters = { "isort" },
				bufnr = vim.api.nvim_get_current_buf(),
			})
		end, { desc = "Sort imports with isort" })
	end,
}
