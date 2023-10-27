local git = require 'helpers/git'
local tmux = require 'helpers/tmux'
local files = require 'helpers/test_files'

-- fzf
local fzf = require 'fzf-lua'


-- some misc things
vim.keymap.set('n', '<F1>', ':vertical help ')
vim.keymap.set('n', 'rr', ':%s///g<left><left>')
vim.keymap.set('n', '//', ':nohlsearch<cr>')

vim.keymap.set('n', '<leader>n', ':Explore<cr>')

vim.keymap.set('n', '<leader>te', tmux.open_split)

vim.keymap.set('n', '<leader>g', git.git_status)
vim.keymap.set('n', '<leader>gl', git.git_log)
vim.keymap.set('n', '<leader>gb', ':Git blame<cr>')
vim.keymap.set('n', '<leader>go', git.open_in_github)

-- from primeagen
vim.keymap.set("x", "<leader>p", "\"_dP")
vim.keymap.set("n", "<leader>y", "\"+y")
vim.keymap.set("v", "<leader>y", "\"+y")
vim.keymap.set("n", "<leader>Y", "\"+Y")
vim.keymap.set("n", "<leader><", "<cmd>cnext<cr>zz")
vim.keymap.set("n", "<leader>>", "<cmd>cprev<cr>zz")

-- fuzzyfinder
local fuzzymaps = {
    f = fzf.files,
    o = fzf.oldfiles,
    l = fzf.lines,
    h = fzf.help_tags,
    w = fzf.grep_cword,
    t = files.find_test_flies,
    s = fzf.live_grep_native,
    e = fzf.lsp_document_symbols,
    ['<space>'] = fzf.buffers
}

for k, v in pairs(fuzzymaps) do
    vim.keymap.set('n', '<leader>f' .. k, v)
end
