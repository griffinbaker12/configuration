return {
    {
        "nvim-lua/plenary.nvim",
        name = "plenary"
    },
    {
        "nvim-telescope/telescope.nvim",
        dependencies = {
            "plenary"
        }
    },
    {
        "folke/trouble.nvim",
    },
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate"
    },
    "tpope/vim-fugitive",
    "eandrju/cellular-automaton.nvim",
    "folke/zen-mode.nvim",
}
