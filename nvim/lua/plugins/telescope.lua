return {
    "nvim-telescope/telescope.nvim",
    dependencies = {
       "plenary",
        "dev-icons",
    },
    config = function()
        local telescope = require("telescope")
        local actions = require("telescope.actions")

        telescope.setup({
            defaults = {
                path_display = { "smart" },
                mappings = {
                    i = {
                        ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
                    },
                },
            },
        })

        local builtin = require("telescope.builtin")
        vim.keymap.set('n', '<leader>pf', builtin.find_files, {})
        vim.keymap.set('n', '<leader>ps', function()
            builtin.grep_string({ search = vim.fn.input("Grep > ") })
        end)
        vim.keymap.set("n", "<leader>fr", "<cmd>Telescope oldfiles<cr>")
        vim.keymap.set("n", "<leader>fc", "<cmd>Telescope grep_string<cr>")

        vim.keymap.set("n", "<leader>qo", "<cmd>copen<cr>", { desc = "Open quickfix list" })
        vim.keymap.set("n", "<leader>qc", "<cmd>cclose<cr>", { desc = "Close quickfix list" })
        vim.keymap.set("n", "[q", "<cmd>cprevious<cr>", { desc = "Previous quickfix item" })
        vim.keymap.set("n", "]q", "<cmd>cnext<cr>", { desc = "Next quickfix item" })

        local function remove_qf_items(start_line, end_line)
            local qfall = vim.fn.getqflist()
            for i = end_line, start_line, -1 do
                table.remove(qfall, i)
            end

            if #qfall == 0 then
                vim.cmd("cclose")  -- Close the quickfix list if empty
            else
                vim.fn.setqflist(qfall, 'r')
                vim.cmd('cfirst')
                vim.cmd('clast')
            end
        end

        local function remove_qf_item(mode)
            if mode == 'v' then
                -- Get the selected range in visual mode
                local start_line = vim.fn.line("'<")
                local end_line = vim.fn.line("'>")
                remove_qf_items(start_line, end_line)
            else
                -- If not in visual mode, remove the single item under the cursor
                remove_qf_items(vim.fn.line('.'), vim.fn.line('.'))
            end
        end

        -- Mapping for normal mode (single item) and visual mode (multiple items)
        vim.keymap.set("n", "<leader>qd", function() remove_qf_item('n') end)
        vim.keymap.set("v", "<leader>qd", function() remove_qf_item('v') end)
    end
}
