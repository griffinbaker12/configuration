return {
	"stevearc/oil.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		CustomOilBar = function()
			local path = vim.fn.expand("%:p")
			path = path:gsub("^oil://", "")
			return "  " .. vim.fn.fnamemodify(path, ":.")
		end
		require("oil").setup({
			keymaps = {
				["<C-h>"] = false,
				["<C-l>"] = false,
				["<C-k>"] = false,
				["<C-j>"] = false,
				["<M-d>"] = "actions.select_split",
				["<M-v>"] = "actions.select_vsplit",
				["<leader>cd"] = "actions.cd",
			},
			win_options = {
				winbar = "%{v:lua.CustomOilBar()}",
			},
			view_options = {
				show_hidden = true,
			},
		})
		vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
		vim.api.nvim_create_autocmd("VimEnter", {
			callback = function()
				local dir = vim.fn.argv()[1]
				if dir then
					dir = dir:gsub("^oil://", "")
					if vim.fn.isdirectory(dir) == 1 then
						-- Set the working directory first
						vim.cmd.cd(dir)
						-- Open Oil in the exact directory we cd'd to
						vim.schedule(function()
							require("oil").open(dir) -- Use oil.open() instead of vim.cmd("Oil")
							print("Current directory: " .. vim.fn.getcwd())
						end)
					end
				end
			end,
		})
	end,
}
