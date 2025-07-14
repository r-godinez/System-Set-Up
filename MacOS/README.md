# 📦 Brew Install Script — macOS Monterey Setup

This script automates the installation of Homebrew packages (CLI tools) and macOS apps (GUI applications) after a clean installation of macOS Monterey.

---

## 🚀 How to Use

### 1. Install Homebrew (if not already installed)

Paste this in your Terminal:
```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

---

### 2. Clone or Download This Repository

Using Git:
```bash
git clone https://github.com/yourusername/brew-install-script.git
cd brew-install-script
```

Or manually download and unzip the `.zip` file of this repository.

---

### 3. Make the Script Executable

```bash
chmod +x brew-install.sh
```

---

### 4. Run the Script

```bash
./brew-install.sh
```

---

## 📋 What's Installed

### ✅ Formulae (Command Line Tools)
Includes:
- ansible
- rust
- go
- python@3.11, @3.12, @3.13
- node
- llvm
- and many more...

### 🖥️ Casks (GUI Applications)
Includes:
- Google Chrome
- Firefox
- Visual Studio Code
- Notion
- Docker
- VirtualBox
- Spotify
- Zoom
- and others...

> See the full list in `brew-install.sh`

---

## 🛠 Customize the Script

Open `brew-install.sh` and:
- Remove any packages you don’t need
- Add new ones using:

```bash
brew install <formula>
brew install --cask <app>
```

---

## 🧹 Post-Install Cleanup

The script ends with:
```bash
brew cleanup
```
This removes outdated versions and frees up disk space.

---

## 🧰 Requirements

- macOS Monterey
- Xcode Command Line Tools:
```bash
xcode-select --install
```

---

## ✅ License

MIT — Use, modify, and share freely.
