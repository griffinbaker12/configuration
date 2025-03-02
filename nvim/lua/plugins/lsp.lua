-- Enforce 2 spaces for indentation in certain filetypes
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "c", "cpp", "javascript", "typescript", "prisma", "typescriptreact", "javascriptreact", "proto" },
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

return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"hrsh7th/cmp-nvim-lsp",
		{ "b0o/schemastore.nvim" },
		{ "antosha417/nvim-lsp-file-operations", config = true },
		{ "folke/neodev.nvim", opts = {} },
	},
	config = function()
		local lspconfig = require("lspconfig")
		local mason_lspconfig = require("mason-lspconfig")
		local cmp_nvim_lsp = require("cmp_nvim_lsp")

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
				-- See `:help vim.lsp.*` for documentation on any of the below functions
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
				keymap.set("n", "<leader>ld", vim.diagnostic.open_float, opts)

				opts.desc = "Enter line diagnostics window"
				keymap.set("n", "<leader>dd", function()
					vim.diagnostic.open_float()
					vim.diagnostic.open_float()
				end, opts)

				opts.desc = "Go to previous diagnostic"
				keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)

				opts.desc = "Go to next diagnostic"
				keymap.set("n", "]d", vim.diagnostic.goto_next, opts)

				opts.desc = "Show documentation for what is under cursor"
				keymap.set("n", "K", vim.lsp.buf.hover, opts)

				opts.desc = "Signature help"
				keymap.set("i", "<M-i>", function()
					vim.lsp.buf.signature_help()
				end, opts)
			end,
		})

		-- Enable autocompletion
		local capabilities = cmp_nvim_lsp.default_capabilities()

		-- Customize diagnostic symbols in the sign column (I only want to see these diagnostics)
		local signs = { Error = " ", Warn = " " }
		for type, icon in pairs(signs) do
			local hl = "DiagnosticSign" .. type
			vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
		end

		-- Setup LSP servers via Mason
		mason_lspconfig.setup_handlers({
			-- Default handler
			function(server_name)
				lspconfig[server_name].setup({
					capabilities = capabilities,
				})
			end,
			["lua_ls"] = function()
				lspconfig["lua_ls"].setup({
					capabilities = capabilities,
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
					root_dir = function(fname)
						return lspconfig.util.root_pattern(".git", "package.json", "prisma/schema.prisma")(fname)
							or vim.fs.dirname(fname)
					end,
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
			end,
			["yamlls"] = function()
				lspconfig["yamlls"].setup({
					capabilities = capabilities,
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
							schemas = require("schemastore").yaml.schemas(),
							schemaStore = {
								enable = false,
								url = "",
							},
						},
					},
				})
			end,
			["helm_ls"] = function()
				lspconfig["helm_ls"].setup({
					capabilities = capabilities,
					settings = {
						["helm-ls"] = {
							yamlls = {
								enabled = false,
							},
						},
					},
				})
			end,
		})
	end,
}
