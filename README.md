# nvim-configuration

Modern, battery-included Neovim setup for macOS + Linux with a true-black theme and tooling for scripting + infra work (Bash, Python, Terraform/Helm, Docker, Nginx, YAML/JSON). Uses **lazy.nvim** as the plugin manager.

## What you get

- OLED-friendly black theme (Oxocarbon) with great plugin coverage
- Telescope + fzf-native, Neo-tree, ToggleTerm, Gitsigns, Trouble, which-key
- Treesitter for Bash/Python/Lua/JSON/YAML/Markdown/Dockerfile/HCL/Terraform/Helm/Nginx
- LSP via lspconfig + mason (bashls, basedpyright, ruff, terraformls, helm_ls, dockerls, yamlls, jsonls, optional nginx)
- Formatting with conform.nvim (black, shfmt, terraform_fmt, yamlfmt, jq, stylua, prettier)
- Optional extra linting with nvim-lint (shellcheck, yamllint)

## Quick start

The `scripts/install.sh` script is the fastest way to get started. It's designed to be idempotent (safe to re-run) and supports:

- **macOS** (via Homebrew)
- **Linux** (Debian/Ubuntu via `apt`, Fedora/CentOS/RHEL via `dnf`/`yum`, Arch via `pacman`)

It will:
1. Install OS-level dependencies (Neovim, Git, ripgrep, Python, etc.).
2. Symlink this repository to `~/.config/nvim`.
3. Offer to run a headless install of Treesitter parsers and Mason packages.

To run it:
```bash
# 1) Clone the repository to the standard Neovim config location
git clone https://github.com/LambergaR/nvim-configuration ~/.config/nvim

# 2) Run the installer
~/.config/nvim/scripts/install.sh

# 3) Start Neovim
# Plugins and tools will be bootstrapped on the first run.
nvim
```

### Common keymaps
- `<space>ff` files, `<space>fg` ripgrep, `<space>fb` buffers, `<space>fh` help
- `<space>e` file explorer (Neo-tree)
- `<space>t` ToggleTerm
- `gd/gr/K` LSP def/refs/hover, `<space>rn` rename
- `<space>xx` diagnostics list (Trouble)

### Remove or change the theme
Switch between `oxocarbon` and `carbonfox` by editing `lua/ui.lua` (see top section).

```
