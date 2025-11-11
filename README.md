# nvim-devops-starter

Modern, battery-included Neovim setup for macOS + Linux with a true-black theme and tooling for scripting + infra work (Bash, Python, Terraform/Helm, Docker, Nginx, YAML/JSON). Uses **lazy.nvim** as the plugin manager.

## What you get
- OLED-friendly black theme (Oxocarbon) with great plugin coverage
- Telescope + fzf-native, Neo-tree, ToggleTerm, Gitsigns, Trouble, which-key
- Treesitter for Bash/Python/Lua/JSON/YAML/Markdown/Dockerfile/HCL/Terraform/Helm/Nginx
- LSP via lspconfig + mason (bashls, basedpyright, ruff, terraformls, helm_ls, dockerls, yamlls, jsonls, optional nginx)
- Formatting with conform.nvim (black, shfmt, terraform_fmt, yamlfmt, jq, stylua, prettier)
- Optional extra linting with nvim-lint (shellcheck, yamllint)

## Quick start
```bash
# 1) Clone to any folder, e.g.:
git clone https://github.com/<you>/nvim-devops-starter ~/.local/share/nvim-devops-starter
cd ~/.local/share/nvim-devops-starter

# 2) Install (symlinks to ~/.config/nvim and bootstraps lazy.nvim)
./scripts/install.sh

# 3) Start Neovim – plugins will install
nvim

### OS deps you’ll want
- ripgrep, git, build tools (for telescope-fzf-native)
- Python 3 (for black, ruff, etc.)

### Common keymaps
- `<space>ff` files, `<space>fg` ripgrep, `<space>fb` buffers, `<space>fh` help
- `<space>e` file explorer (Neo-tree)
- `<space>t` ToggleTerm
- `gd/gr/K` LSP def/refs/hover, `<space>rn` rename
- `<space>xx` diagnostics list (Trouble)

### Remove or change the theme
Switch between `oxocarbon` and `carbonfox` by editing `lua/ui.lua` (see top section).

