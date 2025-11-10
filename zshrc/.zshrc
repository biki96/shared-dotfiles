# --- Prompt & navigation ---
eval "$(starship init zsh)"   # Modern, fast prompt
eval "$(zoxide init zsh)"     # Smarter 'cd' navigation

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

# --- fzf integration ---
# Interactive fuzzy search for files/commands/history
source <(fzf --zsh)

# --- PATH cleanup ---
# Keep only what you actually use
export PATH="$HOME/.local/bin:$HOME/.local/share/omarchy/bin:$PATH"

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
