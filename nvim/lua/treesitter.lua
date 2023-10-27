local configs = require 'nvim-treesitter.configs'

configs.setup({
  ensure_installed = { 'lua', 'python', 'dart', 'rust' },
  highlight = { enable = true },
  indent = { enable = false },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "<leader>aa", -- set to `false` to disable one of the mappings
      scope_incremental = "<leader>an",
      node_incremental = "<tab>",
      node_decremental = "<s-tab>",
    },
  },
})
