#!/usr/bin/env bash
set -euo pipefail

# Enhanced installer: macOS (Homebrew) & Linux (apt/dnf/yum/pacman)
# - Installs core deps (neovim, git, ripgrep, build tools, python, pipx)
# - Uses pipx for Python CLIs (avoids PEP 668 issues)
# - Ensures ~/.local/bin is on PATH (now and future)
# - Installs pynvim provider (Python) via pipx
# - Installs common formatters/linters (shellcheck, shfmt, stylua, jq, yamlfmt)
# - Symlinks repo to ~/.config/nvim
# - Optionally runs headless Treesitter update and Mason installs
#
# Idempotent: safe to re-run. No emojis.

log() { printf "\033[1;34m==>\033[0m %s\n" "$*"; }
warn() { printf "\033[1;33m[!]\033[0m %s\n" "$*"; }
die() {
	printf "\033[1;31m[✗]\033[0m %s\n" "$*"
	exit 1
}

# --- Detect OS ---
OS="unknown"
case "${OSTYPE:-}" in
darwin*) OS="macos" ;;
linux*) OS="linux" ;;
esac
log "Detected OS: $OS"

# --- Detect package manager ---
PKG_MGR=""
if command -v brew >/dev/null 2>&1; then PKG_MGR="brew"; fi
if [[ -z "$PKG_MGR" ]]; then
	if command -v pacman >/dev/null 2>&1; then PKG_MGR="pacman"; fi
	if command -v apt >/dev/null 2>&1; then PKG_MGR="apt"; fi
	if command -v dnf >/dev/null 2>&1; then PKG_MGR="dnf"; fi
	if command -v yum >/dev/null 2>&1; then PKG_MGR="yum"; fi
fi
[[ -z "$PKG_MGR" ]] && die "No supported package manager found (need brew/pacman/apt/dnf/yum)."
log "Using package manager: $PKG_MGR"

# --- macOS build tools hint (for native compiles like telescope-fzf-native) ---
if [[ "$OS" == "macos" ]] && ! xcode-select -p >/dev/null 2>&1; then
	warn "Xcode Command Line Tools not detected. If native plugin builds fail, run: xcode-select --install"
fi

# --- Install core deps ---
log "Installing core dependencies (neovim, git, ripgrep, build tools, python)..."
case "$PKG_MGR" in
brew)
	brew update
	brew install neovim git ripgrep make gcc python pipx || true
	;;
pacman)
	sudo pacman -Syu --noconfirm
	sudo pacman -S --noconfirm --needed neovim git curl ripgrep base-devel python python-pipx || true
	;;
apt)
	sudo apt update
	sudo apt install -y neovim git curl ripgrep build-essential python3 python-pipx stylua || true
	;;
dnf | yum)
	sudo $PKG_MGR install -y neovim git curl ripgrep make gcc python3 python3-pip || true
	# pipx fallback if not packaged
	if ! command -v pipx >/dev/null 2>&1; then python3 -m pip install --user pipx || true; fi
	;;
esac

# --- Ensure nvim is available ---
command -v nvim >/dev/null 2>&1 || die "Neovim not found on PATH after install."
log "Neovim version: $(nvim --version | head -n1)"

# --- pipx (avoid PEP 668) ---
if ! command -v pipx >/dev/null 2>&1; then
	if [[ "$PKG_MGR" == "brew" ]]; then
		warn "pipx not found; installing via Homebrew..."
		brew install pipx
	else
		warn "pipx not found; attempting user install..."
		python3 -m pip install --user pipx || true
	fi
fi

if command -v pipx >/dev/null 2>&1; then
	log "Ensuring pipx path..."
	pipx ensurepath || true
else
	warn "pipx still not available; continuing (Mason can handle most tools in-editor)."
fi

# --- Ensure ~/.local/bin on PATH (now + future) ---
if ! echo ":$PATH:" | grep -q ":$HOME/.local/bin:"; then
	export PATH="$HOME/.local/bin:$PATH"
	DEFAULT_SHELL="$(basename "${SHELL:-}")"
	case "$DEFAULT_SHELL" in
	zsh) RC="$HOME/.zshrc" ;;
	bash) RC="$HOME/.bashrc" ;;
	fish) RC="" ;; # handled via fish_user_paths
	*) RC="$HOME/.profile" ;;
	esac
	if [[ "$DEFAULT_SHELL" == "fish" ]]; then
		if command -v fish >/dev/null 2>&1; then
			fish -c 'set -U fish_user_paths $HOME/.local/bin $fish_user_paths' || true
		fi
	elif [[ -n "${RC:-}" ]]; then
		grep -q 'HOME/.local/bin' "$RC" 2>/dev/null || echo 'export PATH="$HOME/.local/bin:$PATH"' >>"$RC"
	fi
	log "Added ~/.local/bin to PATH (session + shell config)."
fi

# --- Helper: ensure a pipx package is installed (idempotent) ---
ensure_pipx_pkg() {
	local pkg="$1"
	if ! pipx list --short 2>/dev/null | grep -q "^${pkg}\\b"; then
		log "Installing ${pkg} via pipx..."
		pipx install "${pkg}" || warn "Could not install ${pkg} via pipx"
	else
		log "${pkg} already installed via pipx"
	fi
}

# --- Optional: install Python CLIs via pipx (idempotent) ---
if command -v pipx >/dev/null 2>&1; then
	ensure_pipx_pkg pynvim # Python provider for Neovim
	ensure_pipx_pkg black
	ensure_pipx_pkg ruff
fi

# --- OS-level extras (optional, comment out if not wanted) ---
case "$PKG_MGR" in
brew)
	brew install shellcheck shfmt stylua jq yamlfmt || true
	;;
pacman)
	sudo pacman -S --noconfirm --needed shellcheck shfmt stylua jq || true
	# yamlfmt is available via AUR helpers (e.g., yay -S yamlfmt)
	;;
apt)
	sudo apt install -y shellcheck shfmt jq || true
	# yamlfmt is not in default repos; install via Homebrew-on-Linux or Go if desired:
	#   brew install yamlfmt
	#   or: go install github.com/google/yamlfmt/cmd/yamlfmt@latest
	;;
dnf | yum)
	sudo $PKG_MGR install -y ShellCheck shfmt jq || true
	# shfmt/jq may be in EPEL or other repos.
	;;
esac

# NOTE: 'dockfmt' (Dockerfile formatter) is Go-based and not widely packaged.
# If you want it, install it separately:
#   go install github.com/jessfraz/dockfmt@latest

# --- Symlink repo to ~/.config/nvim ---
CONFIG_DIR="${HOME}/.config/nvim"
REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
log "Linking ${REPO_DIR} -> ${CONFIG_DIR}"
mkdir -p "$(dirname "${CONFIG_DIR}")"
if [[ -L "${CONFIG_DIR}" || -d "${CONFIG_DIR}" ]]; then
	warn "Backing up existing ${CONFIG_DIR} to ${CONFIG_DIR}.bak"
	rm -rf "${CONFIG_DIR}.bak" || true
	mv "${CONFIG_DIR}" "${CONFIG_DIR}.bak"
fi
ln -s "${REPO_DIR}" "${CONFIG_DIR}"
log "Config linked. Launch Neovim once to bootstrap plugins."

# --- Headless Treesitter update (helps avoid :checkhealth warnings) ---
log "Updating Treesitter parsers headlessly..."
nvim --headless "+Lazy! sync" "+TSUpdateSync" +qall || warn "TSUpdate failed; run :TSUpdate inside Neovim."

# --- Headless Mason install (LSPs + formatters) ---
read -r -p "Install recommended LSPs/formatters via Mason now (headless)? [y/N] " REPLY || true
if [[ "$REPLY" =~ ^[Yy]$ ]]; then
	log "Syncing plugins (lazy.nvim) and installing tools via Mason..."
	nvim --headless "+Lazy! sync" \
		"+MasonInstall \
bash-language-server basedpyright ruff-lsp terraform-ls helm-ls \
dockerfile-language-server yaml-language-server json-lsp \
black shfmt stylua prettierd" +qall ||
		warn "Mason headless install encountered issues. You can run :Mason inside Neovim."
fi

log "Setup complete."
echo "Start Neovim with: nvim"
echo "Inside Neovim, run :Mason to review or adjust installed tools."
