return {
	"echasnovski/mini.nvim",
	config = function()
		-- Better Around/Inside textobjects (and define your own)
		-- Examples:
		--  - va)  - [V]isually select [A]round [)]paren
		--  - yinq - [Y]ank [I]nside [N]ext [']quote
		--  - ci'  - [C]hange [I]nside [']quote
		local spec_treesitter = require("mini.ai").gen_spec.treesitter
		require("mini.ai").setup({
			custom_textobjects = {
				F = spec_treesitter({
					a = { "@function.outer", "@method.outer", "@arrow_function.outer" },
					i = { "@function.inner", "@method.inner", "@arrow_function.inner" },
				}),
				L = spec_treesitter({
					a = { "@conditional.outer", "@loop.outer" },
					i = { "@conditional.inner", "@loop.inner" },
				}),
			},
		})

		local f = function(aa, bb)
			return function()
				return [[string]]
			end
		end

		require("mini.comment").setup({
			options = {
				custom_commentstring = function()
					return require("ts_context_commentstring").calculate_commentstring() or vim.bo.commentstring
				end,
			},
		})
	end,
}
