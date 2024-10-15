return {
    "neovim/nvim-lspconfig",
    dependencies = {
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim"
    },
    config = function()
        local mason = require("mason").setup()
        local mason_lspconfig = require("mason-lspconfig").setup()
    end
} 
