# ══════════════════════════════════════════════════════════════
# Fastfetch on shell start (disabled)
# ══════════════════════════════════════════════════════════════
fastfetch

# ══════════════════════════════════════════════════════════════
# Oh My Zsh
# ══════════════════════════════════════════════════════════════
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME=""
plugins=(git zsh-autosuggestions zsh-syntax-highlighting)
source $ZSH/oh-my-zsh.sh

# Keep fastfetch after clear
 alias clear='clear && fastfetch'

# ══════════════════════════════════════════════════════════════
# Wayland / Hyprland
# ══════════════════════════════════════════════════════════════
export WAYLAND_DISPLAY=wayland-1
export XDG_SESSION_TYPE=wayland
export QT_QPA_PLATFORM=wayland
export GDK_BACKEND=wayland
export XDG_RUNTIME_DIR=/run/user/$(id -u)

# ══════════════════════════════════════════════════════════════
# Java
# ══════════════════════════════════════════════════════════════
export JAVA_HOME=/usr/lib/jvm/java-21-openjdk
export PATH=$JAVA_HOME/bin:$PATH

# ══════════════════════════════════════════════════════════════
# PATH additions
# ══════════════════════════════════════════════════════════════
export PATH=$HOME/.local/bin:$PATH   # python tools: black, isort, flake8
export PATH="$HOME/.cargo/bin:$PATH" # rust/cargo

# ══════════════════════════════════════════════════════════════
# Editor / Shell
# ══════════════════════════════════════════════════════════════
export EDITOR=nvim
export VISUAL=nvim
export SHELL=/bin/zsh

# ══════════════════════════════════════════════════════════════
# Network (nmcli)
# ══════════════════════════════════════════════════════════════
alias wifi='nmcli device wifi list'
alias wifion='nmcli radio wifi on'
alias wifioff='nmcli radio wifi off'
alias netstat='nmcli connection show --active'
wificonnect() { nmcli device wifi connect "$1" password "$2"; }
alias warp-on='warp-cli connect'
alias warp-off='warp-cli disconnect'

# ══════════════════════════════════════════════════════════════
# Zsh syntax / autosuggest colors (neon theme)
# ══════════════════════════════════════════════════════════════
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#FF0000,bold"

ZSH_HIGHLIGHT_STYLES[command]='fg=#39FF14,bold,underline'
ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=#FF0000,bold'
ZSH_HIGHLIGHT_STYLES[string]='fg=#A6E3A1'
ZSH_HIGHLIGHT_STYLES[path]='fg=#94E2D5,underline'
ZSH_HIGHLIGHT_STYLES[single-hyphen-option]='fg=#CBA6F7'
ZSH_HIGHLIGHT_STYLES[double-hyphen-option]='fg=#CBA6F7'
ZSH_HIGHLIGHT_STYLES[numeric-literal]='fg=#FAB387'
ZSH_HIGHLIGHT_STYLES[comment]='fg=#6C7086,italic'
ZSH_HIGHLIGHT_STYLES[builtin]='fg=#39FF14,bold,underline'
ZSH_HIGHLIGHT_STYLES[alias]='fg=#39FF14,bold,underline'

# ══════════════════════════════════════════════════════════════
# Xstream CP shortcuts
# ══════════════════════════════════════════════════════════════
cpush() { git add -A && git commit -m "$1" && git push }
alias cst="git status"
alias clog="git log --oneline --graph --decorate -10"
alias cdiff="git diff"

# ══════════════════════════════════════════════════════════════
# FZF — neon theme (single source of truth; duplicate block removed)
# ══════════════════════════════════════════════════════════════
export FZF_DEFAULT_OPTS="
  --color=bg:#000000,bg+:#0D0D0D
  --color=fg:#00FF00,fg+:#39FF14
  --color=hl:#FF007C,hl+:#FF00FF
  --color=border:#00FFFF
  --color=prompt:#FF007C,pointer:#00FFFF,marker:#FFFF00
  --color=info:#FF00FF,spinner:#00FFFF,header:#FF007C
  --color=query:#00FFFF,disabled:#444444
  --border=double
  --prompt='⚡ '
  --pointer='▶'
  --marker='✦'
  --height=90%
  --layout=reverse
  --info=inline
  --margin=1
  --padding=1"

source /usr/share/fzf/key-bindings.zsh
source /usr/share/fzf/completion.zsh

# fzf file search + bat preview
export FZF_DEFAULT_COMMAND='find . -type f'
export FZF_CTRL_T_OPTS="
  --preview 'bat --color=always --style=numbers,changes --line-range=:200 {}'
  --preview-window=right:60%:wrap"
export FZF_ALT_C_OPTS="
  --preview 'ls -la --color=always {}'"

alias fp='fzf --preview "bat --color=always --style=numbers {}"'
alias fv='fzf --preview "bat --color=always --style=numbers {}" | xargs nvim'

# ══════════════════════════════════════════════════════════════
# Zoxide (smarter cd)
# ══════════════════════════════════════════════════════════════
eval "$(zoxide init zsh)"
alias cd="z"

# ══════════════════════════════════════════════════════════════
# Eza (better ls)
# ══════════════════════════════════════════════════════════════
alias ls="eza --icons --color=always --group-directories-first"
alias ll="eza -la --icons --color=always --group-directories-first --git"
alias lt="eza --tree --icons --color=always --level=2"

# ══════════════════════════════════════════════════════════════
# Cursor shape fix (block cursor after every prompt)
# ══════════════════════════════════════════════════════════════
_fix_cursor() { echo -ne '\e[2 q' }
precmd_hooks+=(_fix_cursor)
zle-line-init() { echo -ne '\e[2 q' }
zle -N zle-line-init
stty quit undef

# ══════════════════════════════════════════════════════════════
# Starship prompt
# ══════════════════════════════════════════════════════════════
eval "$(starship init zsh)"

# ══════════════════════════════════════════════════════════════
# Misc
# ══════════════════════════════════════════════════════════════
alias bonsai='cbonsai -li -t 0.03 -w 4 -L 32 -M 5 -b 1 -k 46,201,82,51'
alias webui-stop="docker stop open-webui"
alias webui-start="docker start open-webui"
alias webui-status="docker ps -a --filter name=open-webui"

# ══════════════════════════════════════════════════════════════
# Secrets — do NOT put real keys here (this file lives in the dotfiles repo)
# Export real values only in ~/.zshrc directly, or source a gitignored .env
# ══════════════════════════════════════════════════════════════
# export GEMINI_API_KEY="..."   # <-- set this in ~/.zshrc, not here

# ══════════════════════════════════════════════════════════════
# Cache cleanup helper
# ══════════════════════════════════════════════════════════════
cleanup() {
  echo "Cleaning Discord..."
  rm -rf ~/.config/discord/{Cache,"Code Cache",GPUCache,logs,sentry,DawnWebGPUCache,DawnGraphiteCache}

  echo "Cleaning Chromium..."
  rm -rf ~/.cache/chromium
  rm -rf ~/.config/chromium/Default/{Service\ Worker,GPUCache}

  echo "Cleaning Firefox cache..."
  rm -rf ~/.cache/mozilla/*

  echo "Cleaning JetBrains cache..."
  rm -rf ~/.cache/JetBrains/*

  echo "Cleaning Mesa shader cache..."
  rm -rf ~/.cache/mesa_shader_cache/*

  echo "Cleaning yay cache..."
  yay -Sc --noconfirm

  echo "Cleaning pacman cache..."
  sudo paccache -rk1

  echo "Done."
}
