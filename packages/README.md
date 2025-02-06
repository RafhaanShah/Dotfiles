### Brew
Source: https://brew.sh/

Install:
`brew install <package>`

Uninstall:
`brew uninstall <package>`

Update:
`brew update && brew upgrade`

Backup:
`brew bundle dump --force --describe --file="${DOTFILE_DIR}/packages/brew.txt"`

Restore:
`brew bundle --file "${DOTFILE_DIR}/packages/brew.txt"`

Search:
`brew search <package>`

Clean:
`brew autoremove && brew cleanup`

Diagnose:
`brew doctor`


### APT
Source: https://ubuntu.com/server/docs/package-management

Install:
`sudo apt install <package>`

Uninstall:
`sudo apt remove <package>`

Update:
`sudo apt update && sudo apt upgrade -y`

Backup:
`sudo apt list --installed`

Restore:
`xargs <"${DOTFILE_DIR}/packages/apt.txt" sudo apt install -y`

Search:
`sudo apt search <package>`

Clean:
`sudo apt autoremove && sudo apt autoclean`


### NPM
Source: https://www.npmjs.com/

Install:
`npm install --global <package>`

Uninstall:
`npm uninstall --global <package>`

Update:
`npm update --global`

Backup:
`command ls -1 $(npm root --global) > "${DOTFILE_DIR}/packages/npm.txt"`

Restore:
`xargs <"${DOTFILE_DIR}/packages/npm.txt" npm install --global`

Search:
`npm search <package>`


### PIP
Source: https://github.com/pypa/pipx

Install:
`pipx install <package>`

Uninstall:
`pipx uninstall <package>`

Update:
`pipx upgrade-all`

Backup:
`pipx list --short | cut -d' ' -f1 > "${DOTFILE_DIR}/packages/pip.txt"`

Restore:
`xargs <"${DOTFILE_DIR}/packages/pip.txt" pipx install`

Search:
`pip3 search <package>`


### Snap
Source: https://snapcraft.io/docs/quickstart-guide

Install:
`sudo snap install <package>`

Uninstall:
`sudo snap remove <package>`

Update:
`sudo snap refresh `

Backup:
`snap list`

Restore:
`xargs <"${DOTFILE_DIR}/packages/snap.txt" sudo snap install`

Search:
`snap find <package>`


### Termux
Source: https://wiki.termux.com/wiki/Package_Management

Install:
`pkg install <package>`

Uninstall:
`pkg uninstall <package>`

Update:
`pkg upgrade`

Backup:
`pkg list-installed`

Restore:
`xargs <"${DOTFILE_DIR}/packages/termux.txt" pkg install -y`

Search:
`pkg search <package>`

Clean:
`pkg autoclean`
