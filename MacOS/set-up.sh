#!/bin/bash

set -e

# Colors for output
GREEN="\033[0;32m"
CYAN="\033[0;36m"
NC="\033[0m"

echo -e "${CYAN}🔧 Starting macOS development environment setup...${NC}"

# Install Xcode Command Line Tools if not installed
if ! xcode-select -p &>/dev/null; then
  echo -e "${CYAN}🧰 Xcode Command Line Tools not found. Installing...${NC}"
  xcode-select --install
  echo -e "${CYAN}⏳ Please complete the installation manually if prompted, then re-run this script.${NC}"
  exit 1
else
  echo -e "${GREEN}✔ Xcode Command Line Tools already installed${NC}"
fi

# Install Homebrew if it's not installed
if ! command -v brew &> /dev/null; then
  echo -e "${CYAN}🍺 Homebrew not found. Installing...${NC}"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
  echo -e "${GREEN}✔ Homebrew already installed${NC}"
fi

echo -e "${CYAN}📦 Updating Homebrew...${NC}"
brew update

# Turn off analytics (in addition to setting env var in .zshrc)
echo -e "${CYAN}🔒 Disabling Homebrew analytics...${NC}"
brew analytics off

### --- CLI Tools / Formulae ---
CLI_FORMULAE=(
  ansible
  autoconf
  automake
  ca-certificates
  cmake
  go
  libgit2
  libyaml
  node
  openssl@3
  pkgconf
  python@3.12
  readline
  rust
  sqlite
  terraform
  #terragrunt
  zsh-completions
  zstd
  kubectl
  kustomize
  helm
  kind
  minikube
  cilium-cli
  dive
  #trivy
  nmap
  wireshark
  mitmproxy
  docker-compose
)

echo -e "${CYAN}📥 Installing CLI tools...${NC}"
for pkg in "${CLI_FORMULAE[@]}"; do
  if brew list --formula | grep -q "^${pkg}\$"; then
    echo -e "${GREEN}✔ ${pkg} already installed${NC}"
  else
    echo -e "${CYAN}➕ Installing ${pkg}...${NC}"
    brew install "$pkg"
  fi
done

### --- GUI Apps / Casks ---
CASK_APPS=(
  #docker
  iterm2
  visual-studio-code
  postman
  balenaetcher
  bitwarden
  ccleaner
  discord
  dupeguru
  firefox
  github
  google-chrome
  google-drive
  keka
  kicad
  malwarebytes
  microsoft-office
  notion
  powershell
  #protonvpn
  raspberry-pi-imager
  spotify
  virtualbox
  zoom
  mactex-no-gui
)

echo -e "${CYAN}🖥️ Installing GUI apps...${NC}"
for app in "${CASK_APPS[@]}"; do
  if brew list --cask | grep -q "^${app}\$"; then
    echo -e "${GREEN}✔ ${app} already installed${NC}"
  else
    echo -e "${CYAN}➕ Installing ${app}...${NC}"
    brew install --cask "$app"
  fi
done

### --- .zshrc Configuration ---
ZSHRC="$HOME/.zshrc"

# Back up existing .zshrc if it exists
if [ -f "$ZSHRC" ]; then
  echo -e "${CYAN}📦 Backing up existing .zshrc to .zshrc.bak...${NC}"
  cp "$ZSHRC" "$ZSHRC.bak"
else
  echo -e "${CYAN}🆕 Creating new .zshrc...${NC}"
  touch "$ZSHRC"
fi

# Write structured configuration
cat > "$ZSHRC" <<'EOF'
# >>> PATH additions
export PATH="/opt/homebrew/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"
export PATH="$HOME/go/bin:$PATH"
export PATH="/Library/TeX/texbin:$PATH"

# >>> Environment
export HOMEBREW_NO_ANALYTICS=1

# >>> Shell Options
setopt autocd               # Automatically cd into directories without typing 'cd'
setopt correct              # Suggests command corrections
setopt HIST_IGNORE_DUPS     # Avoid duplicate history entries

# >>> Aliases
alias ll='ls -lah'
alias gc='git clone'
alias gs='git status'
alias gl='git log'
alias gpl='git pull'
alias gph='git push'
alias gcm='git commit -m'
alias brewup='brew update && brew upgrade && brew cleanup'

# >>> Enable Command Completion
autoload -Uz compinit && compinit

# >>> Theme or Prompt (Powerlevel10k)
# [[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh
EOF

echo -e "${GREEN}✔ .zshrc configured and ready. Reload your shell or run: source ~/.zshrc${NC}"

echo -e "${CYAN}🧹 Cleaning up...${NC}"
brew cleanup

echo -e "${GREEN}✅ All done! Your development environment is fully set up.${NC}"
