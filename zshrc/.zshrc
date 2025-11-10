# --- Prompt & navigation ---
eval "$(starship init zsh)"   # Modern, fast prompt
eval "$(zoxide init zsh)"     # Smarter 'cd' navigation

# --- Runtime manager ---
# mise (polyglot runtime manager - replaces asdf/nvm/rbenv)
if command -v mise &>/dev/null; then
    # Configure mise to use uv for Python
    export MISE_PYTHON_COMPILE=0
    export MISE_PYTHON_DEFAULT_PACKAGES_FILE="$HOME/.default-python-packages"

    eval "$(mise activate zsh)"
fi

# --- Editor ---
export EDITOR="nvim"
export SUDO_EDITOR="$EDITOR"

# --- History settings ---
HISTFILE="$HOME/.zsh_history"
HISTSIZE=100000
SAVEHIST=100000
setopt inc_append_history     # Save commands immediately
setopt share_history          # Share across terminals
setopt hist_ignore_all_dups   # Skip duplicate entries
setopt hist_reduce_blanks     # Trim extra spaces

# --- Completions (needed before fzf integration) ---
# Load additional completions
fpath=(/usr/share/zsh/site-functions $fpath)

autoload -Uz compinit
compinit

# Case-insensitive completion
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

# --- Plugins ---
# Autosuggestions (gray suggestions as you type)
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

# Syntax highlighting (colors commands in real-time)
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# History substring search (search history with up/down arrows)
source /usr/share/zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh

# Bind arrow keys for history substring search
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

# --- uv completions ---
# Generate completions for uv (if installed)
if command -v uv &>/dev/null; then
    eval "$(uv generate-shell-completion zsh)"
fi

# --- fzf integration ---
# Interactive fuzzy search for files/commands/history
source <(fzf --zsh)

# --- PATH cleanup ---
# Keep only what you actually use
export PATH="$HOME/.local/bin:$HOME/.local/share/omarchy/bin:$PATH"

# --- LS_COLORS (dynamic theme integration) ---
# Automatically sync ls/eza colors with omarchy theme
if command -v vivid &>/dev/null && command -v omarchy-theme-current &>/dev/null; then
    OMARCHY_THEME=$(omarchy-theme-current 2>/dev/null)

    case "$OMARCHY_THEME" in
        "Catppuccin"|"catppuccin")
            export LS_COLORS="$(vivid generate catppuccin-mocha)"
            ;;
        "Catppuccin-latte"|"catppuccin-latte")
            export LS_COLORS="$(vivid generate catppuccin-latte)"
            ;;
        "Gruvbox"|"gruvbox")
            export LS_COLORS="$(vivid generate gruvbox-dark)"
            ;;
        "Nord"|"nord")
            export LS_COLORS="$(vivid generate nord)"
            ;;
        "Tokyo-night"|"tokyo-night")
            export LS_COLORS="$(vivid generate tokyonight-night)"
            ;;
        "Rose-pine"|"rose-pine")
            export LS_COLORS="$(vivid generate rosepine)"
            ;;
        *)
            # Fallback to catppuccin-mocha if theme not recognized
            export LS_COLORS="$(vivid generate catppuccin-mocha)"
            ;;
    esac
fi

# --- Tmux helper function ---
new_tmux () {
  local session_dir
  session_dir="$(zoxide query -l | fzf --prompt='tmux dir> ' --height=40%)" || return

  local session_name
  session_name="$(basename "$session_dir" | tr ' ' '_')"

  if tmux has-session -t "$session_name" 2>/dev/null; then
    if [ -n "$TMUX" ]; then
      tmux switch-client -t "$session_name"
    else
      tmux attach -t "$session_name"
    fi
    local notification="tmux: attached to $session_name"
  else
    if [ -n "$TMUX" ]; then
      tmux new-session -d -c "$session_dir" -s "$session_name" \
        && tmux switch-client -t "$session_name"
      local notification="tmux: created (inside tmux) $session_name"
    else
      tmux new-session -c "$session_dir" -s "$session_name"
      local notification="tmux: created $session_name"
    fi
  fi

  if command -v notify-send >/dev/null 2>&1; then
    notify-send "$notification"
  fi
}

alias tm='new_tmux'

# --- Aliases ---
# Better cat with syntax highlighting
alias cat='bat'

# uv (Python package manager) aliases
alias uva='uv add'
alias uvexp='uv export --format requirements-txt --no-hashes --output-file requirements.txt'
alias uvl='uv lock'
alias uvlr='uv lock --refresh'
alias uvlu='uv lock --upgrade'
alias uvp='uv pip'
alias uvpy='uv python'
alias uvr='uv run'
alias uvrm='uv remove'
alias uvs='uv sync'
alias uvsr='uv sync --refresh'
alias uvsu='uv sync --upgrade'
alias uvup='uv self update'
alias uvv='uv venv'

# eza (modern ls/tree replacement) aliases
alias ls='eza --icons --git'
alias ll='eza --long --icons --git'
alias la='eza --long --all --icons --git'
alias tree='eza --tree --level=2 --icons'
