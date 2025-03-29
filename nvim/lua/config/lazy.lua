-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
print(lazypath)
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

local function prepend_exploratory_paths()
	local function check_path(path)
		if not (vim.uv or vim.loop).fs_stat(path) then
			vim.api.nvim_echo({
				{ "Failed to require exploratory path " .. path },
			}, true, {})
			return false
		end
		return true
	end

	local paths = { "/test", "/test2" }
	for _, path in pairs(paths) do
		local testpath = vim.fn.stdpath("data") .. path
		if check_path(testpath) then
			vim.opt.rtp:prepend(testpath)
			require(path:sub(2)).setup()
		end
		break
	end
end

-- Load before loading lazy so that mappings are correct
require("user.remap")
require("user.set")

-- prepend_exploratory_paths()

-- Setup lazy.nvim
require("lazy").setup({
	spec = {
		{ import = "plugins" },
	},
	checker = {
		enabled = true,
		notify = false,
	},
	change_detection = {
		notify = false,
	},
})
