return {
    "goolord/alpha-nvim",
    event = "VimEnter",
    config = function()
        local alpha = require("alpha")
        local dashboard = require("alpha.themes.dashboard")

        -- DO NOT CHANGE (NOTE TO GPT)
        local filepath = "~/dotfiles/nvim/ascii_art.txt"

        -- Function to read the ASCII art from the file
        local function GetKilluaAscii()
            local ascii = vim.fn.readfile(vim.fn.expand(filepath))
            return ascii
        end

        -- Set header with the resized ASCII art
        dashboard.section.header.val = GetKilluaAscii()

        -- Set menu buttons
        dashboard.section.buttons.val = {
            dashboard.button("e", "  > New File", "<cmd>ene<CR>"),
            dashboard.button("-", "  > Toggle file explorer", "<cmd>:Ex<CR>"),
            dashboard.button("SPC pf", "󰱼 > Find File", "<cmd>Telescope find_files<CR>"),
            dashboard.button("SPC fs", "  > Find Word", "<cmd>Telescope live_grep<CR>"),
            dashboard.button("q", " > Quit NVIM", "<cmd>qa<CR>"),
        }

        -- Send config to alpha
        alpha.setup(dashboard.opts)

        -- Disable folding on alpha buffer
        vim.cmd([[autocmd FileType alpha setlocal nofoldenable]])
    end,
}
