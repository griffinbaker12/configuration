return {
    "folke/tokyonight.nvim",
    priority = 1000,
    config = function()
        local border = "#547998"
        require("tokyonight").setup({
            style = "night",
            terminal_colors = true,
            styles = {
                comments = { italic = false },
                keywords = { italic = false },
            },
            on_colors  = function(colors)
                colors.border = border
            end
        })
        vim.cmd([[colorscheme tokyonight]])
    end,
}
