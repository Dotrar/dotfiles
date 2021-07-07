# dotfiles
Dotfile collection and current settings

Currently there are 3 settings that I use

## Gitconfig

* Commit template (as a reminder)
* Global gitignore, which allows you to gitignore without changing the repo
* `lg` alias that offers short version of the last 7 commits. run `git lg`

## NVIM Configuration file

My main NVIM config file at the moment. Uses [vim-plug](https://github.com/junegunn/vim-plug) as a plugin manager.

Uses `FZF` to great effect, and some Coc-Jedi. Main point of note is the keybindings.

Currently I'm working on a keybinding `c=` so that I can change "anything from the equal sign onwards" - if you've got better ideas or keybindings compared to what I'm doing feel free to let me know
| Key | Does | 
| --- | --- |
| `<F1>` | Git status in fugitive. very worthwhile addon
| `<F2>` | switch to buffer fzf
| `<C-F2>` | delete buffer fzf
| `<F3>` | browse filepath fzf
| `<F4>` | Ag search in filepath
| `<F5>` | "where is the function I'm in being used" ? Used to go "up" the call-stack.
| `<F6>` | Ag for term under cursor
| `<F7>` | Files near me, runs `:Explore` 
| `<F8>` | Tagbar toggle, which is good for file overview of symbols
| `<C-F8>` | Coc alternative
| `<C-H>` | History browser, uses this quite a lot
| `<F9>` | Search for files with a similar name to the file im editing
| `<lead>t` | Seach for files with related tests and in a similar directory for what I'm editing
| `<lead>d` | Go to definition of this function
| `<lead>v` | Open the definition of this function in a split
| `<lead>\` | Coc Diagnostics
| `<laed>]` | Jump to next Coc Diagnostic
| `c=` | Change from `=` onwards. (or change what I'm assigning the variable to) 
| `<C-/>` | Comment/Uncomment code 
| `<C-n>` | Change between cursor relative number and normal number


## TMUX config file

Simple things because I'm still learning how to use it.

* `Ctrl-A` is the key now 
* `|` and `-` for vertical/horizontal split
* nice statusbar up top.
* right click menu
* Still trying to get used to copy-pasting here, if someone has a resource let me know.
