return {
    "folke/todo-comments.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
        local todo_comments = require("todo-comments")
        -- set keymaps
        local keymap = vim.keymap -- for conciseness
        keymap.set("n", "]t", function()
            todo_comments.jump_next()
        end, { desc = "Next todo comment" })
        keymap.set("n", "[t", function()
            todo_comments.jump_prev()
        end, { desc = "Previous todo comment" })
        keymap.set("n", "<leader>tq", function()
            vim.cmd("TodoQuickFix")
        end, { desc = "Open todo quickfix list" })
        keymap.set("n", "<leader>ft", function()
            vim.cmd("TodoTelescope")
        end, { desc = "Find todos with telescope" })
        todo_comments.setup()
    end,
}
