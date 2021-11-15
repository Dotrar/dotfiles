-- Dre's Neovim init.lua

-- convenience aliases
local cmd = vim.cmd  -- to execute Vim commands e.g. cmd('pwd')
local fn = vim.fn    -- to call Vim functions e.g. fn.bufnr()
local g = vim.g      -- a table to access global variables
local opt = vim.opt  -- to set options

-- Install packer
local install_path = vim.fn.stdpath 'data' .. '/site/pack/packer/start/packer.nvim'

if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  vim.fn.execute('!git clone https://github.com/wbthomason/packer.nvim ' .. install_path)
end

vim.api.nvim_exec(
  [[
  augroup Packer
    autocmd!
    autocmd BufWritePost init.lua PackerCompile
  augroup end
]],
  false
)

-- to install plugins once you've changed this section, simply 
-- :so %
-- :PackerInstall
local use = require('packer').use
require('packer').startup(function()
  use 'wbthomason/packer.nvim' -- Package manager
  use 'tpope/vim-fugitive' -- Git commands in nvim
  use 'tpope/vim-rhubarb' -- Fugitive-companion to interact with github
  use 'tpope/vim-commentary' -- "gc" to comment visual regions/lines

  -- UI to select things (files, grep results, open buffers...)
  use { 'nvim-telescope/telescope.nvim', requires = { { 'nvim-lua/popup.nvim' }, { 'nvim-lua/plenary.nvim' } } }
  use 'fatih/molokai' --better theme
  --
  -- Highlight, edit, and navigate code using a fast incremental parsing library
  use 'nvim-treesitter/nvim-treesitter'

  -- Additional textobjects for treesitter
  use 'nvim-treesitter/nvim-treesitter-textobjects'
  use 'neovim/nvim-lspconfig' -- Collection of configurations for built-in LSP client
  use 'hrsh7th/nvim-compe' -- Autocompletion plugin
  use 'L3MON4D3/LuaSnip' -- Snippets plugin

end)

vim.o.inccommand = 'nosplit' --Incremental live completion
vim.o.hlsearch = true --Set highlight on search
vim.wo.number = true --Make line numbers default
vim.o.hidden = true --Do not save when switching buffers
vim.o.mouse = 'a' --Enable mouse mode
vim.o.breakindent = true --Enable break indent

--Case insensitive searching UNLESS /C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

--Decrease update time
vim.o.updatetime = 250
vim.wo.signcolumn = 'yes'

--Set colorscheme (order is important here)
vim.o.termguicolors = true
vim.g.onedark_terminal_italics = 2
vim.cmd [[colorscheme molokai]]

--Remap space as leader key
-- vim.api.nvim_set_keymap('', '<Space>', '<Nop>', { noremap = true, silent = true })
-- vim.g.mapleader = ' '
-- vim.g.maplocalleader = ' '

--Remap for dealing with word wrap
vim.api.nvim_set_keymap('n', 'k', "v:count == 0 ? 'gk' : 'k'", { noremap = true, expr = true, silent = true })
vim.api.nvim_set_keymap('n', 'j', "v:count == 0 ? 'gj' : 'j'", { noremap = true, expr = true, silent = true })

-- Telescope
require('telescope').setup {
  defaults = {
    mappings = {
      i = {
        ['<C-u>'] = false,
        ['<C-d>'] = false,
      },
    },
  },
}
--Add leader shortcuts
vim.api.nvim_set_keymap('n', '<leader><space>', [[<cmd>lua require('telescope.builtin').buffers()<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>sf', [[<cmd>lua require('telescope.builtin').find_files({previewer = false})<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>sb', [[<cmd>lua require('telescope.builtin').current_buffer_fuzzy_find()<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>sh', [[<cmd>lua require('telescope.builtin').help_tags()<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>st', [[<cmd>lua require('telescope.builtin').tags()<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>sd', [[<cmd>lua require('telescope.builtin').grep_string()<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>sp', [[<cmd>lua require('telescope.builtin').live_grep()<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>so', [[<cmd>lua require('telescope.builtin').tags{ only_current_buffer = true }<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>?', [[<cmd>lua require('telescope.builtin').oldfiles()<CR>]], { noremap = true, silent = true })

-- Highlight on yank
vim.api.nvim_exec(
  [[
  augroup YankHighlight
    autocmd!
    autocmd TextYankPost * silent! lua vim.highlight.on_yank()
  augroup end
]],
  false
)

-- Y yank until the end of line
vim.api.nvim_set_keymap('n', 'Y', 'y$', { noremap = true })

-- LSP settings
local nvim_lsp = require 'lspconfig'
local on_attach = function(_, bufnr)
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  local opts = { noremap = true, silent = true }
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  -- vim.api.nvim_buf_set_keymap(bufnr, 'v', '<leader>ca', '<cmd>lua vim.lsp.buf.range_code_action()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>so', [[<cmd>lua require('telescope.builtin').lsp_document_symbols()<CR>]], opts)
  vim.cmd [[ command! Format execute 'lua vim.lsp.buf.formatting()' ]]
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

-- Enable the following language servers
local servers = { 'jedi'}
for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup {
    on_attach = on_attach,
    capabilities = capabilities,
  }
end

-- Make runtime files discoverable to the server
local runtime_path = vim.split(package.path, ';')
table.insert(runtime_path, 'lua/?.lua')
table.insert(runtime_path, 'lua/?/init.lua')


-- Treesitter configuration
-- Parsers must be installed manually via :TSInstall
require('nvim-treesitter.configs').setup {
  highlight = {
    enable = true, -- false will disable the whole extension
  },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = 'gnn',
      node_incremental = 'grn',
      scope_incremental = 'grc',
      node_decremental = 'grm',
    },
  },
  indent = {
    enable = true,
  },
  textobjects = {
    select = {
      enable = true,
      lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
      keymaps = {
        -- You can use the capture groups defined in textobjects.scm
        ['af'] = '@function.outer',
        ['if'] = '@function.inner',
        ['ac'] = '@class.outer',
        ['ic'] = '@class.inner',
      },
    },
    move = {
      enable = true,
      set_jumps = true, -- whether to set jumps in the jumplist
      goto_next_start = {
        [']m'] = '@function.outer',
        [']]'] = '@class.outer',
      },
      goto_next_end = {
        [']M'] = '@function.outer',
        [']['] = '@class.outer',
      },
      goto_previous_start = {
        ['[m'] = '@function.outer',
        ['[['] = '@class.outer',
      },
      goto_previous_end = {
        ['[M'] = '@function.outer',
        ['[]'] = '@class.outer',
      },
    },
  },
}

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'

-- Compe setup
require('compe').setup {
  source = {
    path = true,
    nvim_lsp = true,
    luasnip = true,
    buffer = false,
    calc = false,
    nvim_lua = false,
    vsnip = false,
    ultisnips = false,
  },
}

-- Utility functions for compe and luasnip
local t = function(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

local check_back_space = function()
  local col = vim.fn.col '.' - 1
  if col == 0 or vim.fn.getline('.'):sub(col, col):match '%s' then
    return true
  else
    return false
  end
end

-- Use (s-)tab to:
--- move to prev/next item in completion menuone
--- jump to prev/next snippet's placeholder
local luasnip = require 'luasnip'

_G.tab_complete = function()
  if vim.fn.pumvisible() == 1 then
    return t '<C-n>'
  elseif luasnip.expand_or_jumpable() then
    return t '<Plug>luasnip-expand-or-jump'
  elseif check_back_space() then
    return t '<Tab>'
  else
    return vim.fn['compe#complete']()
  end
end

_G.s_tab_complete = function()
  if vim.fn.pumvisible() == 1 then
    return t '<C-p>'
  elseif luasnip.jumpable(-1) then
    return t '<Plug>luasnip-jump-prev'
  else
    return t '<S-Tab>'
  end
end

-- Map tab to the above tab complete functiones
vim.api.nvim_set_keymap('i', '<Tab>', 'v:lua.tab_complete()', { expr = true })
vim.api.nvim_set_keymap('s', '<Tab>', 'v:lua.tab_complete()', { expr = true })
vim.api.nvim_set_keymap('i', '<S-Tab>', 'v:lua.s_tab_complete()', { expr = true })
vim.api.nvim_set_keymap('s', '<S-Tab>', 'v:lua.s_tab_complete()', { expr = true })

-- Map compe confirm and complete functions
vim.api.nvim_set_keymap('i', '<cr>', 'compe#confirm("<cr>")', { expr = true })
vim.api.nvim_set_keymap('i', '<c-space>', 'compe#complete()', { expr = true })















-- filetype off
-- set nocompatible
-- "
-- " -------------------
-- " Dre's Neovim config
-- " ===================

-- " Leader
-- let mapleader = ","

-- " Colours
-- set termguicolors

-- let g:loaded_python_provider = 0 " disable py2

-- " neovim-plug Plugins -----------------
-- " using the `plugged` plugin manager
-- call plug#begin(stdpath('data') . '/plugged')

--     " ----------------------------------
--     Plug 'tpope/vim-fugitive'
--     Plug 'tpope/vim-rhubarb' "allows 'open in github'
--     Plug 'ervandew/supertab' "allows a lot of tab completions
--     let g:SuperTabDefaultCompletionType = "<c-n>" "change completions to be top to bot.
--     Plug 'tpope/vim-commentary' "allow toggle comment line

--     Plug 'kshenoy/vim-signature' "show marks in the number column, very handy as reminder
--     Plug 'folke/zen-mode.nvim'   "Silence distraction to work on just the one buffer

--     "New Config
--     Plug 'neovim/nvim-lspconfig'
    

--     Plug 'tpope/vim-markdown'
--     Plug 'tbastos/vim-lua'
--     Plug 'fatih/molokai'

--     " These are related to telescope that I haven't set up yet.
--     Plug 'nvim-lua/popup.nvim'
--     Plug 'nvim-lua/plenary.nvim'
--     Plug 'nvim-telescope/telescope.nvim'

--     " Better python syntax highlighting
-- "    Plug 'numirias/semshi', {'do': ':UpdateRemotePlugins'}
-- "    Plug 'preservim/tagbar'


-- call plug#end()



-- require'lspconfig'.jedi_language_server.setup{}


-- " Git log ( Query ) 
-- nnoremap <leader>q :vertical Git log -10 --name-status<CR>
-- " Vim commentary
-- " this is special key, so it means Ctrl forward Slash, under '?'
-- noremap <C-_> :Commentary<CR>

-- "set stl=%F\ %m\ %r\ Line:%l/%L[%p%%]\ Col:%c\ Buf:%n\ [%b][0x%B] 
-- set statusline=%<%F\ %h%m%r%=%{tagbar#currenttag('%s\ ','','f')}%-.(%l,%c%V%)\ %P


-- let g:netrw_liststyle=3     " Tree mode view
-- let g:netrw_browse_split=0  " Open file in previous buffer
-- let g:netrw_winsize=10      " Make netrw window smaller

-- let g:markdown_fenced_languages = ['html', 'python', 'bash=sh']
-- let g:markdown_syntax_conceal = 0
-- let g:markdown_minlines = 100

-- " Python indent options
-- " I'm not sure why these are set on my machine and no where else
-- let g:pyindent_continue = 4
-- let g:pyindent_open_paren = 4


-- let g:fzf_preview_window = ['right:60%', 'ctrl-/']

-- colorscheme molokai
-- if has("nvim-0.5.0")
--     set signcolumn=number
-- endif

-- " for pdf generation
-- autocmd! BufRead,BufNewFile *.rml set filetype=xml 


-- " Keybindings 
-- " =========================

-- " gq shows current diff (fugitive) - acts like a toggle, as gq closes it again
-- nnoremap gq :Git<Cr>
-- " F2 shows open buffers (fzf), Ctrl-F2 delete buffers (tab select)
-- nmap <F2> :Buffers<CR>
-- nmap <C-F2> :BufferDelete<CR>

-- " F3 Open new file (fzf)
-- " C-F3 search files like a gf
-- nmap <F3> :Files<CR>
-- nmap <leader>f :let f=expand("<cfile>")<cr> :execute("SearchFiles ".f)<CR>
-- " F4 search for line and open file (fzf)
-- nmap <F4> :Ag<CR>

-- " Commands based on navigating code at a macro level
-- " F5 - find where "the function I'm in" is used. go up call stack
-- nmap <F5> ?\C\<def\><CR>w:Ag (?<!def )(?<!_)<C-r><C-w><CR>
-- " F6 - find where else this is mentioned
-- nmap <F6> :Ag <C-r><C-w><CR>

-- " F7 - Files near me
-- nmap <F7> :Explore<CR>

-- " F8 - outline of symbols on page
-- nmap <F8> :TagbarToggle<CR>
-- nmap <C-F8> :CocList outline<CR>

-- " History browser.
-- nmap <C-H> :History<CR>

-- " F9 - Find similarly named files
-- " <leader>t - Find related test/func files
-- nmap <F9> :SearchFiles expand('%:t')<CR>
-- nmap <leader>t :execute 'SearchFiles "'.<SID>related_test().'"'<CR>

-- " go to definition of function, ( go down call stack ) 
-- nmap <leader>d <Plug>(coc-definition)
-- " open up definition of function in a vsplit 
-- nmap <leader>v :vsp<CR><Plug>(coc-definition)<C-w>j

-- nmap <leader>] <Plug>(coc-diagnostic-next)
-- nmap <leader>\ :<C-u>CocList diagnostics<cr>

-- " change from = sign onwards.
-- nmap c= $T=C
-- " ============== Find similar files (by name or by test)

-- " F9 - Find similarly named files
-- nmap <F9> :SearchFiles expand('%:t')<CR>

-- " <leader>t - Find related test/func files
-- nmap <leader>t :execute 'SearchFiles "'.<SID>related_test().'"'<CR>

-- " ---------------- 
-- command! -nargs=1 SearchFiles call fzf#vim#files('.', {'options':'--query <args>'})
-- function! s:related_test()
--     " this will get 'context.py' from 'test_context.py'
--     " and 'test_context.py' from 'context.py'
--     " with the filepath extended out
--     let l:filename = expand('%:t')
--     if l:filename =~ 'test'
--         let l:searchfile = substitute(l:filename,'^test_','','')
--     else
--         let l:searchfile = 'test_' . l:filename
--     endif

--     return join(split(expand('%:h'),'/')[3:],' ') . ' ' . l:searchfile
-- endfunction


-- " ============== This is all related to being able to dlete buffer window from
-- " Ctrl-F2

-- function! s:list_buffers()
--   redir => list
--   silent ls
--   redir END
--   return split(list, "\n")
-- endfunction

-- function! s:delete_buffers(lines)
--   execute 'bwipeout!' join(map(a:lines, {_, line -> split(line)[0]}))
-- endfunction

-- command! BufferDelete call fzf#run(fzf#wrap({
--   \ 'source': s:list_buffers(),
--   \ 'sink*': { lines -> s:delete_buffers(lines) },
--   \ 'options': '--multi --reverse --bind ctrl-a:select-all+accept'
-- \ }))

-- " ==============================================================================

-- function SetPythonOptions()
--     let b:ale_fixers = ['black', 'isort']
--     let b:ale_fix_on_save = 1
-- endfunction

-- " au BufReadPost */tickets/* call SetMarkdownOptions()
-- au FileType python call SetPythonOptions()
-- " Don't hide values
-- au FileType json let conceallevel=0

-- filetype plugin indent on
-- syntax enable
-- set mouse=a

-- set background=dark
-- " A nice font
-- set guifont=Comic\ Mono:h16

-- set tabstop=4 
-- set expandtab
-- set shiftwidth=4
-- set softtabstop=4

-- "set wrapscan
-- set wrap!
-- set linebreak

-- set cursorline
-- set noshowcmd
-- set noshowmode

-- set number
-- set relativenumber

-- function! NumberToggle()
-- 	if(&relativenumber == 1)
--         set norelativenumber
-- 	else
-- 		set relativenumber
-- 	endif
-- endfunc
-- nnoremap <C-n> :call NumberToggle()<cr>

-- "Searching
-- " nnoremap / /\v
-- " vnoremap / /\v

-- " backspace over tabs
-- set backspace=indent,eol,start

-- " Search options
-- set hlsearch 
-- set incsearch 
-- set showmatch
-- set ignorecase
-- set smartcase


-- "set showbreak=~>
-- "set listchars=eol:$,tab:>-,trail:~,extends:>,precedes:<
-- "set list

-- "nnoremap K <nop>

-- set shellslash
-- set vb
-- set backspace=2
-- set hidden

-- set nopaste

-- set laststatus=2

-- set pastetoggle=<F2>

-- set scrolloff=999
-- set fillchars=""

-- nmap <silent> ,p :set invpaste<CR>:set paste?<CR>

-- set autoindent
-- set nobackup
-- set noswapfile


-- map <up> <nop>
-- map <down> <nop>
-- map <left> <nop>
-- map <right> <nop>

-- nmap <silent> ,/ :nohlsearch<CR>

-- let g:python_recommended_style = 0

-- " ==================================================
-- " References
-- " --------------------------------------------------
-- " Plugin Manager:
-- "   plug-vim					https://github.com/junegunn/vim-plug
-- " 
-- " 
-- " 
-- " 
-- " 
-- " 
-- " 
-- " 
