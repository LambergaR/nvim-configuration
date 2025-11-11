-- lua/keymaps.lua
local tb = require("telescope.builtin")

vim.keymap.set("n","<leader>ff", tb.find_files, {desc="Files"})
vim.keymap.set("n","<leader>fg", tb.live_grep,  {desc="Ripgrep"})
vim.keymap.set("n","<leader>fb", tb.buffers,    {desc="Buffers"})
vim.keymap.set("n","<leader>fh", tb.help_tags,  {desc="Help"})

vim.keymap.set("n","<leader>e", "<cmd>Neotree toggle<cr>", {desc="Explorer"})
vim.keymap.set("n","<leader>t", "<cmd>ToggleTerm<cr>", {desc="Terminal"})
vim.keymap.set("n","<leader>xx","<cmd>Trouble diagnostics toggle<cr>",{desc="Diagnostics"})
