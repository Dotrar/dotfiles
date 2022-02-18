# dotfiles

Dotfile collection and current settings



## Neovim

Slowly converting to fennel, to use the <https://fennel-lang.org> programming language

Plugins are commented in `nvim/init.vim`


### Misc helpful keymaps

```vim
" what is the file path
nnoremap <silent> <leader>w :echo(expand('%'))<CR>

" F6 - search for word under cursor (using :Ag)
nmap <F6> :Ag <C-r><C-w><CR>

" c= - change from equal onwards
nmap c= $T=C

" rename hlsearch'd term in buffer (combine with #)
nmap <leader>r :%s///g<left><left>


" F8 - open terminal in directory of file
" bind <control-space> as the terminal buffer escape-key
nmap <F8> :let $VIM_DIR=expand('%:p:h')<CR>:vsplit +terminal<CR>Acd $VIM_DIR<CR>clear<CR>
tmap <c-space> <C-\><c-n>
```

### Fugitive

very useful plugin. keybindings:

```vim
nnoremap <silent> <leader>q :vertical Git log ...master --name-status<CR>
nnoremap <silent> <leader>b :Git blame<Cr>

" open this line in github (needs vim-rhubarb ) 
nnoremap <silent> <leader>o :.GBrowse master:%<CR>

nnoremap <silent> gq :Git<Cr>
```

### FZF 

Easy searches but progressively (begrudgingly) going towards Telescope

```vim
command! -bang -nargs=* AgPySearch call fzf#vim#ag(<q-args>, '--ignore=tests --ignore=migrations --python ', fzf#vim#with_preview({'options':'--prompt "(py-no-tests)? "'}), <bang>0)
command! -bang -nargs=* AgRmlSearch call fzf#vim#ag(<q-args>, '--ignore=tests -G "\.rml$" ', fzf#vim#with_preview({'options':'--prompt "(rml)? "'}), <bang>0)
command! -bang -nargs=* AgHtmlSearch call fzf#vim#ag(<q-args>, '--ignore=tests -G "\.html$" ', fzf#vim#with_preview({'options':'--prompt "(html)? "'}), <bang>0)
command! -bang -nargs=* AgLispSearch call fzf#vim#ag(<q-args>, '--ignore=tests -G "\.lisp$" ', fzf#vim#with_preview({'options':'--prompt "(lisp)? "'}), <bang>0)
command! -bang -nargs=* AgFennelSearch call fzf#vim#ag(<q-args>, '--ignore=tests -G "\.fnl$" ', fzf#vim#with_preview({'options':'--prompt "(fnl)? "'}), <bang>0)
command! -bang -nargs=* EditConfigs call fzf#vim#files('~/.config/nvim/', fzf#vim#with_preview({'options':'--prompt "edit config: " '}),<bang>0)

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
```

Also have "search for files with the name under the cursor" as a more flexible version of `gf`

```vim
nmap <silent> <leader>t :execute 'SearchFiles "'.<SID>related_test().'"'<CR>
nmap <silent> <leader>f :let f=expand("<cfile>")<cr> :execute("SearchFiles ".f)<CR>


command! -nargs=* SearchFiles call fzf#vim#files('.', {'options':'--query <args>'})

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

```

### Harpoon ( still trying to use) 

```vim
" Harpoon
nnoremap  <leader>a :lua require("harpoon.mark").add_file()<Cr>
nnoremap  <leader>s :lua require("harpoon.ui").toggle_quick_menu()<CR>
" alt-1,2,3 switches between 3 working files
nnoremap <m-1> :lua require("harpoon.ui").nav_file(1)<CR>
nnoremap <m-2> :lua require("harpoon.ui").nav_file(2)<CR>
nnoremap <m-3> :lua require("harpoon.ui").nav_file(3)<CR>


```
## Fennel

fennel is always in a play around state; I get to work on my editor while working, and with conjure - evaluate it on the fly. 

check out `nvim/fnl` to see the code, this is my "copy text over to tmux" config but only in 40 lines.




