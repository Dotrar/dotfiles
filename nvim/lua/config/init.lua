-- Set up harpoon
require("harpoon").setup({ global_settings = { save_on_toggle = true } })

-- require'shade'.setup({
--   overlay_opacity = 30,
--   opacity_step = 1,
--   keys = {
--     brightness_up    = '<C-Up>',
--     brightness_down  = '<C-Down>',
--     -- toggle           = '<Leader>`',
--   }
-- })


local lnkmap = function(mapping, command)
	vim.api.nvim_set_keymap(
		"n",
		"<leader>" .. mapping,
		"<cmd>lua " .. command .. "<CR>",
		{ noremap = true, silent = true }
	)
end

lnkmap("<space>", "require('telescope.builtin').buffers()")
lnkmap("sf", "require('telescope.builtin').find_files({previewer = false})")
lnkmap("sb", "require('telescope.builtin').current_buffer_fuzzy_find()")
lnkmap("sh", "require('telescope.builtin').help_tags()")
-- lnkmap("st", "require('telescope.builtin').tags()") -- this is way too laggy and will crash out
lnkmap("sd", "require('telescope.builtin').grep_string()")
lnkmap("sp", "require('telescope.builtin').live_grep()")
lnkmap("so", "require('telescope.builtin').tags{ only_current_buffer = true }")
lnkmap("?", "require('telescope.builtin').oldfiles()")

-- Treesitter configuration
-- Parsers must be installed manually via :TSInstall
require("nvim-treesitter.configs").setup({
	highlight = {
		enable = true, -- false will disable the whole extension
	},
	incremental_selection = {
		enable = true,
		keymaps = {
			init_selection = "gnn",
			node_incremental = "grn",
			scope_incremental = "grc",
			node_decremental = "grm",
		},
	},
	indent = {
		enable = true,
        disable = { 'python' },
	},
	textobjects = {
		select = {
			enable = true,
			lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
			keymaps = {
				-- You can use the capture groups defined in textobjects.scm
				["af"] = "@function.outer",
				["if"] = "@function.inner",
				["ac"] = "@class.outer",
				["ic"] = "@class.inner",
			},
		},
		move = {
			enable = true,
			set_jumps = true, -- whether to set jumps in the jumplist
			goto_next_start = {
				["]m"] = "@function.outer",
				["]]"] = "@class.outer",
			},
			goto_next_end = {
				["]M"] = "@function.outer",
				["]["] = "@class.outer",
			},
			goto_previous_start = {
				["[m"] = "@function.outer",
				["[["] = "@class.outer",
			},
			goto_previous_end = {
				["[M"] = "@function.outer",
				["[]"] = "@class.outer",
			},
		},
	},
})

-- LSP settings
local lspconfig = require("lspconfig")
local on_attach = function(_, bufnr)
	vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

	local bnkmap = function(keys, command)
		vim.api.nvim_buf_set_keymap(
			bufnr,
			"n",
			keys,
			"<cmd>lua " .. command .. "<cr>",
			{ noremap = true, silent = true }
		)
	end
	local bikmap = function(keys, command)
		vim.api.nvim_buf_set_keymap(
			bufnr,
			"i",
			keys,
			"<cmd>lua " .. command .. "<cr>",
			{ noremap = true, silent = true }
		)
	end

	bnkmap("gD", "vim.lsp.buf.declaration()")
	bnkmap("gd", "vim.lsp.buf.definition()")
	bnkmap("K", "vim.lsp.buf.hover()")
	bnkmap("gi", "vim.lsp.buf.implementation()")
	bnkmap("<C-k>", "vim.lsp.buf.signature_help()")
	bikmap("<C-k>", "vim.lsp.buf.signature_help()")
	bnkmap("gr", "vim.lsp.buf.references()")
	bnkmap("[d", "vim.diagnostic.goto_prev()")
	bnkmap("]d", "vim.diagnostic.goto_next()")
	bnkmap("<leader>wa", "vim.lsp.buf.add_workspace_folder()")
	bnkmap("<leader>wr", "vim.lsp.buf.remove_workspace_folder()")
	bnkmap("<leader>wl", "print(vim.inspect(vim.lsp.buf.list_workspace_folders()))")
	bnkmap("<leader>D", "vim.lsp.buf.type_definition()")
	bnkmap("<leader>rn", "vim.lsp.buf.rename()")
	bnkmap("<leader>ca", "vim.lsp.buf.code_action()")
	bnkmap("<leader>i", "vim.diagnostic.open_float()")
	bnkmap("<leader>q", "vim.diagnostic.setloclist()")
	bnkmap("<leader>so", "require('telescope.builtin').lsp_document_symbols()")

	-- vim.cmd([[ command! Format execute 'lua vim.lsp.buf.formatting()' ]])
end

-- nvim-cmp supports additional completion capabilities
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").update_capabilities(capabilities)

-- Enable the following language servers
-- local servers = { "jedi_language_server", "cssls", "jsonls" }
local servers = { "pyright", "cssls", "jsonls" }
for _, lsp in ipairs(servers) do
	lspconfig[lsp].setup({
		on_attach = on_attach,
		capabilities = capabilities,
	})
end

-- Make runtime files discoverable to the server
local runtime_path = vim.split(package.path, ";")
table.insert(runtime_path, "lua/?.lua")
table.insert(runtime_path, "lua/?/init.lua")

lspconfig.sumneko_lua.setup({
	cmd = { vim.fn.getenv("HOME") .. "/tmp/lua-language-server/bin/Linux/lua-language-server" },
	on_attach = on_attach,
	capabilities = capabilities,
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

-- Set completeopt to have a better completion experience
vim.o.completeopt = "menuone,noselect"

-- luasnip setup
local luasnip = require("luasnip")

-- nvim-cmp setup
local cmp = require("cmp")
cmp.setup({
	snippet = {
		expand = function(args)
			luasnip.lsp_expand(args.body)
		end,
	},
	mapping = {
		["<C-p>"] = cmp.mapping.select_prev_item(),
		["<C-n>"] = cmp.mapping.select_next_item(),
		["<C-d>"] = cmp.mapping.scroll_docs(-4),
		["<C-f>"] = cmp.mapping.scroll_docs(4),
		["<C-Space>"] = cmp.mapping.complete(),
		["<C-e>"] = cmp.mapping.close(),
		-- ["<CR>"] = cmp.mapping.confirm({
		-- 	behavior = cmp.ConfirmBehavior.Replace,
		-- 	select = true,
		-- }),
		["<C-y>"] = cmp.mapping(
			cmp.mapping.confirm({
				behavior = cmp.ConfirmBehavior.Insert,
				select = true,
			}),
			{ "i", "c" }
		),

		["<Tab>"] = function(fallback)
			if cmp.visible() then
				cmp.select_next_item()
			elseif luasnip.expand_or_jumpable() then
				luasnip.expand_or_jump()
			else
				fallback()
			end
		end,
		["<S-Tab>"] = function(fallback)
			if cmp.visible() then
				cmp.select_prev_item()
			elseif luasnip.jumpable(-1) then
				luasnip.jump(-1)
			else
				fallback()
			end
		end,
	},
	sources = {
        { name = "nvim_lua" },
		{ name = "nvim_lsp" },
		{ name = "luasnip" },
		{ name = "conjure" },
	},
})

-- Telescope
require("telescope").setup({
	defaults = {
		mappings = {
			i = {
				["<C-u>"] = false,
				["<C-d>"] = false,
			},
		},
	},
})

