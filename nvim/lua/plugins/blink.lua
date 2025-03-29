return {
	{
		-- TODO: to add lua snippets
		"L3MON4D3/LuaSnip",
		config = function()
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
		end,
	},
	{
		"saghen/blink.cmp",
		dependencies = {
			"L3MON4D3/LuaSnip",
		},
		version = "v0.*",
		opts = {
			keymap = { preset = "enter" },
			appearance = {
				use_nvim_cmp_as_default = true,
				nerd_font_variant = "mono",
			},
			signature = { enabled = true },
			completion = {
				documentation = { auto_show = true },
			},
			snippets = { preset = "luasnip" },
		},
	},
}
