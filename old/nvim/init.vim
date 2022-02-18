filetype off
set nocompatible
"
" -------------------
" Dre's Neovim config
" ===================

" Leader
let mapleader = ','
let maplocalleader = ','

" Colours
set termguicolors

" neovim-plug Plugins -----------------
call plug#begin(stdpath('data') . '/plugged')

    " Highly recommended 
    Plug 'jpalardy/vim-slime'           "Interact with REPL (ipython, sbcl)
    Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
    Plug 'junegunn/fzf.vim'             "Common bindings for fzf and vim
    Plug 'tpope/vim-fugitive'           "Git bindings and commands
    Plug 'tpope/vim-rhubarb'            "allows 'open in github'
    " Plug 'ervandew/supertab'            "allows a lot of tab completions
    Plug 'Galicarnax/vim-regex-syntax'  "highlights regex in vim
    Plug 'tpope/vim-commentary'         "allow 'toggle comment line'
    Plug 'kshenoy/vim-signature'        "show marks in the number column
    Plug 'fatih/molokai'                "Colourscheme
    Plug 'tpope/vim-markdown'           "Markdown filetype
    Plug 'tbastos/vim-lua'              "Lua filetype

    Plug 'jose-elias-alvarez/null-ls.nvim'

    Plug 'ferrine/md-img-paste.vim'     "paste images into markdown buffer

    Plug 'tpope/vim-unimpaired'

    Plug 'ThePrimeagen/harpoon' 
    Plug 'nvim-telescope/telescope-frecency.nvim' " sort files by frecency
    Plug 'tami5/sqlite.lua'

    Plug 'rafcamlet/nvim-luapad'

    " Conjure 
    Plug 'Olical/conjure'
    Plug 'Olical/aniseed'
    Plug 'Olical/nvim-local-fennel'

    " New plugins I haven't yet dealt with (replaces FZF)
    Plug 'nvim-lua/popup.nvim'
    Plug 'nvim-lua/plenary.nvim'
    Plug 'nvim-telescope/telescope.nvim'

    Plug 'cespare/vim-toml'

    " Python specific plugins for navigation
    " Plug 'neoclide/coc.nvim', {'branch': 'release', 'do' : ':CocInstall coc-jedi'}
    Plug 'numirias/semshi', {'do': ':UpdateRemotePlugins'}
    " Plug 'preservim/tagbar'
    " Plug 'xolox/vim-easytags'
    " Plug 'xolox/vim-misc'
    Plug 'dense-analysis/ale'


    " LUA  for writing plugins
    Plug 'tjdevries/nlua.nvim'
    Plug 'neovim/nvim-lspconfig'
    Plug 'nvim-lua/completion-nvim'
    Plug 'euclidianAce/BetterLua.vim'
    Plug 'tjdevries/manillua.nvim'

    Plug 'hrsh7th/cmp-nvim-lsp'
    Plug 'hrsh7th/cmp-buffer'
    Plug 'hrsh7th/cmp-path'
    Plug 'hrsh7th/cmp-cmdline'
    Plug 'hrsh7th/nvim-cmp'
    Plug 'L3MON4D3/LuaSnip'
    Plug 'saadparwaiz1/cmp_luasnip'
    Plug 'onsails/lspkind-nvim'

call plug#end() 

lua << EOF

-- LSP configuration
require "dotrar.lspconfig"
-- autocompletions 
require "dotrar.cmp"

require('telescope').setup({
    global_settings = {
        save_on_toggle = true,
        }
})
require('telescope').load_extension('frecency')

EOF

"
" Setup whichkey below:
" call which_key#register(',', "g:which_key_map")
" nnoremap <silent> <leader> :<c-u>WhichKey  ','<CR>
" vnoremap <silent> <leader> :<c-u>WhichKeyVisual ','<CR>

" --------------------- Key mappings with descriptions
"
" Leader mappings - shown by whichkey
nnoremap <silent> <leader>/ :nohlsearch<CR>
nnoremap <silent> <leader>p :set invpaste<CR>:set paste?<CR>
nnoremap <silent> <leader>q :vertical Git log -10 --name-status<CR>
nnoremap <silent> <leader>o :.GBrowse master:%<CR>
nnoremap <silent> <leader>l :Lines<Cr>

" Harpoon
nnoremap  <leader>a :lua require("harpoon.mark").add_file()<Cr>
nnoremap  <leader>s :lua require("harpoon.ui").toggle_quick_menu()<CR>
nnoremap <m-1> :lua require("harpoon.ui").nav_file(1)<CR>
nnoremap <m-2> :lua require("harpoon.ui").nav_file(2)<CR>
nnoremap <m-3> :lua require("harpoon.ui").nav_file(3)<CR>

" search for highlighted text in visual mode
vnoremap <silent> <leader>s y/\V<C-R>=escape(@",'/\')<CR><CR>

nmap <leader>r :%s///g<left><left>
nmap <leader>t :execute 'SearchFiles "'.<SID>related_test().'"'<CR>
nmap <leader>f :let f=expand("<cfile>")<cr> :execute("SearchFiles ".f)<CR>
nmap <leader>w :echo(expand('%'))<CR>

" go to definition of function, ( go down call stack ) 
nmap <leader>d :ALEGoToDefinition<CR>
" open up definition of function in a vsplit 
nmap <leader>v :vsp<CR><Plug>(coc-definition)<C-w>j

nmap <leader>] <Plug>(coc-diagnostic-next)
nmap <leader>\ :<C-u>CocList diagnostics<cr>

" let g:which_key_map = {
" \ '/' : 'Hide highlight search',
" \ 'q' : 'Git Log',
" \ 'o' : 'Open in Github master',
" \ 'l' : 'Lines FZF',
" \ 's' : 'Search for highlighted text',
" \ 'w' : 'Where am I? ',
" \}

" Other misc mappings --
" keep cursor in centre
nnoremap j jzz
nnoremap k kzz
nnoremap <C-n> :call NumberToggle()<cr>
noremap <C-_> :Commentary<CR>
nnoremap <silent> gq :Git<Cr>
nmap <F2> :Buffers<CR>
nmap <C-F2> :BufferDelete<CR>
nmap <F3> :Files<CR>
nmap <C-t> :Telescope<CR>
"  Search files:
nmap <F4> :AgPySearch<CR>
nmap <S-F4> :AgRmlSearch<CR>
nmap <C-F4> :Ag<CR> 

nmap <F5> ?\C\<def\><CR>w:Ag (?<!def )(?<!_)<C-r><C-w><CR>
nmap <F6> :Ag <C-r><C-w><CR>
nnoremap <silent> <expr> <F7> &filetype == 'netrw' ? ':Rexplore<CR>' : ':Explore<CR>'
nmap <F8> :TagbarToggle<CR>
nmap <C-F8> :CocList outline<CR>:
nmap <C-H> :Telescope frecency<CR>
nmap <F9> :SearchFiles expand('%:t')<CR>
nmap c= $T=C
nmap <F9> :SearchFiles expand('%:t')<CR>
nnoremap <silent> <C-W>z :ZoomToggle<CR>

" --------------------- Custom Functions
"
" Zoom / Restore window.
function! s:ZoomToggle() 
    if exists('t:zoomed') && t:zoomed
        execute t:zoom_winrestcmd
        let t:zoomed = 0
    else
        let t:zoom_winrestcmd = winrestcmd()
        resize
        vertical resize
        let t:zoomed = 1
    endif
endfunction
command! ZoomToggle call s:ZoomToggle()

command! -nargs=1 SearchFiles call fzf#vim#files('.', {'options':'--query <args>'})
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

command! -bang -nargs=* AgPySearch call fzf#vim#ag(<q-args>, '--ignore=tests --ignore=migrations --python ', fzf#vim#with_preview({'options':'--prompt "(py)? "'}), <bang>0)
command! -bang -nargs=* AgRmlSearch call fzf#vim#ag(<q-args>, '--ignore=tests -G "\.rml$" ', fzf#vim#with_preview({'options':'--prompt "(rml)? "'}), <bang>0)

function! s:list_buffers()
  redir => list
  silent ls
  redir END
  return split(list, "\n")
endfunction

function! s:delete_buffers(lines)
  execute 'bwipeout!' join(map(a:lines, {_, line -> split(line)[0]}))
endfunction

command! BufferDelete call fzf#run(fzf#wrap({
  \ 'source': s:list_buffers(),
  \ 'sink*': { lines -> s:delete_buffers(lines) },
  \ 'options': '--multi --reverse --bind ctrl-a:select-all+accept'
\ }))

function! NumberToggle()
	if(&relativenumber == 1)
        set norelativenumber
	else
		set relativenumber
	endif
endfunc

" ==============================================================================

function SetPythonOptions()
    let b:ale_fixers = ['black', 'isort']
    let b:ale_fix_on_save = 1
endfunction
" ------------ Configurations 
"
let g:SuperTabDefaultCompletionType = "<c-n>" "change completions to be top to bot.
let g:tagbar_width = max([50, winwidth(0) / 3])
let g:slime_target = "tmux"
let g:slime_default_config = {"socket_name": "default", "target_pane": "{last}"}
" set statusline=%<%F\ %h%m%r%=%{tagbar#currenttag('%s\ ','','f')}%-.(%l,%c%V%)\ %P
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
autocmd! BufRead,BufNewFile *.rml set filetype=xml      "Set XML type for RML files we use
set timeoutlen=500
" au BufReadPost */tickets/* call SetMarkdownOptions()
au FileType python call SetPythonOptions() 
au FileType json let conceallevel=0                     "Don't hide json quotes
filetype plugin indent on
syntax enable
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
set scrolloff=0                                         " how far can the cursor be from the edge? 999 - always in middle
set fillchars=""
set autoindent
set nobackup
set noswapfile
map <up> <nop>
map <down> <nop>
map <left> <nop>
map <right> <nop>
