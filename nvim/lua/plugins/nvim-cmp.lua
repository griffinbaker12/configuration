return {
	"hrsh7th/nvim-cmp",
	event = "InsertEnter",
	dependencies = {
		"hrsh7th/cmp-buffer",
		"hrsh7th/cmp-path",
		"L3MON4D3/LuaSnip",
		"saadparwaiz1/cmp_luasnip",
		"onsails/lspkind.nvim",
		"hrsh7th/cmp-cmdline",
		"hrsh7th/nvim-cmp",
		"hrsh7th/cmp-nvim-lsp",
	},
	config = function()
		local cmp = require("cmp")
		local lspkind = require("lspkind")

		local luasnip = require("luasnip")
		local i = luasnip.insert_node
		local s = luasnip.snippet
		local t = luasnip.text_node

		luasnip.add_snippets("python", {
			s("ti", {
				t("# type: ignore"),
			}),
		})

		local console_log_snippet = s("lg", {
			t("console.log("),
			i(1, ""),
			t(");"),
		})
		local js_langs = { "javascript", "typescript", "javascriptreact", "typescriptreact" }
		for _, lang in ipairs(js_langs) do
			luasnip.add_snippets(lang, { console_log_snippet })
		end

		cmp.setup({
			snippet = {
				expand = function(args)
					luasnip.lsp_expand(args.body)
				end,
			},
			mapping = cmp.mapping.preset.insert({
				["<C-k>"] = cmp.mapping.select_prev_item(), -- previous suggestion
				["<C-j>"] = cmp.mapping.select_next_item(), -- next suggestion
				["<C-Space>"] = cmp.mapping.complete(), -- show completion suggestions
				["<Tab>"] = cmp.mapping.confirm({ select = true }), -- Use Tab instead of Enter
				["<CR>"] = cmp.mapping.confirm({ select = false }),
				["<C-e>"] = cmp.mapping.abort(), -- close completion window
			}),
			-- sources for autocompletion
			sources = cmp.config.sources({
				{ name = "nvim_lsp" }, -- lsp
				{ name = "luasnip" }, -- snippets
				{ name = "buffer" }, -- text within current buffer
				{ name = "path" }, -- file system paths
			}),

			-- configure lspkind for vs-code like pictograms in completion menu
			formatting = {
				format = lspkind.cmp_format({
					maxwidth = 50,
					ellipsis_char = "...",
				}),
			},
		})
	end,
}
