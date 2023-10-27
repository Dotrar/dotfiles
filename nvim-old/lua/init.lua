local _2afile_2a = "/home/dre/.config/nvim/fnl/init.fnl"
local _2amodule_name_2a = "nvim-config"
local _2amodule_2a
do
  package.loaded[_2amodule_name_2a] = {}
  _2amodule_2a = package.loaded[_2amodule_name_2a]
end
local _2amodule_locals_2a
do
  _2amodule_2a["aniseed/locals"] = {}
  _2amodule_locals_2a = (_2amodule_2a)["aniseed/locals"]
end
local autoload = (require("aniseed.autoload")).autoload
local H, Popup, Shade, Split, TS, Telescope, a, autocmd, str = autoload("helpers"), autoload("nui.popup"), autoload("shade"), autoload("nui.split"), autoload("nvim-treesitter"), autoload("telescope.builtin"), autoload("aniseed.core"), autoload("nui.utils.autocmd"), autoload("aniseed.string")
do end (_2amodule_locals_2a)["H"] = H
_2amodule_locals_2a["Popup"] = Popup
_2amodule_locals_2a["Shade"] = Shade
_2amodule_locals_2a["Split"] = Split
_2amodule_locals_2a["TS"] = TS
_2amodule_locals_2a["Telescope"] = Telescope
_2amodule_locals_2a["a"] = a
_2amodule_locals_2a["autocmd"] = autocmd
_2amodule_locals_2a["str"] = str
local function leadermap(key, rhs_or_func)
  return vim.keymap.set("n", ("<leader>" .. key), rhs_or_func)
end
_2amodule_2a["leadermap"] = leadermap
leadermap("<space>", Telescope.buffers)
local function _1_()
  return Telescope.find_files({previewer = false})
end
leadermap("sf", _1_)
leadermap("sb", Telescope.current_buffer_fuzzy_find)
leadermap("sh", Telescope.help_tags)
leadermap("sd", Telescope.grep_string)
leadermap("sp", Telescope.live_grep)
leadermap("sl", Telescope.lsp_workspace_symbols)
Shade.setup({overlay_opacity = 30, keys = {brightness_up = "<C-Up>", brightness_down = "<C-Down>"}})
local function vmap(key, rhs)
  return vim.keymap.set("v", key, rhs)
end
_2amodule_2a["vmap"] = vmap
local function get_visual_selection()
  local v = vim.fn.line("v")
  local c = vim.fn.line(".")
  local upper = math.min(v, c)
  local lower = math.max(v, c)
  if ("V" == vim.api.nvim_get_mode().mode) then
    return vim.api.nvim_buf_get_lines(0, (upper - 1), lower, false)
  else
    return nil
  end
end
_2amodule_2a["get-visual-selection"] = get_visual_selection
local function count_starting_spaces(lines)
  local tbl_15_auto = {}
  local i_16_auto = #tbl_15_auto
  for _, line in ipairs(lines) do
    local val_17_auto
    do
      local idx, count = string.find(line, "^%s*")
      if (idx == 1) then
        val_17_auto = count
      else
        val_17_auto = nil
      end
    end
    if (nil ~= val_17_auto) then
      i_16_auto = (i_16_auto + 1)
      do end (tbl_15_auto)[i_16_auto] = val_17_auto
    else
    end
  end
  return tbl_15_auto
end
_2amodule_2a["count-starting-spaces"] = count_starting_spaces
local function unindent(lines)
  local x = math.min(unpack(count_starting_spaces(lines)))
  if (x > 0) then
    local tbl_15_auto = {}
    local i_16_auto = #tbl_15_auto
    for _, line in ipairs(lines) do
      local val_17_auto = string.sub(line, (x + 1))
      if (nil ~= val_17_auto) then
        i_16_auto = (i_16_auto + 1)
        do end (tbl_15_auto)[i_16_auto] = val_17_auto
      else
      end
    end
    return tbl_15_auto
  else
    return lines
  end
end
_2amodule_2a["unindent"] = unindent
local function send_tmux_command(args)
  return vim.fn.system(("tmux -L default " .. args))
end
_2amodule_2a["send-tmux-command"] = send_tmux_command
local function write_to_file(lines)
  table.insert(lines, "")
  return vim.fn.system("cat > ~/.tmp_slime", lines)
end
_2amodule_2a["write-to-file"] = write_to_file
local function send_to_tmux(lines)
  write_to_file(lines)
  send_tmux_command("load-buffer ~/.tmp_slime")
  send_tmux_command("paste-buffer -d -p -t {last}")
  return send_tmux_command("last-pane")
end
_2amodule_2a["send-to-tmux"] = send_to_tmux
local function _7_()
  return send_to_tmux(unindent(get_visual_selection()))
end
vmap("<c-c><c-c>", _7_)
local function kraken_keymap(key, rhs_or_command)
  return vim.keymap.set("n", ("<leader>k" .. key), rhs_or_command)
end
_2amodule_2a["kraken-keymap"] = kraken_keymap
local function _8_()
  return print("lua commandx")
end
kraken_keymap("x", _8_)
kraken_keymap("y", ":echo 'vim commandy'<CR>")
kraken_keymap("e", ":e ~/.config/nvim/fnl/init.fnl<CR>")
vim.keymap.set("n", "<C-C>", ":vs<cr>")
local function get_filename()
  return vim.fn.expand("%")
end
_2amodule_2a["get-filename"] = get_filename
local function make_matching(filename)
  return "assuming we're given an octoenergy filepath, generate needed filepath alternatives"
end
_2amodule_2a["make-matching"] = make_matching
make_matching("src/octoenergy/plugins/territories/aus/billing/elec_charging_calculator/_consumption.py")
make_matching("/home/dre/init")
local function pop(contents, close_callback)
  local p = Popup({enter = true, focusable = true, border = {style = "rounded"}, position = "50%", size = {width = "50%", height = "30%"}, buf_options = {modifiable = true, readonly = false}})
  p:mount()
  local function _9_()
    local function _10_()
      return print("Hello!!~~")
    end
    return vim.keymap.set("n", "t", _10_)
  end
  p:on(autocmd.event.BufEnter, _9_)
  local function _11_()
    close_callback()
    return p:unmount()
  end
  p:on(autocmd.event.BufLeave, _11_)
  return vim.api.nvim_buf_set_lines(p.bufnr, 0, 1, false, contents)
end
local function split(contents, callback)
  local s = Split({relative = "editor", position = "bottom", size = "20%"})
  s:mount()
  local function _12_()
    callback()
    return s:unmount()
  end
  s:on(autocmd.event.BufLeave, _12_)
  return vim.api.nvim_buf_set_lines(s.bufnr, 0, 1, false, contents)
end
local function find_related_files(filename)
  return "Find the related files to a "
end
_2amodule_2a["find-related-files"] = find_related_files
return _2amodule_2a