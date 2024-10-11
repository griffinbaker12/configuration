return {
  {
    "folke/tokyonight.nvim",
    config = function()
        local border = "#547998"
        require("tokyonight").setup({
            style = "night",
            on_colors = function(colors)
                colors.border = border
            end,
        })
      vim.cmd([[colorscheme tokyonight]])
    end,
  },
}
