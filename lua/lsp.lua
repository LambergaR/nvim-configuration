-- lua/lsp.lua (Neovim 0.11+ style)

-- Completion capabilities (keep using cmp_nvim_lsp if you like)
local capabilities = require("cmp_nvim_lsp").default_capabilities()

-- Handy LSP keymaps
vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" })
vim.keymap.set("n", "gr", vim.lsp.buf.references, { desc = "References" })
vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Hover" })
vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { desc = "Rename" })

-- Define server configs
local servers = {
	bashls = {},
	basedpyright = { settings = { basedpyright = { typeCheckingMode = "standard" } } },
	ruff = {}, -- ruff_lsp in Mason, config name is "ruff"
	terraformls = {},
	helm_ls = {},
	dockerls = {},
	jsonls = {},
	yamlls = {
		settings = {
			yaml = {
				schemaStore = { enable = false, url = "" }, -- SchemaStore.nvim supplies schemas
				schemas = require("schemastore").yaml.schemas(),
				keyOrdering = false,
			},
		},
	},
	-- Optional/experimental:
	nginx_language_server = {},
}

-- Register configs with core LSP, then enable them
for name, cfg in pairs(servers) do
	cfg.capabilities = capabilities
	vim.lsp.config[name] = cfg
end
vim.lsp.enable(vim.tbl_keys(servers))
