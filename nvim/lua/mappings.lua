require "nvchad.mappings"
local map = vim.keymap.set


map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

-- shift between tabs
map("n", "K", function()
  require("nvchad.tabufline").next()
end, { desc = "buffer goto next" })

-- shift between tabs
map("n", "J", function()
  require("nvchad.tabufline").prev()
end, { desc = "buffer goto prev" })

-- go to last file that i was editing
vim.keymap.set('n', 'O', '<C-^>', { noremap = true, silent = true })

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")

-- dd, d, x, s → delete without yanking
vim.keymap.set({ "n", "v" }, "x", '"_x', { noremap = true })
vim.keymap.set("n", "s", '"_s', { noremap = true })
vim.keymap.set({ "n", "v" }, "c", '"_c', { noremap = true })

vim.keymap.set("n", "<leader>gp", function() require('gitsigns').preview_hunk() end, { desc = "Preview Hunk" })
vim.keymap.set("n", "<leader>gs", function() require('gitsigns').stage_hunk() end, { desc = "Stage Hunk" })
vim.keymap.set("n", "<leader>gu", function() require('gitsigns').undo_stage_hunk() end, { desc = "Undo Stage Hunk" })
vim.keymap.set("n", "<leader>gr", function() require('gitsigns').reset_hunk() end, { desc = "Reset Hunk" })
vim.keymap.set("n", "<leader>gb", function() require('gitsigns').blame_line() end, { desc = "Blame Line" })
vim.keymap.set("n", "<leader>gd", function() require('gitsigns').diffthis('~1') end, { desc = "Diff This" })
vim.keymap.set("n", "<leader>gn", function() require('gitsigns').next_hunk() end, { desc = "Next Hunk" })
vim.keymap.set("n", "<leader>gN", function() require('gitsigns').prev_hunk() end, { desc = "Previous Hunk" })
