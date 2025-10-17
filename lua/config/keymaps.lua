-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
--
-- :e ++enc=cp1251
local map = LazyVim.safe_keymap_set
map("n", "<leader>fw", "<cmd>e ++enc=cp1251<cr>", { desc = "Buffer enc windows 1251" })
