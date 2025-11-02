#!/bin/bash

set -e

# Create 'Logs' directory if it doesn't exist
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOG_DIR="${SCRIPT_DIR}/Logs"
mkdir -p "$LOG_DIR"
LOG_FILE="${LOG_DIR}/$(date +%H-%M-%S).log"

# Colors for output
GREEN="\033[0;32m"
RED="\033[0;31m"
CYAN="\033[0;36m"
NC="\033[0m"

# Logging function
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

# Output functions
print_info() { 
    echo -e "${CYAN}$1${NC}"
    log "INFO: $1"
}
print_success() { 
    echo -e "${GREEN}$1${NC}"
    log "SUCCESS: $1"
}
print_error() { 
    echo -e "${RED}$1${NC}"
    log "ERROR: $1"
}

print_info "🔧 Starting macOS development environment setup..."

# Install Xcode Command Line Tools if not installed
if ! xcode-select -p &>/dev/null; then
  print_info "🧰 Installing Xcode Command Line Tools..."
  xcode-select --install
  print_info "⏳ Please complete the installation if prompted, then re-run this script."
  exit 1
else
  print_success "✔ Xcode Command Line Tools already installed"
fi 

# Install Homebrew if not installed
if ! command -v brew &>/dev/null; then
  print_info "🍺 Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
  print_success "✔ Homebrew already installed"
fi

print_info "📦 Updating Homebrew..."
brew update
brew analytics off

### --- CLI Tools / Formulae ---
CLI_FORMULAE=(
  ansible
  cmake
  docker
  docker-compose
  go
  kubectl
  helm
  node
  python@3.12
  rust
  terraform
  zsh-completions
)

print_info "📥 Installing CLI tools..."
for pkg in "${CLI_FORMULAE[@]}"; do
  if brew list --formula | grep -q "^${pkg}\$"; then
    print_success "✔ ${pkg} already installed"
  else
    brew install "$pkg"
  fi
done

### --- GUI Apps / Casks ---
CASK_APPS=(
  balenaetcher
  brave
  bitwarden
  ccleaner
  cursor
  discord
  docker
  firefox
  github
  google-chrome
  google-drive
  grandperspective
  keka
  kicad
  iterm2
  malwarebytes
  microsoft-office
  notion
  powershell
  protonvpn
  raspberry-pi-imager
  spotify
  virtualbox
  visual-studio-code
)

print_info "🖥️ Installing GUI apps..."
for app in "${CASK_APPS[@]}"; do
  if brew list --cask | grep -q "^${app}\$"; then
    print_success "✔ ${app} already installed"
  else
    brew install --cask "$app"
  fi
done

### --- Shell Configuration ---
ZSHRC="$HOME/.zshrc"

# Backup existing .zshrc
[ -f "$ZSHRC" ] && cp "$ZSHRC" "$ZSHRC.bak"

# Write new configuration
cat > "$ZSHRC" <<'EOF'
# Path
export PATH="/opt/homebrew/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"
export PATH="$HOME/go/bin:$PATH"

# Environment
export HOMEBREW_NO_ANALYTICS=1

# Shell Options
setopt autocd
setopt correct
setopt HIST_IGNORE_DUPS

# Aliases
alias ll='ls -lah'
alias gs='git status'
alias gpl='git pull'
alias gph='git push'
alias gc='git clone'
alias gp='git pull'
alias brewup='brew update && brew upgrade && brew cleanup'

# Enable Command Completion
autoload -Uz compinit && compinit

# Theme or Prompt (Powerlevel10k)
# [[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh
EOF

print_info "🎨 Configuring system preferences..."

# Set Dark Mode
defaults write -g AppleInterfaceStyle -string "Dark"
killall Dock

print_info "🧹 Cleaning up..."
brew cleanup

print_success "✅ Setup complete! Please restart your terminal to apply all changes."
print_info "📝 Log file has been saved to: $LOG_FILE"

# Add error handler
trap 'print_error "An error occurred. Check the log file for details: $LOG_FILE"; exit 1' ERR