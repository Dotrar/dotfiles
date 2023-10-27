local cmp = require 'cmp_nvim_lsp'
local lsp = require 'lspconfig'

local capabilities = cmp.default_capabilities(vim.lsp.protocol.make_client_capabilities())

local settings = {
  ["rust-analyzer"] = {
  },
  pylsp = {
    plugins = {
      noy_pyls = { enabled = true },
      pydocstyle = { enabled = false },
      pycodestyle = { enabled = false },
      pyflakes = { enabled = false },
      flake8 = { enabled = true },
      mccabe = { enabled = false },
      pylint = { enabled = false },
      yapf = { enabled = false },
      pyls_isort = { enabled = false },
      black = { enabled = true, line_length = 100 },
      pylsp_mypy = { enabled = false, dmypy=true, live_mode=false },
      ruff = { enabled = true, extendSelect={"I"}, },
    },
  },
}

require("neodev").setup({})

for _, server in ipairs { "rust_analyzer", "lua_ls", "pylsp", "dartls"} do
  lsp[server].setup({
    capabilities = capabilities,
    settings = settings,
  })
end

vim.api.nvim_create_autocmd(
  "LspAttach",
  {
    group = vim.api.nvim_create_augroup("UserLspConfig", {}),
    callback = function(ev)
      local options = { buffer = ev.buf, noremap=true,silent=true }

      vim.cmd("autocmd BufWritePre * lua vim.lsp.buf.format()")
      -- lsp actions
      vim.keymap.set("n", "gd", vim.lsp.buf.definition, options)
      vim.keymap.set("n", "grr", vim.lsp.buf.references, options)
      vim.keymap.set("n", "K", vim.lsp.buf.hover, options)
      vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, options)
      vim.keymap.set("n", "<space>ca", vim.lsp.buf.code_action, options)
      vim.keymap.set("i", "<c-k>", vim.lsp.buf.signature_help)

      -- diagnostics
      vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
      vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
      vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
      vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)
    end,
  }
)
