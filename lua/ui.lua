-- lua/ui.lua
vim.o.background = "dark"

-- pick one; oxocarbon by default
pcall(vim.cmd.colorscheme, "oxocarbon")
-- pcall(vim.cmd.colorscheme, "carbonfox")

require("lualine").setup({ options = { theme = "auto" } })

require("telescope").setup({})
pcall(require("telescope").load_extension, "fzf")
