-- nvim helper functions
return {
  pcmd = function(cmd_str)
    local ok, _ = pcall(vim.cmd, cmd_str)
    if not ok then
      vim.notify("failed to run command: " .. cmd_str)
      return false
    end
    return true
  end,
}
