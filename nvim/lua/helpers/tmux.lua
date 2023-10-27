return {
  open_split = function()
    local dir = vim.fn.expand("%:p:h")
    if (os.getenv("TMUX")) then
      vim.cmd(string.format("silent !tmux split-window -h -c %s", dir))
    else
      vim.notify("not in TMUX")
    end
  end
}
