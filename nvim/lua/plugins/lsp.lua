vim.api.nvim_create_autocmd("FileType", {
	pattern = { "c", "cpp", "javascript", "typescript", "prisma", "typescriptreact", "javascriptreact", "proto" },
	callback = function()
		vim.bo.tabstop = 2
		vim.bo.shiftwidth = 2
		vim.bo.softtabstop = 2
		vim.bo.expandtab = true
	end,
})

return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"hrsh7th/cmp-nvim-lsp",
		{ "antosha417/nvim-lsp-file-operations", config = true },
		{ "folke/neodev.nvim", opts = {} },
	},
	config = function()
		local lspconfig = require("lspconfig")
		local mason_lspconfig = require("mason-lspconfig")
		local cmp_nvim_lsp = require("cmp_nvim_lsp")
		local keymap = vim.keymap -- for conciseness
		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("UserLspConfig", {}),
			callback = function(ev)
				-- Buffer local mappings.
				-- See `:help vim.lsp.*` for documentation on any of the below functions
				local opts = { buffer = ev.buf, silent = true }

				-- set keybinds
				opts.desc = "Show LSP references"
				keymap.set("n", "gR", "<cmd>Telescope lsp_references<CR>", opts) -- show definition, references

				opts.desc = "Go to declaration"
				keymap.set("n", "gD", vim.lsp.buf.declaration, opts) -- go to declaration

				opts.desc = "Show LSP definitions"
				keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts) -- show lsp definitions

				opts.desc = "Show LSP implementations"
				keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts) -- show lsp implementations

				opts.desc = "Show LSP type definitions"
				keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts) -- show lsp type definitions

				opts.desc = "See available code actions"
				keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts) -- see available code actions, in visual mode will apply to selection

				opts.desc = "Smart rename"
				keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts) -- smart rename

				opts.desc = "Show buffer diagnostics"
				keymap.set("n", "<leader>bd", "<cmd>Telescope diagnostics bufnr=0<CR>", opts) -- show  diagnostics for file

				opts.desc = "Show line diagnostics"
				keymap.set("n", "<leader>ld", vim.diagnostic.open_float, opts) -- show diagnostics for line

				opts.desc = "Go to previous diagnostic"
				keymap.set("n", "[d", vim.diagnostic.goto_prev, opts) -- jump to previous diagnostic in buffer

				opts.desc = "Go to next diagnostic"
				keymap.set("n", "]d", vim.diagnostic.goto_next, opts) -- jump to next diagnostic in buffer

				opts.desc = "Show documentation for what is under cursor"
				keymap.set("n", "K", vim.lsp.buf.hover, opts) -- show documentation for what is under cursor

				opts.desc = "Signature help"
				keymap.set("i", "<M-i>", function()
					vim.lsp.buf.signature_help()
				end, opts) -- get help when passing args to a function
			end,
		})

		-- used to enable autocompletion (assign to every lsp server config)
		local capabilities = cmp_nvim_lsp.default_capabilities()

		-- Change the Diagnostic symbols in the sign column (gutter)
		-- (not in youtube nvim video)
		local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
		for type, icon in pairs(signs) do
			local hl = "DiagnosticSign" .. type
			vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
		end

		local min_severity = {
			severity = {
				min = vim.diagnostic.severity.WARN,
			},
		}

		vim.diagnostic.config({
			-- Only show errors and warnings
			severity_sort = true,
			underline = true,
			signs = min_severity,
			virtual_text = min_severity,
			float = min_severity,
		})

		mason_lspconfig.setup_handlers({
			-- default handler for installed servers
			function(server_name)
				lspconfig[server_name].setup({
					capabilities = capabilities,
				})
			end,
			["lua_ls"] = function()
				-- configure lua server (with special settings)
				lspconfig["lua_ls"].setup({
					capabilities = capabilities,
					settings = {
						Lua = {
							-- make the language server recognize "vim" global
							diagnostics = {
								globals = { "vim" },
							},
							completion = {
								callSnippet = "Replace",
							},
						},
					},
				})
			end,
			["clangd"] = function()
				lspconfig["clangd"].setup({
					capabilities = capabilities,
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
			end,
			["pyright"] = function()
				lspconfig["pyright"].setup({
					capabilities = capabilities,
					on_init = function(client)
						local workspace = client.config.root_dir
						if workspace then
							local poetry_lock_path = vim.fs.joinpath(workspace, "poetry.lock")
							if vim.fn.filereadable(poetry_lock_path) == 1 then
								local venv = vim.fn.trim(vim.fn.system("poetry env info -p"))
								local python_path = vim.fs.joinpath(venv, "bin", "python")
								client.config.settings = client.config.settings or {}
								client.config.settings.python = client.config.settings.python or {}
								client.config.settings.python.pythonPath = python_path
							end
						end
					end,
					settings = {
						python = {
							analysis = {
								diagnosticSeverityOverrides = {
									reportUnboundVariable = "none",
									reportInvalidVariableName = "none",
								},
								extraPaths = { vim.fn.getcwd() },
							},
						},
					},
					on_attach = function(client)
						client.server_capabilities.documentFormattingProvider = false
						client.server_capabilities.documentRangeFormattingProvider = false
					end,
				})
			end,
			["prismals"] = function()
				lspconfig["prismals"].setup({
					capabilities = capabilities,
					-- This helps the LSP find your project root directory
					root_dir = function(fname)
						return lspconfig.util.root_pattern(".git", "package.json", "prisma/schema.prisma")(fname)
							or vim.fs.dirname(fname)
					end,
					settings = {
						prisma = {
							-- Enable formatting support
							formatSchema = true,
							-- Add hints and suggestions
							trace = { server = "messages" },
						},
					},
					-- This ensures proper file type recognition
					filetypes = { "prisma" },

					-- This sets up formatting and additional features
					on_attach = function(client, bufnr)
						-- Enable formatting
						client.server_capabilities.documentFormattingProvider = true

						-- Set up format on save for Prisma files
						vim.api.nvim_create_autocmd("BufWritePre", {
							pattern = "*.prisma",
							callback = function()
								vim.lsp.buf.format({ async = false })
							end,
						})
					end,
				})
			end,
		})
	end,
}
