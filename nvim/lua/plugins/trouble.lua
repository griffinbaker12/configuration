return {
    "folke/trouble.nvim",
    dependencies = {
        "dev-icons"
    },
    opts = {
        focus = true
    },
    cmd = "Trouble",
    keys = {
        { "<leader>xw", "<cmd>Trouble diagnostics toggle<CR>", desc = "Open trouble workspace diagnostics" },
        { "<leader>xf", "<cmd>Trouble diagnostics toggle filter.buf=0<CR>", desc = "Open trouble file diagnostics" },
        { "]d", function() require("trouble").next({skip_groups = true, jump = true}) end, desc = "Next Trouble diagnostic" },
        { "[d", function() require("trouble").previous({skip_groups = true, jump = true}) end, desc = "Previous Trouble diagnostic" },
    }
}
