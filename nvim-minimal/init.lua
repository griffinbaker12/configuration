-- Minimal config: telescope, nvim-lspconfig, nvim-cmp, lsp_signature, sonokai.
-- Launched via NVIM_APPNAME=nvim-minimal (see ~/.zshrc), so its plugins and
-- state live under ~/.local/share/nvim-minimal, apart from the old config.

-- No mason here: reuse the language servers the old config's mason installed.
local mason_bin = vim.fn.expand("~/.local/share/nvim/mason/bin")
if vim.fn.isdirectory(mason_bin) == 1 then
	vim.env.PATH = mason_bin .. ":" .. vim.env.PATH
end

require("user.remap")
require("user.set")

-- :ResetConfig -- see lua/user/reload.lua for what it can and cannot reload
require("user.reload").setup()

-- :Font -- switch kitty between JetBrains Mono, Berkeley Mono and SF Mono
require("user.font").setup()

-- Tab labels: file name only, plus the parent folder when two tabs share a name
require("user.tabline").setup()

-- Status line: nvim's default plus error / warning counts
require("user.statusline").setup()

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local out = vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"--branch=stable",
		"https://github.com/folke/lazy.nvim.git",
		lazypath,
	})
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({ { "Failed to clone lazy.nvim:\n", "ErrorMsg" }, { out, "WarningMsg" } }, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	spec = { { import = "plugins" } },
	change_detection = { notify = false },
	rocks = { enabled = false },
})
