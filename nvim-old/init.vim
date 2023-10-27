" Dre's Neovim config
" This is half-half in vim and lua, the lua configuration file goes in
" .config/nvim/lua/config/init.lua
" .config/nvim/lua/config/leaderkey.lua

" I generally find configuring the vim related options easier in viml, and the
" lua options in lua, which is why these are set seperately

" Colours
set termguicolors
set clipboard=unnamed

lua << EOF
-- the leader key needs to be set first, as many plugins do funky stuff with it that can break
require "config.leaderkey"
EOF

" neovim-plug Plugins -----------------
call plug#begin(stdpath('data') . '/plugged')

    Plug 'ggandor/lightspeed.nvim'  " provieds fast movement (like easymotion)
    Plug 'junegunn/goyo.vim'        " distraction free writing
    Plug 'sunjon/shade.nvim'        " dims other windows (slightly buggy)

    " Dev related plugin
    Plug 'L3MON4D3/LuaSnip'         " lua snippet management
    Plug 'MunifTanjim/nui.nvim'     " lua interfaces (for writing plugins)
    Plug 'ThePrimeagen/harpoon'     " quickly go to marked files
    Plug 'ckipp01/stylua-nvim'        " lua linter
    Plug 'euclidianAce/BetterLua.vim' " lua linter
    Plug 'folke/lua-dev.nvim'         " bunch of lua libs? 
    Plug 'hrsh7th/cmp-buffer'       " autocomplete from buffer
    Plug 'hrsh7th/cmp-cmdline'      " autocomplete ON cmdline
    Plug 'hrsh7th/cmp-nvim-lsp'     " autocomplete from lsp
    Plug 'hrsh7th/cmp-path'         " autcomplete filepaths
    Plug 'hrsh7th/nvim-cmp'         " main autocomplete library

    " FZF is an older Telescope
    Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
    Plug 'junegunn/fzf.vim'             "Common bindings for fzf and vim


    Plug 'kshenoy/vim-signature'        " show marks in the number column
    Plug 'neovim/nvim-lspconfig'        " simple lsp configuration wrapper
    Plug 'nvim-lua/completion-nvim'     " autocomplete nvim api functions
    Plug 'nvim-lua/plenary.nvim'        " lua interfaces (for writing plugins, many use this)
    Plug 'nvim-lua/popup.nvim'          " lua interfaces
    Plug 'nvim-telescope/telescope.nvim' " Telescope

    " Treesitter is for parsing of the buffer, good stuff generally, gotta
    " learn how to use it
    Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}  " We recommend updating the parsers on update
    Plug 'nvim-treesitter/nvim-treesitter-textobjects'


    Plug 'onsails/lspkind-nvim'         " I'm not actually sure
    Plug 'saadparwaiz1/cmp_luasnip'     " autocomplete from luasnips 
    Plug 'tbastos/vim-lua'              " lua filetype
    Plug 'tjdevries/nlua.nvim'          " neovim lua functions again I think? 
    Plug 'tpope/vim-commentary'         " allow 'toggle comment line'
    Plug 'tpope/vim-fugitive'           "Git bindings and commands
    Plug 'tpope/vim-rhubarb'            "allows 'open in github'

    " Colourschemes
    Plug 'fatih/molokai'                " Colourscheme

    " MARKDOWN writing plugins
    Plug 'tpope/vim-markdown'           " Markdown filetype
    Plug 'mzlogin/vim-markdown-toc'     " Autogenerate table of contents
    Plug 'vimwiki/vimwiki'              " Use vimwiki for notes 
    Plug 'ferrine/md-img-paste.vim'     " copy image data, paste images into markdown buffer
                                        " via write to directory, then paste
                                        " reference

    " LISP related plugins
    Plug 'jpalardy/vim-slime'           " Interact with REPL (ipython, sbcl) - very good
    Plug 'tpope/vim-unimpaired'         " parens management
    Plug 'kovisoft/paredit'             " parens management
    " Plug 'Olical/conjure'             " very good plugin for eval. I do dev
                                        " work for this, so I have a local
                                        " copy

    Plug 'Olical/aniseed'               " Run FENNEL lang in nvim
    Plug 'PaterJason/cmp-conjure'       " autocomplete from fennel lang (ie: from conjure)

    " Custom Plugins
    Plug '~/Workbench/conjure'          " Local copy of conjure for dev work
    Plug '~/Workbench/RenWu'            " TODO list / reminders working on

    " Python specific plugins
    Plug 'dense-analysis/ale'           " Python linting and fixing 

    " Semshi is really nice, but I'm currently trying to re-write it one day
    " Plug 'numirias/semshi', {'do': ':UpdateRemotePlugins'}

call plug#end() 

" Must use this to allow aniseed to load FENNEL files ( in fnl/init.fnl) as
" config files, just like lua/init.lua 
let g:aniseed#env = v:true




" Management of filetypes
autocmd Filetype html       setlocal tabstop=2 shiftwidth=2 expandtab
autocmd Filetype css        setlocal tabstop=2 shiftwidth=2 expandtab
autocmd Filetype htmldjango setlocal tabstop=2 shiftwidth=2 expandtab

autocmd BufNewFile,BufRead *.html set filetype=htmldjango
autocmd BufRead,BufNewFile *.rml  set filetype=htmldjango



nnoremap <silent> <leader>nh :set iskeyword-=.<CR>:vert help <C-R><C-W><CR>:set iskeyword+=.<CR>
nnoremap <silent> <leader>/ :nohlsearch<CR>
nnoremap <silent> <leader>q :vertical Git log ...master --name-status<CR>
nnoremap <silent> <leader>o :.GBrowse master:%<CR>
nnoremap <silent> <leader>l :Lines<Cr>
nnoremap <silent> <leader>e :EditConfigs<CR>
nnoremap <silent> <leader>w :echo(expand('%'))<CR>
nnoremap <silent> <leader>g :RenWu<space>
nnoremap <silent> <leader>k :Telekasten<CR>
nnoremap <silent> <leader>b :Git blame<Cr>

" search for visually selected text  (visual selection -> Search)
vnoremap <silent> <leader>z y/\V<C-R>=escape(@",'/\')<CR><CR>
vnoremap <silent> <leader>s y:Ag <C-R>=escape(@",'/\')<CR>


" rename in buffer
nmap <leader>r :%s///g<left><left>
" TODO - fix these 
nmap <silent> <leader>t :execute 'SearchFiles "'.<SID>related_test().'"'<CR>
nmap <silent> <leader>f :let f=expand("<cfile>")<cr> :execute("SearchFiles ".f)<CR>


" Harpoon
nnoremap  <leader>a :lua require("harpoon.mark").add_file()<Cr>
nnoremap  <leader>s :lua require("harpoon.ui").toggle_quick_menu()<CR>
" alt-1,2,3 switches between 3 working files
nnoremap <m-1> :lua require("harpoon.ui").nav_file(1)<CR>
nnoremap <m-2> :lua require("harpoon.ui").nav_file(2)<CR>
nnoremap <m-3> :lua require("harpoon.ui").nav_file(3)<CR>


" Other misc mappings --
" keep cursor in centre
nnoremap N Nzz
nnoremap n nzz

nnoremap j jzz
nnoremap k kzz

nnoremap <C-n> :call NumberToggle()<cr>
noremap <C-_> :Commentary<CR>
nnoremap <silent> gq :Git<Cr>

nmap <F2> :Buffers<CR>
nmap <C-F2> :BufferDelete<CR>
nmap <F3> :Files<CR>
nmap <C-t> :Telescope<CR>

"
"  Search files: --
nmap <leader>1 :Ag<CR> 
nmap <leader>2 :AgPySearch<CR>
nmap <leader>3 :AgRmlSearch<CR>
nmap <leader>4 :AgHtmlSearch<CR>
nmap <leader>5 :AgLispSearch<CR>
nmap <leader>6 :AgFennelSearch<CR>

nmap <F5>1 :Ag <C-r><C-w><CR> 
nmap <F5>2 :AgPySearch <C-r><C-w><CR>
nmap <F5>3 :AgRmlSearch <C-r><C-w><CR>
nmap <F5>4 :AgHtmlSearch <C-r><C-w><CR>
nmap <F5>5 :AgLispSearch <C-r><C-w><CR>
nmap <F5>6 :AgFennelSearch <C-r><C-w><CR>

" F6 - search for word under cursor
nmap <F6> :Ag <C-r><C-w><CR>
" search for word under cursor in RML
"nmap <F6><F5> :AgRmlSearch <C-r><C-w><CR>

nmap <F8> :let $VIM_DIR=expand('%:p:h')<CR>:vsplit +terminal<CR>Acd $VIM_DIR<CR>clear<CR>
tmap <c-space> <C-\><c-n>

nnoremap <silent> <expr> <F7> &filetype == 'netrw' ? ':Rexplore<CR>' : ':Explore<CR>'
nmap <C-H> :History<CR>
nmap <F9> :SearchFiles expand('%:t')<CR>
nmap c= $T=C
nmap <F9> :SearchFiles expand('%:t')<CR>


command! -nargs=* SearchFiles call fzf#vim#files('.', {'options':'--query <args>'})
command! -nargs=* SearchInterfaces call fzf#vim#files('src/octoenergy/interfaces', {'options':'--query <args>'})
command! -nargs=* SearchDomain call fzf#vim#files('src/octoenergy/domain', {'options':'--query <args>'})

function! s:related_test()
    " this will get 'context.py' from 'test_context.py'
    " and 'test_context.py' from 'context.py'
    " with the filepath extended out
    let l:filename = expand('%:t')
    if l:filename =~ 'test'
        let l:searchfile = substitute(l:filename,'^test_','','')
    else
        let l:searchfile = 'test_' . l:filename
    endif

    return join(split(expand('%:h'),'/')[3:],' ') . ' ' . l:searchfile
endfunction

command! -bang -nargs=* AgPySearch call fzf#vim#ag(<q-args>, '--ignore=tests --ignore=migrations --python ', fzf#vim#with_preview({'options':'--prompt "(py-no-tests)? "'}), <bang>0)
command! -bang -nargs=* AgRmlSearch call fzf#vim#ag(<q-args>, '--ignore=tests -G "\.rml$" ', fzf#vim#with_preview({'options':'--prompt "(rml)? "'}), <bang>0)
command! -bang -nargs=* AgHtmlSearch call fzf#vim#ag(<q-args>, '--ignore=tests -G "\.html$" ', fzf#vim#with_preview({'options':'--prompt "(html)? "'}), <bang>0)
command! -bang -nargs=* AgLispSearch call fzf#vim#ag(<q-args>, '--ignore=tests -G "\.lisp$" ', fzf#vim#with_preview({'options':'--prompt "(lisp)? "'}), <bang>0)
command! -bang -nargs=* AgFennelSearch call fzf#vim#ag(<q-args>, '--ignore=tests -G "\.fnl$" ', fzf#vim#with_preview({'options':'--prompt "(fnl)? "'}), <bang>0)
command! -bang -nargs=* EditConfigs call fzf#vim#files('~/.config/nvim/', fzf#vim#with_preview({'options':'--prompt "edit config: " '}),<bang>0)


function! NumberToggle()
	if(&relativenumber == 1)
        set norelativenumber
	else
		set relativenumber
	endif
endfunc


" ==============================================================================
function SetMarkdownOptions()
    set wrap
    set spell
endfunction

function SetPythonOptions()
    let b:ale_fixers = ['black', 'isort']
    let b:ale_fix_on_save = 1
endfunction
" ------------ Configurations 
"

let g:vimwiki_list = [{'path': '~/vimwiki/', 'syntax': 'markdown', 'ext': '.md'}]
let g:SuperTabDefaultCompletionType = "<c-n>" "change completions to be top to bot.
let g:tagbar_width = max([50, winwidth(0) / 3])
let g:slime_target = "tmux"
let g:slime_default_config = {"socket_name": "default", "target_pane": "{last}"}
let g:slime_dont_ask_default = 1
let g:slime_python_ipython = 1
" set statusline=%<%F\ %h%m%r%=%{tagbar#currenttag('%s\ ','','f')}%-.(%l,%c%V%)\ %P
set statusline=%<%F\ %h%m%r%=%{nvim_treesitter#statusline()}%-.(%l,%c%V%)\ %P
" set statusline=%<%F\ %h%m%r%=%{lua require('nvim-treesitter).statusline()}%-.(%l,%c%V%)\ %P
let g:netrw_liststyle=3     " Tree mode view
let g:netrw_browse_split=0  " Open file in previous buffer
let g:netrw_winsize=10      " Make netrw window smaller
let g:markdown_fenced_languages = ['html', 'python', 'bash=sh']
let g:markdown_syntax_conceal = 0
let g:markdown_minlines = 100
let g:pyindent_continue = 4
let g:pyindent_open_paren = 4
let g:fzf_preview_window = ['right:60%', 'ctrl-/']
let g:python_recommended_style = 0
colorscheme molokai
if has("nvim-0.5.0")
    set signcolumn=number
endif
set timeoutlen=500
au FileType python call SetPythonOptions() 
au FileType vimwiki call SetMarkdownOptions() 
au FileType json let conceallevel=0                     "Don't hide json quotes
filetype plugin indent on
" syntax enable
set mouse=a
set background=dark
set tabstop=4 
set expandtab
set shiftwidth=4
set softtabstop=4
set wrap!
set linebreak
set cursorline
set noshowcmd
set noshowmode
set number
set relativenumber
" backspace over tabs
set backspace=indent,eol,start
set hlsearch 
set incsearch 
set showmatch
set ignorecase
set smartcase
set shellslash
set vb
set backspace=2
set hidden
set nopaste
set laststatus=2
set pastetoggle=<F2>
set scrolloff=0  " how far can the cursor be from the edge? 999 - always in middle
set fillchars=""
set autoindent
set nobackup
set noswapfile
set spelllang=en_au
map <up> <nop>
map <down> <nop>
map <left> <nop>
map <right> <nop>

augroup YankHighlight
autocmd!
autocmd TextYankPost * silent! lua vim.highlight.on_yank()
augroup end

lua << EOF
require "config"
EOF
