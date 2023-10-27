local shell_cmd = function(cmd)
    return vim.fn.system(cmd)
end

local strip_str = function(s)
    local ret, _ = string.gsub(s, "%s", "")
    return ret
end

local get_main_branch = function()
    return strip_str(
        shell_cmd(
            "basename " .. shell_cmd("git symbolic-ref refs/remotes/origin/HEAD")
        ))
end


local get_user_repo = function()
    -- TODO make this agnostic of repo, i use this for work
    return "octoenergy/kraken-core"
end

return {
    git_status = function() vim.cmd('Git') end,
    git_log = function()
        local branch = get_main_branch()
        vim.cmd(string.format(
            "vertical Git log ...%s --name-status",
            branch))
    end,
    open_in_github = function()
        local filepath = vim.fn.expand("%")
        local cwd = vim.fn.getcwd() or ""
        filepath = string.gsub(filepath, cwd, "")
        local ln = vim.api.nvim_win_get_cursor(0)[1]
        local branch = get_main_branch()
        local repo = get_user_repo()

        vim.cmd(string.format(
            ":!xdg-open https://github.com/%s/blob/%s/%s\\#L%s",
            repo,
            branch,
            filepath,
            ln))
    end,
}
