-- Leaderkey file
--
-- This file is loaded (roughly first) in the vim configuration
-- it is done so that the leader key can be replaced before plugins are loaded
-- note that because there is no plugins, there's not a lot you can `require` here.
-- so be mindful.

--Remap space as leader key
vim.api.nvim_set_keymap("", "<Space>", "<Nop>", { noremap = true, silent = true })
vim.g.mapleader = " "
vim.g.maplocalleader = " "
