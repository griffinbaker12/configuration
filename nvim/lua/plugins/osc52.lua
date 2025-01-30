return {
	"ojroques/nvim-osc52",
	config = function()
		-- This configures the plugin once it's loaded
		-- First, set up the copy function that will use OSC52
		local function copy(lines, _)
			require("osc52").copy(table.concat(lines, "\n"))
		end

		-- Next, set up the paste function
		local function paste()
			return { vim.fn.split(vim.fn.getreg(""), "\n"), vim.fn.getregtype("") }
		end

		-- Now configure Neovim's clipboard to use these functions
		vim.g.clipboard = {
			name = "OSC52",
			copy = {
				["+"] = copy, -- For the + register (system clipboard)
				["*"] = copy, -- For the * register (selection clipboard)
			},
			paste = {
				["+"] = paste, -- For the + register
				["*"] = paste, -- For the * register
			},
		}

		-- Optional but recommended: set up an autocmd to copy automatically
		-- when you yank to the system clipboard register
		vim.api.nvim_create_autocmd("TextYankPost", {
			callback = function()
				-- If the yanked text was intended for the system clipboard
				if vim.v.event.operator == "y" and vim.v.event.regname == "+" then
					-- Copy it using OSC52
					require("osc52").copy_register("+")
				end
			end,
		})
	end,
}
