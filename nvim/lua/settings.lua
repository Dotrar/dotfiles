vim.cmd("hi WinSeperator ctermbg=None")

-- tab settings
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.autoindent = true

-- visibility
vim.opt.showcmd = true
vim.opt.wrap = false
vim.opt.signcolumn = 'no'
vim.opt.statusline = [[%<%F %h%m%r%=%{nvim_treesitter#statusline(15)}%-.( %l,%c%V%) %P]]
vim.opt.scrolloff = 8
vim.opt.updatetime = 50
vim.opt.cursorline = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.guicursor = ""
vim.opt.hlsearch = true

-- other
vim.opt.swapfile = false
vim.opt.termguicolors = true

-- file type options
vim.api.nvim_create_autocmd(
    { 'BufNewFile', 'BufRead', },
    {
        pattern = { '*.html', '*.rml' },
        callback = function(ev)
            local b = ev.buf
            vim.bo.filetype = 'htmldjango'
            vim.bo.tabstop = 2
            vim.bo.shiftwidth = 2
        end
    })
