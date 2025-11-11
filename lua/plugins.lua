-- lua/plugins.lua
return {
  -- Themes (true black)
  { "nyoom-engineering/oxocarbon.nvim", priority = 1000 },
  { "EdenEast/nightfox.nvim", priority = 1000 }, -- :colorscheme carbonfox

  -- Statusline & UX
  { "nvim-lualine/lualine.nvim" },
  { "folke/which-key.nvim", event = "VeryLazy", opts = {} },

  -- Files & terminal
  { "nvim-neo-tree/neo-tree.nvim", dependencies = { "nvim-lua/plenary.nvim", "nvim-tree/nvim-web-devicons", "MunifTanjim/nui.nvim" } },
  { "akinsho/toggleterm.nvim", version = "*", opts = {} },

  -- Finder
  { "nvim-telescope/telescope.nvim", dependencies = { "nvim-lua/plenary.nvim" } },
  { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },

  -- Git
  { "lewis6991/gitsigns.nvim", opts = {} },

  -- LSP + completion
  { "neovim/nvim-lspconfig" },
  { "mason-org/mason.nvim", build = ":MasonUpdate", opts = {} },
  { "mason-org/mason-lspconfig.nvim" },
  { "hrsh7th/nvim-cmp" },
  { "hrsh7th/cmp-nvim-lsp" },
  { "hrsh7th/cmp-buffer" },
  { "hrsh7th/cmp-path" },
  { "L3MON4D3/LuaSnip", version = "v2.*", build = "make install_jsregexp" },
  { "saadparwaiz1/cmp_luasnip" },

  -- Formatting & linting
  { "stevearc/conform.nvim" },
  { "mfussenegger/nvim-lint" },

  -- Syntax & structure
  { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
  { "nvim-treesitter/nvim-treesitter-context" },

  -- Diagnostics list / quickfix UX
  { "folke/trouble.nvim", opts = {} },

  -- JSON/YAML schemas
  { "b0o/SchemaStore.nvim" },

  -- Optional Nginx syntax (enable one in lsp.lua comments if preferred)
  -- { "chr4/nginx.vim" },
  -- { "spacewander/openresty-vim" },
}
