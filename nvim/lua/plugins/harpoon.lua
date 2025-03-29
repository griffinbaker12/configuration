return {
	"ThePrimeagen/harpoon",
	branch = "harpoon2",
	dependencies = { "nvim-lua/plenary.nvim" },
	config = function()
		local harpoon = require("harpoon")
		harpoon:setup()

		-- Add files to list
		vim.keymap.set("n", "<leader>m", function()
			harpoon:list():add()
		end, { desc = "Harpoon: Add file" })
		vim.keymap.set("n", "<leader>A", function()
			harpoon:list():prepend()
		end, { desc = "Harpoon: Prepend file" })

		-- Toggle quick menu
		-- vim.keymap.set("n", "<leader>h", function()
		vim.keymap.set("n", "<M-y>", function()
			harpoon.ui:toggle_quick_menu(harpoon:list())
		end, { desc = "Harpoon: Toggle menu" })

		-- Navigation (keeping your Alt-based scheme)
		-- vim.keymap.set("n", "<M-y>", function()
		-- 	harpoon:list():select(1)
		-- end, { desc = "Harpoon: File 1" })
		vim.keymap.set("n", "<M-u>", function()
			harpoon:list():select(1)
		end, { desc = "Harpoon: File 1" })
		vim.keymap.set("n", "<M-i>", function()
			harpoon:list():select(2)
		end, { desc = "Harpoon: File 2" })
		vim.keymap.set("n", "<M-o>", function()
			harpoon:list():select(3)
		end, { desc = "Harpoon: File 3" })
		vim.keymap.set("n", "<M-p>", function()
			harpoon:list():select(4)
		end, { desc = "Harpoon: File 4" })

		-- Add replace functionality with Alt+Shift+key
		vim.keymap.set("n", "<M-Y>", function()
			harpoon:list():replace_at(1)
		end, { desc = "Harpoon: Replace 1" })
		vim.keymap.set("n", "<M-U>", function()
			harpoon:list():replace_at(2)
		end, { desc = "Harpoon: Replace 2" })
		vim.keymap.set("n", "<M-I>", function()
			harpoon:list():replace_at(3)
		end, { desc = "Harpoon: Replace 3" })
		vim.keymap.set("n", "<M-O>", function()
			harpoon:list():replace_at(4)
		end, { desc = "Harpoon: Replace 4" })
		vim.keymap.set("n", "<M-P>", function()
			harpoon:list():replace_at(5)
		end, { desc = "Harpoon: Replace 5" })

		vim.keymap.set("n", "<M-h>", "<C-w>h", { desc = "Move to left split" })
		vim.keymap.set("n", "<M-j>", "<C-w>j", { desc = "Move to below split" })
		vim.keymap.set("n", "<M-k>", "<C-w>k", { desc = "Move to above split" })
		vim.keymap.set("n", "<M-l>", "<C-w>l", { desc = "Move to right split" })
	end,
}
