vim.g.mapleader = " "

-- Basic mappings
vim.keymap.set("i", "jk", "<Esc>", { noremap = true }) -- Exit insert mode with jk
vim.keymap.set("n", "Q", "<nop>") -- Disable Ex mode

-- Line navigation: use H/L for start/end of line instead of viewport top/bottom
vim.keymap.set({ "n", "x", "o" }, "H", "^") -- Jump to first non-blank character of line
vim.keymap.set({ "n", "x", "o" }, "L", "g_") -- Jump to last non-blank character of line

-- Search and replace
vim.keymap.set("n", "n", "nzzzv") -- Keep search results centered
vim.keymap.set("n", "N", "Nzzzv")
vim.keymap.set("n", "<leader>cs", ":nohlsearch<CR>", { noremap = true, silent = true }) -- Clear search highlighting
vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]]) -- Search and replace word under cursor

-- Moving lines and centering
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv") -- Move selected lines down
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv") -- Move selected lines up
vim.keymap.set("n", "J", "mzJ`z") -- Join lines keeping cursor position
vim.keymap.set("n", "<C-d>", "<C-d>zz") -- Half-page down keeping cursor centered
vim.keymap.set("n", "<C-u>", "<C-u>zz") -- Half-page up keeping cursor centered

-- Window splits and resizing
vim.keymap.set("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" })
vim.keymap.set("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" })
vim.keymap.set("n", "<leader>se", "<C-w>=", { desc = "Make splits equal size" })
vim.keymap.set("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close current split" })
vim.keymap.set("n", "<leader>sr", "<C-w>L", { desc = "Move split to the right" })
vim.keymap.set("n", "<leader>sb", "<C-w>J", { desc = "Move split to the bottom" })
vim.keymap.set("n", "+", ":vertical resize +5<CR>") -- Increase window width
vim.keymap.set("n", "_", ":vertical resize -5<CR>") -- Decrease window width
vim.keymap.set("n", "=", ":resize +5<CR>") -- Increase window height
vim.keymap.set("n", "-", ":resize -5<CR>") -- Decrease window height

-- Buffer navigation
vim.keymap.set("n", "<Right>", ":bnext<CR>") -- Next buffer
vim.keymap.set("n", "<Left>", ":bprevious<CR>") -- Previous buffer

-- Tab management
vim.keymap.set("n", "<leader>to", "<cmd>tabnew<CR>", { desc = "Open new tab" })
vim.keymap.set("n", "<leader>tx", "<cmd>tabclose<CR>", { desc = "Close current tab" })
vim.keymap.set("n", "<leader>tn", "<cmd>tabn<CR>", { desc = "Go to next tab" })
vim.keymap.set("n", "<leader>tp", "<cmd>tabp<CR>", { desc = "Go to previous tab" })
vim.keymap.set("n", "<leader>tf", "<cmd>tabnew %<CR>", { desc = "Open current buffer in new tab" })

-- Register operations
vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]]) -- Delete to black hole register
vim.keymap.set({ "n", "v" }, "<leader>D", [["_D]])
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]]) -- Yank to system clipboard
vim.keymap.set("n", "<leader>Y", [["+Y]])
vim.keymap.set(
	"n",
	"<leader>ya",
	"mngg:%y+<CR>`n",
	{ desc = "Yank entire file to system clipboard (preserving cursor)" }
)
vim.keymap.set("n", "<leader>da", "mngg:%d<CR>`n", { desc = "Delete entire file contents (preserving cursor)" })

-- Visual mode improvements
vim.keymap.set("v", "<", "<gv") -- Better indenting - keep visual selection
vim.keymap.set("v", ">", ">gv")
vim.keymap.set("v", "p", '"_dp') -- Better pasting - don't copy replaced text
vim.keymap.set("v", "P", '"_dP')

-- Command mode mappings
vim.keymap.set("c", "<Down>", "<C-n>", { noremap = true, silent = true }) -- Next command in history
vim.keymap.set("c", "<Up>", "<C-p>", { noremap = true, silent = true }) -- Previous command in history

-- Misc utilities
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true }) -- Make current file executable
vim.keymap.set("n", "<leader><leader>", function()
	vim.cmd("so")
end) -- Source current file
vim.keymap.set(
	"n",
	"<C-f>",
	"<cmd>silent !tmux neww ~/dotfiles/bin/tmux_sessionizer.sh<CR>",
	{ noremap = true, silent = true }
) -- Open tmux sessionizer

-- Plugin mappings
vim.keymap.set("n", "<leader>fml", "<cmd>CellularAutomaton make_it_rain<CR>") -- Matrix-style animation
vim.keymap.set("n", "<leader>zm", "<cmd>ZenMode<CR>") -- Toggle zen mode

-- Yank highlighting
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("Highlight-Yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})

-- So that I move around the same way as I do in the cli
vim.keymap.set("c", "<A-b>", "<C-Left>", { noremap = true })
vim.keymap.set("c", "<A-f>", "<C-Right>", { noremap = true })
