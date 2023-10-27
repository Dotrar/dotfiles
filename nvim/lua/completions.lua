local cmp = require 'cmp'
local luasnip = require 'luasnip'


cmp.setup({
  snippet = { expand = function(args) luasnip.lsp_expand(args.body) end },
  mapping = cmp.mapping.preset.insert({
    ["<c-p>"] = cmp.mapping.select_prev_item(),
    ["<c-n>"] = cmp.mapping.select_next_item(),
  }),
  sources = cmp.config.sources({
    { name = "nvim_lsp" },
    { name = "luasnip" },
  }, {
    { name = 'buffer' }
  })
})
print("Loaded cmp")

-- add in some highlight colours

for _, v in ipairs({
  "highlight! CmpItemKind guibg=#000000 guifg=#EEEEEE",
  "highlight! CmpItemAbbrDeprecated guibg=NONE gui=strikethrough guifg=#808080",
  "highlight! CmpItemAbbrMatch guibg=NONE guifg=#569CD6",
  "highlight! link CmpItemAbbrMatchFuzzy CmpItemAbbrMatch",
  "highlight! CmpItemKindVariable guibg=NONE guifg=#9CDCFE",
  "highlight! link CmpItemKindInterface CmpItemKindVariable",
  "highlight! link CmpItemKindText CmpItemKindVariable",
  "highlight! CmpItemKindFunction guibg=NONE guifg=#C586C0",
  "highlight! link CmpItemKindMethod CmpItemKindFunction",
  "highlight! CmpItemKindKeyword guibg=NONE guifg=#D4D4D4",
  "highlight! link CmpItemKindProperty CmpItemKindKeyword",
  "highlight! link CmpItemKindUnit CmpItemKindKeyword",
}) do vim.cmd(v) end
