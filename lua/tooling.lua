-- lua/tooling.lua
-- Formatting on save with Conform
require("conform").setup({
	notify_on_error = false,
	format_on_save = function(buf)
		return { timeout_ms = 1000, lsp_format = "fallback" }
	end,
	formatters_by_ft = {
		sh = { "shfmt" },
		bash = { "shfmt" },
		python = { "black" },
		terraform = { "terraform_fmt" },
		hcl = { "terraform_fmt" },
		json = { "jq" },
		yaml = { "yamlfmt" },
		dockerfile = { "dockfmt" },
		lua = { "stylua" },
		markdown = { "prettierd", "prettier" },
	},
})

-- Extra linting with nvim-lint
require("lint").linters_by_ft = {
	sh = { "shellcheck" },
	bash = { "shellcheck" },
	yaml = { "yamllint" },
}
vim.api.nvim_create_autocmd({ "BufWritePost" }, {
	callback = function()
		require("lint").try_lint()
	end,
})
