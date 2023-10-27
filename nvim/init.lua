-- bootstrap lazy.nvim
require 'bootstrap'
local shortcuts = require 'shortcuts'

-- leaderkey
vim.api.nvim_set_keymap("", "<space>", "<nop>", {
  noremap = true,
  silent = true
})
vim.g.mapleader = " "
vim.g.maplocalleader = " "


local lazy_config = {
  dev = {
    path = "~/Workbench/nvim_plugins/"
  },
  performance = {
    rtp = {
      disabled_plugins = { "tarPlugin", "tutor", "zipPlugin", "tohtml", "gzip"
      }
    } }
}


local plugins = {
  { "ibhagwan/fzf-lua",   cmd = "FzfLua", lazy = false },
  { "tpope/vim-fugitive", cmd = "Git" },
  { "neovim/nvim-lspconfig", dependencies = {
    "hrsh7th/cmp-nvim-lsp"
  } },
  { "hrsh7th/nvim-cmp", lazy = false, dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    "hrsh7th/cmp-cmdline",
    "onsails/lspkind-nvim",
    "L3MON4D3/LuaSnip",
    'saadparwaiz1/cmp_luasnip',
  }, mod = "cmp", version = false },

  { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
  { "fatih/molokai",                   lazy = false },
  { "folke/neodev.nvim",               opts = {} },

}

require("lazy").setup(plugins, lazy_config)

require 'settings'
require 'mappings'
require 'lsp'
require 'treesitter'
require 'completions'

shortcuts.pcmd('colorscheme molokai')
