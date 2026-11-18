local function is_deno_project(bufnr)
	local fname = vim.api.nvim_buf_get_name(bufnr)
	local root = vim.fn.fnamemodify(fname, ":p:h")
	while root and root ~= "" and root ~= "/" do
		if #vim.fn.globpath(root, "deno.json", false, true) > 0 then
			return true
		end
		root = vim.fn.fnamemodify(root, ":h")
	end
	return false
end

-- Enforce 2 spaces for indentation in certain filetypes
vim.api.nvim_create_autocmd("FileType", {
	pattern = {
		"markdown",
		"c",
		"cpp",
		"javascript",
		"typescript",
		"prisma",
		"typescriptreact",
		"javascriptreact",
		"proto",
	},
	callback = function()
		vim.bo.tabstop = 2
		vim.bo.shiftwidth = 2
		vim.bo.softtabstop = 2
		vim.bo.expandtab = true
	end,
})

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
	pattern = { "*.yaml.tpl", "*.yml.tpl", "*/templates/*.yaml", "*/templates/*.yml" },
	callback = function()
		vim.bo.filetype = "helm"
	end,
})

vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("lsp_attach_disable_ruff_hover", { clear = true }),
	callback = function(args)
		local client = vim.lsp.get_client_by_id(args.data.client_id)
		if client == nil then
			return
		end
		if client.name == "ruff" then
			-- Disable hover in favor of Pyright
			client.server_capabilities.hoverProvider = false
		end
	end,
	desc = "LSP: Disable hover capability from Ruff",
})

return {
	"neovim/nvim-lspconfig",
	version = "*",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = { "hrsh7th/cmp-nvim-lsp" },
	config = function()
		-- 1. Keep a reference to the original diagnostics handler
		local orig_handler = vim.lsp.handlers["textDocument/publishDiagnostics"]

		-- 2. Override the default handler to filter out everything below WARN
		vim.lsp.handlers["textDocument/publishDiagnostics"] = function(err, result, ctx, config)
			if result and result.diagnostics then
				local filtered = {}
				for _, diag in ipairs(result.diagnostics) do
					-- Only keep diagnostics that are WARN or ERROR (i.e. severity <= WARN)
					if diag.severity and diag.severity <= vim.diagnostic.severity.WARN then
						table.insert(filtered, diag)
					end
				end
				result.diagnostics = filtered
			end
			orig_handler(err, result, ctx, config)
		end

		-- Create an autocmd to set up buffer-local keymaps whenever an LSP attaches
		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("UserLspConfig", {}),
			callback = function(ev)
				-- Buffer local mappings.
				local opts = { buffer = ev.buf, silent = true }
				local keymap = vim.keymap

				opts.desc = "Show LSP references"
				keymap.set("n", "gR", "<cmd>Telescope lsp_references<CR>", opts)

				opts.desc = "Go to declaration"
				keymap.set("n", "gD", vim.lsp.buf.declaration, opts)

				opts.desc = "Show LSP definitions"
				keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts)

				opts.desc = "Show LSP implementations"
				keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts)

				opts.desc = "Show LSP type definitions"
				keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts)

				opts.desc = "See available code actions"
				keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)

				opts.desc = "Smart rename"
				keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)

				opts.desc = "Show buffer diagnostics"
				keymap.set("n", "<leader>bd", "<cmd>Telescope diagnostics bufnr=0<CR>", opts)

				opts.desc = "Show line diagnostics"
				keymap.set("n", "<leader>ld", function()
					vim.diagnostic.open_float()
					vim.diagnostic.open_float()
				end, opts)

				opts.desc = "Go to previous diagnostic"
				keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)

				opts.desc = "Go to next diagnostic"
				keymap.set("n", "]d", vim.diagnostic.goto_next, opts)

				opts.desc = "Toggle documentation for what is under cursor"
				-- Press once to open the hover float, again to close it. Without
				-- this the second K jumps the cursor INTO the float (nvim's
				-- focusable default), which means reaching for q to get back out.
				-- nvim stores the float's window id on the source buffer.
				keymap.set("n", "K", function()
					local win = vim.b.lsp_floating_preview
					if win and vim.api.nvim_win_is_valid(win) then
						vim.api.nvim_win_close(win, true)
						vim.b.lsp_floating_preview = nil
						return
					end
					vim.lsp.buf.hover()
				end, opts)

				opts.desc = "Signature help"
				keymap.set("i", "<M-i>", function()
					vim.lsp.buf.signature_help()
				end, opts)
			end,
		})

		-- Enable autocompletion
		local capabilities = require("cmp_nvim_lsp").default_capabilities()

		-- Don't let servers register file watchers. On macOS nvim 0.11.2's watcher
		-- asserts on fs_stat errors, so a file that vanishes mid-event (pytest's
		-- temp dirs) throws "Error executing callback ... _watch.lua:90: EINVAL".
		capabilities.workspace = capabilities.workspace or {}
		capabilities.workspace.didChangeWatchedFiles = { dynamicRegistration = false }

		-- Customize diagnostic symbols in the sign column
		-- local signs = { Error = " ", Warn = " " }
		-- for type, icon in pairs(signs) do
		-- 	local hl = "DiagnosticSign" .. type
		-- 	vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
		-- end

		vim.diagnostic.config({
			signs = {
				text = {
					[vim.diagnostic.severity.ERROR] = " ",
					[vim.diagnostic.severity.WARN] = " ",
					-- [vim.diagnostic.severity.INFO] = "󰋼 ",
					-- [vim.diagnostic.severity.HINT] = "󰌵 ",
				},
				numhl = {
					[vim.diagnostic.severity.ERROR] = "",
					[vim.diagnostic.severity.WARN] = "",
					-- [vim.diagnostic.severity.HINT] = "",
					-- [vim.diagnostic.severity.INFO] = "",
				},
			},
			virtual_text = {
				spacing = 4, -- space between actual text and virtual text
				prefix = "●", -- a prefix for the virtual text
				source = "if_many",
			},
			float = {
				focusable = false, -- can't jump to float
				style = "minimal", -- minimal border style
				border = "rounded", -- rounded border
				-- source = "always", -- always show diagnostic source
				header = "", -- no header
				prefix = "", -- no prefix
			},
			underline = true,
			update_in_insert = false,
			severity_sort = true,
		})

		-- Server configs use the nvim 0.11 API: vim.lsp.config() layers overrides on
		-- the defaults nvim-lspconfig ships in lsp/<server>.lua, and vim.lsp.enable()
		-- starts them. require("lspconfig").<server>.setup() is deprecated.
		vim.lsp.config("*", {
			capabilities = capabilities,
		})

		vim.lsp.config("lua_ls", {
			settings = {
				Lua = {
					diagnostics = {
						globals = { "vim" },
					},
					completion = {
						callSnippet = "Replace",
					},
				},
			},
		})

		vim.lsp.config("clangd", {
			settings = {
				clangd = {
					arguments = {
						"--header-insertion=never",
						"--fallback-style=Google",
						"--clang-tidy",
					},
				},
			},
		})

		vim.lsp.config("pyright", {
			-- Point pyright at the nearest in-project .venv (poetry creates one per
			-- package) instead of whatever python is on PATH, e.g. conda base.
			before_init = function(_, config)
				local venv = vim.fs.find(".venv", { path = config.root_dir, upward = true, type = "directory" })[1]
				if venv then
					config.settings.python.pythonPath = venv .. "/bin/python"
				end
			end,
			settings = {
				pyright = {
					disableOrganizeImports = true,
				},
				python = {
					analysis = {
						ignore = { "*" },
					},
				},
			},
		})

		vim.lsp.config("ruff", {
			init_options = {
				settings = {
					logLevel = "warn",
				},
			},
		})

		-- Root detection for prismals: the schema file, then the usual JS markers.
		vim.lsp.config("prismals", {
			root_markers = { "prisma/schema.prisma", "package.json", ".git" },
			settings = {
				prisma = {
					formatSchema = true,
					trace = { server = "messages" },
				},
			},
			filetypes = { "prisma" },
			on_attach = function(client, bufnr)
				client.server_capabilities.documentFormattingProvider = true
				vim.api.nvim_create_autocmd("BufWritePre", {
					pattern = "*.prisma",
					callback = function()
						vim.lsp.buf.format({ async = false })
					end,
				})
			end,
		})

		vim.lsp.config("yamlls", {
			on_attach = function(client, bufnr)
				-- Disable diagnostics for Helm files
				if vim.bo[bufnr].buftype ~= "" or vim.bo[bufnr].filetype == "helm" then
					vim.diagnostic.enable(false, bufnr)
					vim.defer_fn(function()
						vim.diagnostic.reset(nil, bufnr)
					end, 1000)
				end
			end,
			settings = {
				yaml = {
					-- GitLab CI's `!reference [.job, key]` takes a list.
					customTags = { "!reference sequence" },
				},
			},
		})

		vim.lsp.config("helm_ls", {
			settings = {
				["helm-ls"] = {
					yamlls = {
						enabled = false,
					},
				},
			},
		})

		vim.lsp.config("eslint", {
			settings = {
				packageManager = "pnpm",
			},
			filetypes = {
				"javascript",
				"javascriptreact",
				"typescript",
				"typescriptreact",
			},
			on_attach = function(client, bufnr)
				client.server_capabilities.documentFormattingProvider = false
				client.server_capabilities.documentRangeFormattingProvider = false
			end,
		})

		-- denols and ts_ls keep nvim-lspconfig's default root detection, which
		-- already makes them exclusive: denols needs deno.json/deno.lock and ts_ls
		-- steps aside when one is present.
		vim.lsp.config("denols", {
			init_options = {
				enable = true,
				lint = true,
				unstable = true,
			},
		})

		vim.lsp.config("ts_ls", {
			on_attach = function(client, bufnr)
				client.server_capabilities.documentFormattingProvider = false
				client.server_capabilities.documentRangeFormattingProvider = false
			end,
			settings = {
				typescript = {
					format = {
						indentSize = 2,
						convertTabsToSpaces = true,
						tabSize = 2,
					},
				},
				javascript = {
					format = {
						indentSize = 2,
						convertTabsToSpaces = true,
						tabSize = 2,
					},
					implicitProjectConfig = {
						checkJs = true,
					},
				},
			},
		})

		-- No mason here, so only enable servers whose binary is actually on PATH
		-- (init.lua adds the old config's mason/bin); the rest would error on attach.
		local servers = {
			"lua_ls",
			"clangd",
			"pyright",
			"ruff",
			"prismals",
			"yamlls",
			"helm_ls",
			"eslint",
			"denols",
			"ts_ls",
			"html",
			"cssls",
			"tailwindcss",
			"svelte",
		}
		for _, server in ipairs(servers) do
			local cmd = (vim.lsp.config[server] or {}).cmd
			if type(cmd) ~= "table" or vim.fn.executable(cmd[1]) == 1 then
				vim.lsp.enable(server)
			end
		end
	end,
}
