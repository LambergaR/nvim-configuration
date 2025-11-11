-- lua/treesitter.lua
require("nvim-treesitter.configs").setup({
  ensure_installed = {
    "bash","python","lua","json","yaml","markdown",
    "dockerfile","hcl","terraform","helm","nginx"
  },
  highlight = { enable = true },
  indent = { enable = true },
})
