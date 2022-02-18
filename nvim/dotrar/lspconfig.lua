local lspconfig = require("lspconfig")

-- local lsp_status = require('lsp-status')
-- lsp_status.register_progress()

local sumneko_root_path = "/home/dre/tmp/lua-language-server"
local sumneko_binary = sumneko_root_path .. "/bin/Linux/lua-language-server"
local runtime_path = vim.split(package.path, ";")

table.insert(runtime_path, "lua/?.lua")
table.insert(runtime_path, "lua/?/init.lua")

--
--Enable (broadcasting) snippet capability for completion
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

-- capabilities = vim.tbl_extend('leep', capabilities, lsp_status.capabilities)

-- setting up an on-attach function to allow us to
-- keep the same keybindings across all lsp's
local on_attach = function(client, bufnr)
	if client.resolved_capabilities.document_formatting then
		vim.cmd("autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()")
	end
	local function kmap(...)
		vim.api.nvim_buf_set_keymap(bufnr, ...)
	end
	local function buf_set_option(...)
		vim.api.nvim_buf_set_option(bufnr, ...)
	end

	-- Enable completion triggered by <c-x><c-o>
	buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")

	-- Mappings.
	local opts = { noremap = true, silent = true }

	-- See `:help vim.lsp.*` for documentation on any of the below functions
	kmap("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
	kmap("n", "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
	kmap("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
	kmap("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
	kmap("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
	kmap("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
	kmap("n", "<space>wa", "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>", opts)
	kmap("n", "<space>wr", "<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>", opts)
	kmap("n", "<space>wl", "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>", opts)
	kmap("n", "<space>D", "<cmd>lua vim.lsp.buf.type_definition()<CR>", opts)
	kmap("n", "<space>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
	kmap("n", "<space>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)
	kmap("n", "<space>e", "<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>", opts)
	kmap("n", "<space>q", "<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>", opts)
	kmap("n", "<space>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
	kmap("n", "[d", "<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>", opts)
	kmap("n", "]d", "<cmd>lua vim.lsp.diagnostic.goto_next()<CR>", opts)

	-- alos load lsp
	--lsp_status.on_attach(client, bufnr)
end

-- require("null-ls").config({
-- 	sources = {
-- 		require("null-ls").builtins.formatting.stylua,
-- 		require("null-ls").builtins.completion.spell,
-- 	},
-- })

lspconfig.sumneko_lua.setup({
	cmd = { sumneko_binary, "-E", sumneko_root_path .. "/main.lua" },
	commands = {
		Format = {
			function()
				require("stylua-nvim").format_file()
			end,
		},
	},
	settings = {
		Lua = {
			runtime = {
				-- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
				version = "LuaJIT",
				-- Setup your lua path
				path = runtime_path,
			},
			diagnostics = {
				-- Get the language server to recognize the `vim` global
				globals = { "vim" },
			},
			workspace = {
				-- Make the server aware of Neovim runtime files
				library = vim.api.nvim_get_runtime_file("", true),
			},
			-- Do not send telemetry data containing a randomized but unique identifier
			telemetry = {
				enable = false,
			},
		},
	},
})

-- pyright is amazingly slow on the kraken codebase.
-- lspconfig.pyright.setup({
-- 	on_attach = on_attach,
-- })

lspconfig.jedi_language_server.setup({
	on_attach = on_attach,
	capabilities = capabilities,
})

lspconfig.cssls.setup({
	capabilities = capabilities,
})

lspconfig.jsonls.setup({
	commands = {
		Format = {
			function()
				vim.lsp.buf.range_formatting({}, { 0, 0 }, { vim.fn.line("$"), 0 })
			end,
		},
	},
})
