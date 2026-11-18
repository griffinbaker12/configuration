-- Block cursor in every mode, never blinking (blinkon0).
vim.opt.guicursor = "a:block-blinkon0"

vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.tabstop = 4

vim.opt.showmode = false

vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.wrap = false

vim.opt.smartindent = true

vim.opt.swapfile = false
vim.opt.backup = false

vim.opt.hlsearch = true
vim.opt.incsearch = true

-- Off on purpose: sonokai falls back to its 256-color cterm palette.
vim.opt.termguicolors = false

vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

vim.opt.updatetime = 50

vim.opt.splitright = true
vim.opt.splitbelow = true

vim.opt.backspace = "indent,eol,start"

vim.opt.cursorline = true

vim.g.netrw_banner = 0
vim.g.netrw_winsize = 25

vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"

-- Strip italics from every highlight group whenever a colorscheme loads.
-- Registered here (before lazy) so it catches the first colorscheme call.
vim.api.nvim_create_autocmd("ColorScheme", {
	group = vim.api.nvim_create_augroup("NoItalics", { clear = true }),
	callback = function()
		-- With termguicolors off the terminal draws the cterm attrs, so clear both.
		for name, hl in pairs(vim.api.nvim_get_hl(0, {})) do
			local cterm_italic = hl.cterm and hl.cterm.italic
			if hl.italic or cterm_italic then
				hl.italic = false
				if cterm_italic then
					hl.cterm.italic = false
				end
				vim.api.nvim_set_hl(0, name, hl)
			end
		end
	end,
})

-- :grep runs rg and fills the quickfix list. Without nvim's default -uu, so it
-- skips .gitignored files and hidden dirs (node_modules, .venv, .claude/worktrees).
vim.opt.grepprg = "rg --vimgrep --smart-case"
vim.opt.grepformat = "%f:%l:%c:%m"

-- Open the quickfix window whenever :grep (or :vimgrep, :make, ...) fills it,
-- instead of leaving the results hidden until :copen.
vim.api.nvim_create_autocmd("QuickFixCmdPost", {
	group = vim.api.nvim_create_augroup("OpenQuickfixAfterGrep", { clear = true }),
	pattern = "[^l]*",
	callback = function()
		vim.cmd("redraw! | cwindow")
	end,
})

-- :Cfilter / :Lfilter ship with nvim but are off until loaded. :Cfilter pat
-- keeps matching quickfix entries, :Cfilter! pat drops them (each makes a new
-- list, so :colder gets the unfiltered one back).
vim.cmd.packadd("cfilter")
