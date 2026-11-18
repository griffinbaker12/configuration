return {
	"hrsh7th/nvim-cmp",
	event = "InsertEnter",
	dependencies = { "hrsh7th/cmp-nvim-lsp" },
	config = function()
		local cmp = require("cmp")

		cmp.setup({
			-- nvim 0.11's built-in snippet engine expands LSP snippets; no LuaSnip.
			snippet = {
				expand = function(args)
					vim.snippet.expand(args.body)
				end,
			},
			preselect = cmp.PreselectMode.None,
			completion = { completeopt = "menu,menuone,noselect" },
			mapping = cmp.mapping.preset.insert({
				["<C-k>"] = cmp.mapping.select_prev_item(),
				["<C-j>"] = cmp.mapping.select_next_item(),
				["<C-b>"] = cmp.mapping.scroll_docs(-4),
				["<C-f>"] = cmp.mapping.scroll_docs(4),
				["<C-Space>"] = cmp.mapping.complete(),
				["<C-e>"] = cmp.mapping.abort(),
				["<CR>"] = cmp.mapping.confirm({ select = false }),
			}),
			sources = cmp.config.sources({ { name = "nvim_lsp" } }),
		})
	end,
}
