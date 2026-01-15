-- init.lua
-- Bootstrap lazy.nvim, then load our modules

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({ "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim", lazypath })
end
vim.opt.rtp:prepend(lazypath)

-- Basics
vim.g.mapleader = " "
vim.o.termguicolors = true
vim.o.number = true
vim.o.relativenumber = true
vim.o.updatetime = 250

-- Load plugins from lua/plugins.lua
require("lazy").setup("plugins", { ui = { border = "rounded" } })

-- Load config modules
require("ui")
require("lsp")
require("tooling")
require("keymaps")
