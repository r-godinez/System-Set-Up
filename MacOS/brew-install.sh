#!/bin/bash

# Install Homebrew
echo "==> Installing Homebrew (if not installed)..."
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Update Homebrew
echo "==> Updating Homebrew..."
brew update
brew upgrade

# Install Software
echo "==> Installing brew formulae..."
brew install \
  ansible \
  autoconf \
  automake \
  brotli \
  c-ares \
  ca-certificates \
  certifi \
  cffi \
  cmake \
  cryptography \
  expat \
  go \
  go-md2man \
  icu4c@76 \
  icu4c@77 \
  libgit2 \
  libnghttp2 \
  libsodium \
  libssh \
  libssh2 \
  libtool \
  libuv \
  libxml2 \
  libyaml \
  llvm \
  llvm@19 \
  lz4 \
  lzip \
  m4 \
  maturin \
  mpdecimal \
  ninja \
  node \
  openssl@3 \
  pcre2 \
  pkgconf \
  pycparser \
  python@3.11 \
  python@3.12 \
  python@3.13 \
  readline \
  rust \
  sphinx-doc \
  sqlite \
  swig \
  xz \
  z3 \
  zstd

# Install Apps
echo "==> Installing brew casks..."
brew install --cask \
  balenaetcher \
  bitwarden \
  ccleaner \
  discord \
  docker \
  dupeguru \
  firefox \
  github \
  google-chrome \
  google-drive \
  iterm2 \
  keka \
  kicad \
  malwarebytes \
  microsoft-office \
  notion \
  powershell \
  raspberry-pi-imager \
  spotify \
  virtualbox \
  visual-studio-code \
  zoom

echo "==> Cleaning up..."
brew cleanup

echo "✅ Done! All selected apps and tools have been installed."
