# Dotfiles

Moja lična konfiguracija za razvojno okruženje. Koristi [GNU Stow](https://www.gnu.org/software/stow/) za upravljanje symlink-ovima.

## Struktura

```
.
├── ghostty/     # Ghostty terminal config
├── nvim/        # Neovim config
├── starship/    # Starship prompt config
├── tnux/        # Tmux config
└── zshrc/       # Zsh shell config
```

## Instalacija

```bash
# Kloniraj repo
cd ~
git clone https://github.com/biki96/shared-dotfiles.git

# Instaliraj stow (Arch Linux)
sudo pacman -S stow

# Primeni konfiguracije
cd shared-dotfiles
stow ghostty
stow tnux
stow nvim
stow starship
stow zshrc
```

## Zsh konfiguracija

Uključuje:
- **starship** - brz, minimalistički prompt
- **zoxide** - pametna cd navigacija
- **fzf** - fuzzy finder za fajlove/istoriju
- **zsh-autosuggestions** - predlozi komandi
- **zsh-syntax-highlighting** - bojenje komandi
- **zsh-history-substring-search** - pretraga istorije
- **zsh-completions** - bolji autocomplete
- **bat** - cat sa syntax highlighting-om
- **uv** - brzi Python package manager

### Aliasi

- `tm` - Tmux session manager sa fzf
- `cat` - bat (syntax highlighting)
- `uva` - uv add
- `uvr` - uv run
- `uvs` - uv sync
- ...i još!

## Update

```bash
cd ~/shared-dotfiles
git pull
```
