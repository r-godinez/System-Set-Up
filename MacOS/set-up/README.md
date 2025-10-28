# 📦 Brew Install Script — macOS Monterey Setup

This script automates the installation of Homebrew packages (CLI tools) and macOS apps (GUI applications) after a clean installation of macOS Monterey.

---

## 🚀 How to Use

### 1. Clone or Download This Repository

Using Git:
```bash
git clone https://github.com/yourusername/brew-install-script.git
cd brew-install-script
```

Or manually download and unzip the `.zip` file of this repository.

---

### 2. Make the Script Executable

```bash
chmod +x set-up.sh
```

---

### 4. Run the Script

```bash
./set-up.sh
```

---

## 📋 What's Installed

### ✅ Formulae (Command Line Tools)
Includes:
- ansible
- rust
- go
- python@3.12
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

> See the full list in `set-up.sh`

---

## 🛠 Customize the Script

Open `set-up.sh` and:
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
