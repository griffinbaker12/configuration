vim.g.mapleader = " "

vim.keymap.set('i', 'jk', '<Esc>', { noremap = true })
vim.keymap.set('n', '-', ':Ex<CR>', { noremap = true })

vim.keymap.set('n', '<leader>cs', ':nohlsearch<CR>', { noremap = true, silent = true })

vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })

vim.keymap.set("n", "<leader><leader>", function()
    vim.cmd("so")
end)

vim.keymap.set("n", "<leader>fml", "<cmd>CellularAutomaton make_it_rain<CR>")

vim.keymap.set("n", "<leader>zm", "<cmd>ZenMode<CR>")
