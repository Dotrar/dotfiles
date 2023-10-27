-- fzf
local fzf = require 'fzf-lua'

local find_test_flies = function()
    if (vim.fn.expand("%:e") ~= "py") then
        print("Not a python file")
        return
    end
    -- local filepath,_ = string.gsub(vim.fn.expand("%:p"),"/home/dre/%a+/%a+/","")

    local filepath, _ = string.gsub(
        vim.fn.expand("%:p"),
        vim.fn.getcwd(),
        "")

    -- add "test_" to the python file
    filepath, _ = string.gsub(
        filepath,
        "/(%a*).py",
        "/test_%1.py")

    search_name, _ = string.gsub(filepath, ".*/(test_%a*.py)", "%1")

    -- fuzzy find that new path
    filepath, _ = string.gsub(
        filepath,
        "/",
        " ")

    fzf.files {
        fd_opts = filepath,
        prompt = "Find test files " .. search_name,
    }
end

return {
    find_test_flies = find_test_flies
}
