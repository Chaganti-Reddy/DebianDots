# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time Oh My Zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="archcraft-dwm"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='kate'
else
  export EDITOR='kate'
fi

export VISUAL='vim'

export BROWSER='/usr/bin/firefox'

# Compilation flags
# export ARCHFLAGS="-arch $(uname -m)"

# Set personal aliases, overriding those provided by Oh My Zsh libs,
# plugins, and themes. Aliases can be placed here, though Oh My Zsh
# users are encouraged to define aliases within a top-level file in
# the $ZSH_CUSTOM folder, with .zsh extension. Examples:
# - $ZSH_CUSTOM/aliases.zsh
# - $ZSH_CUSTOM/macos.zsh
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# On-demand rehash
zshcache_time="$(date +%s%N)"

autoload -Uz add-zsh-hook

rehash_precmd() {
  if [[ -a /var/cache/zsh/pacman ]]; then
    local paccache_time="$(date -r /var/cache/zsh/pacman +%s%N)"
    if (( zshcache_time < paccache_time )); then
      rehash
      zshcache_time="$paccache_time"
    fi
  fi
}

add-zsh-hook -Uz precmd rehash_precmd

source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/share/doc/fzf/examples/completion.zsh
source /usr/share/doc/fzf/examples/key-bindings.zsh

eval "$(zoxide init zsh)"
# neofetch

## Functions

function function_depends()  {
    search=$(echo "$1")
    sudo pacman -Sii $search | grep "Required" | sed -e "s/Required By     : //g" | sed -e "s/  /\n/g"
    }

function ex ()
{
  if [ -f $1 ] ; then
    case $1 in
      *.tar.bz2)   tar xjf $1   ;;
      *.tar.gz)    tar xzf $1   ;;
      *.bz2)       bunzip2 $1   ;;
      *.rar)       unrar x $1   ;;
      *.gz)        gunzip $1    ;;
      *.tar)       tar xf $1    ;;
      *.tbz2)      tar xjf $1   ;;
      *.tgz)       tar xzf $1   ;;
      *.zip)       unzip $1     ;;
      *.Z)         uncompress $1;;
      *.7z)        7z x $1      ;;
      *.deb)       ar x $1      ;;
      *.tar.xz)    tar xf $1    ;;
      *.tar.zst)   tar xf $1    ;;
      *)           echo "'$1' cannot be extracted via ex()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

function comp () {
  if [ -z "$1" ]; then
    echo "Usage: comp <file_or_directory>"
    return 1
  fi

  input="$1"
  echo "Select a compression format:"
  typeset -a options
  options=("tar.gz" "zip" "rar" "7z" "tar.xz" "tar.zst" "gz" "tar.bz2" "tar" "tbz2" "tgz" "bz2")
  for i in {1..${#options[@]}}; do
    echo "$i) ${options[$i]}"
  done

  echo -n "Enter the number of your choice: "
  read choice
  if [[ "$choice" -lt 1 || "$choice" -gt ${#options[@]} ]]; then
    echo "Invalid choice. Exiting."
    return 1
  fi

  format="${options[$choice]}"
  output="${input}.${format}"

  case $format in
    tar.bz2)   tar cjf "$output" "$input"   ;;
    tar.gz)    tar czf "$output" "$input"   ;;
    bz2)       bzip2 -k "$input"             ;;
    rar)       rar a "$output" "$input"     ;;
    gz)        gzip -k "$input"              ;;
    tar)       tar cf "$output" "$input"   ;;
    tbz2)      tar cjf "$output" "$input"  ;;
    tgz)       tar czf "$output" "$input"  ;;
    zip)       zip -r "$output" "$input"   ;;
    7z)        7z a "$output" "$input"     ;;
    tar.xz)    tar cJf "$output" "$input"  ;;
    tar.zst)   tar --zstd -cf "$output" "$input"  ;;
    *)         echo "Unsupported format: $format" ; return 1;;
  esac

  echo "Compression successful: $output"
}

compdef '_files' comp

ctime() {
  file="$1"

  if [[ $file == *.c ]]; then
    out_file="${file%.c}"
    g++ -std=c++17 "$file" -o "$out_file"
    # newline
    /usr/bin/time -p ./"$out_file"
  else
    g++ -std=c++17 "$file.c" -o "$file"
    /usr/bin/time -p ./"$file"
  fi
}

function cpptime() {
  file="$1"

  if [[ $file == *.cpp ]]; then
    out_file="${file%.cpp}"
    g++ -std=c++17 "$file" -o "$out_file"
    /usr/bin/time -p ./"$out_file"
  else
    g++ -std=c++17 "$file.cpp" -o "$file"
    /usr/bin/time -p ./"$file"
  fi
}

function mosscc() {
    perl -i moss.pl -l cc $1 $2
}

function mosspy() {
    perl -i moss.pl -l python $1 $2
}

export EDITOR='/usr/bin/kate'
export PAGER='bat'
export PATH="$HOME/bin:/usr/local/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.config/scripts/:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"
export PATH="$HOME/go/bin:$PATH"
export PATH="$HOME/.config/rofi/scripts:$PATH"
export PATH="$HOME/miniconda:$PATH"
export XDG_DATA_DIRS="/var/lib/flatpak/exports/share:$HOME/.local/share/flatpak/exports/share:$XDG_DATA_DIRS"

SUDO_EDITOR=/usr/bin/kate
export SUDO_EDITOR

# export FZF_DEFAULT_OPTS='--color=fg:#f8f8f2,bg:#282a36,hl:#bd93f9 --color=fg+:#f8f8f2,bg+:#44475a,hl+:#bd93f9 --color=info:#ffb86c,prompt:#50fa7b,pointer:#ff79c6 --color=marker:#ff79c6,spinner:#ffb86c,header:#6272a4'

export FZF_DEFAULT_OPTS="--layout=reverse --exact --border=bold --border=rounded --margin=3% --color=dark"

## ---------------------------------------------------------------------------------------


## Aliases

#list
# alias emacs="emacsclient -c -a 'emacs'"
alias zathura="$HOME/.local/bin/zathura"
alias cd="z"
alias cdi="zi"
alias la='exa -al --colour=always --icons --group-directories-first'
alias ll='exa -a --colour=always --icons --group-directories-first'
alias ls='exa -l --colour=always --icons --group-directories-first'
alias lt='exa -aT --colour=always --icons --group-directories-first'
alias l='ls'
alias l.="ls -A | egrep '^\.'"
alias listdir="ls -d */ > list"
alias depends='function_depends'

#fix obvious typo's
alias cd..='cd ..'
alias pdw='pwd'

## Colorize the grep command output for ease of use (good for log files)##
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'

#readable output
alias df='df -h'

#setlocale
alias setlocale="sudo localectl set-locale LANG=en_US.UTF-8"

#ps
alias psa="ps auxf"
alias psgrep="ps aux | grep -v grep | grep -i -e VSZ -e"

#add new fonts
alias update-fc='sudo fc-cache -fv'

#switch between bash and zsh
alias tobash="sudo chsh $USER -s /bin/bash && echo 'Now log out.'"
alias tozsh="sudo chsh $USER -s /bin/zsh && echo 'Now log out.'"
alias tofish="sudo chsh $USER -s /bin/fish && echo 'Now log out.'"

#audio check pulseaudio or pipewire
alias audio="pactl info | grep 'Server Name'"

#check cpu
alias cpu="cpuid -i | grep uarch | head -n 1"

#enabling vmware services
alias start-vmware="sudo systemctl enable --now vmtoolsd.service"
alias vmware-start="sudo systemctl enable --now vmtoolsd.service"
alias sv="sudo systemctl enable --now vmtoolsd.service"

#youtube download
alias yta-aac="yt-dlp --extract-audio --audio-format aac --embed-thumbnail"
alias yta-best="yt-dlp --extract-audio --audio-format best --embed-thumbnail"
alias yta-flac="yt-dlp --extract-audio --audio-format flac --embed-thumbnail"
alias yta-mp3="yt-dlp --extract-audio --audio-format mp3 --embed-thumbnail"
alias ytv-best="yt-dlp -f 'bestvideo[ext=mp4]+bestaudio[ext=m4a]/bestvideo+bestaudio' --embed-thumbnail --merge-output-format mp4 "
# alias ytfzf="invidious_instance='https://vid.puffyan.us' ytfzf --rii"
alias ytfzfsub="ytfzf -fcS"

#Recent Installed Packages
alias rip="expac --timefmt='%Y-%m-%d %T' '%l\t%n %v' | sort | tail -200 | nl"
alias riplong="expac --timefmt='%Y-%m-%d %T' '%l\t%n %v' | sort | tail -3000 | nl"

#Cleanup orphaned packages
alias cleanup='sudo pacman -Rns $(pacman -Qtdq)'

# This will generate a list of explicitly installed packages
alias list="sudo pacman -Qqe"
#This will generate a list of explicitly installed packages without dependencies
alias listt="sudo pacman -Qqet"
# list of AUR packages
alias listaur="sudo pacman -Qqem"
# add > list at the end to write to a file

# install packages from list
# pacman -S --needed - < my-list-of-packages.txt

#search content with ripgrep
alias rg="rg --sort path"

#shutdown or reboot
alias ssn="sudo shutdown now"
alias sr="reboot"

# DWM
alias makedwm="cd ~/.config/dwm/dwm && rm config.h && sudo make clean install"
alias makeslstatus="cd ~/.config/dwm/slstatus/ && rm -rf config.h && make && sudo make install"
alias makeblocks="cd ~/.config/dwm/dwmblocks/ && rm -rf blocks.h && make && sudo make install"
alias makest="cd ~/.config/dwm/st && cp config.def.h config.h && make && sudo make install"
alias dotfiles="cd $HOME/dotfiles/"
alias n="nvim"

nv() {
  if [[ -z "$1" ]]; then
    echo "Usage: e path/to/file"
    return 1
  fi
  # Expand ~ and get absolute path
  local file
  file="${1/#\~/$HOME}"

  # If relative, convert to absolute
  [[ "$file" != /* ]] && file="$PWD/$file"

  # Get the parent dir
  local dir="${file%/*}"

  if [[ "$dir" != "$file" && ! -d "$dir" ]]; then
    mkdir -p "$dir" || { echo "Failed to create directory: $dir"; return 2; }
  fi

  nvim "$file"
}

#git
alias gs="git status"
alias ga="git add"
alias gcm="git commit -m"
alias gc="git clone"
alias gp="git push"
alias gpb="git push -u origin"
alias reposize="git count-objects -vH"

alias mkcd='f() { mkdir -p "$1" && cd "$1"; }; f'
alias open='xdg-open'
alias karna='cd /mnt/Karna'

alias mangaread="curl -sSL mangal.metafates.one/run | sh"
alias torrentwatch1="peerflix -k -a -q"
alias torrentwatch2="webtorrent --mpv"
alias torrentdownload="webtorrent download"
alias anime1="ani-cli"
alias anime2="anipy-cli"
alias animef="fastanime --fzf anilist"
alias download="aria2c"
# alias timeshift-wayland="sudo -E timeshift-gtk"
alias projk="cd /mnt/Karna/Git/Project-K/"
alias portfolio="cd /mnt/Karna/Git/portfolio/"
alias blog="cd /mnt/Karna/Git/Karna-Blog/"
alias fontc="fc-cache -fv"
alias autocommit="sh ~/DebianDots/gitAutoCommitter.sh"
# alias debugwaybar="waybar -l trace"
alias rm="trash-put"
alias lazyd="lazydocker"
alias llama3="ollama run llama3:8b"
alias llama3k="ollama run llama3:8b-instruct-q6_K"
alias ollzephyr="ollama run zephyr:latest"
alias ollmistral="ollama run mistral:latest"
alias olldeepcode="ollama run deepseek-coder:6.7b"
alias ollquen25="ollama run quen2.5:3b"
alias olldeep="ollama run deepseek-r1:8b"
alias dsa="cd /mnt/Karna/Git/Project-K/Map/DSA/"
alias lampp="sudo /opt/lampp/lampp"
alias vi="vim"

function cheat() {
    curl cht.sh/$1
}

function fd() {
    local dir
    dir=$(
        (zoxide query -l; find / -maxdepth 8 -type d -not -path "/proc/*" -not -path "/sys/*" -not -path "/run/*" 2>/dev/null) \
        | fzf --preview 'ls -al {}' --tac
    ) && cd "$dir" && zle clear-screen
}


zle -N fd
bindkey '^O' fd


function rmfzf() {
    local target
    target=$(
        (find . -maxdepth 1 -type f 2>/dev/null; \
        find . -maxdepth 1 -type d 2>/dev/null) \
        | fzf --preview 'ls -al {}' --tac
    ) && trash "$target" && zle clear-screen
}

zle -N rmfzf
bindkey '^X^A' rmfzf

alias zlk="zellij --layout karna attach --create 'Karna'"
alias zlc="zellij --layout compi attach --create 'DSA'"
alias cp="/usr/bin/advcp -g"
alias mv="/usr/bin/advmv -g"
alias exmod="chmod +x"
alias lg="lazygit"

# -----------------CP PARSER -----------------
# Run CPParse in server mode (parsing)
function cparse() {
  ~/.config/scripts/CPParse
}

# Edit a problem solution
# Usage: cpedit A   (opens nvim in folder A/solution.py)
function cpedit() {
  if [[ -z "$1" ]]; then
    echo "Usage: cpedit <problem letter>"
    return 1
  fi
  ~/.config/scripts/CPParse edit "$1"
}

# Run tests for a single problem folder
# Usage: cprun A   (runs tests for folder A)
function cprun() {
  if [[ -z "$1" ]]; then
    echo "Usage: cprun <problem letter>"
    return 1
  fi
  ~/.config/scripts/CPParse run "$1"
}

alias cls="clear"

# Global run: run tests for all problem folders in the current contest folder
# Usage: cpRun
function cpRun() {
  ~/.config/scripts/CPParse Run
}

function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}

fpath+=~/.zfunc; autoload -Uz compinit; compinit

# --------------------------------------------


export STARSHIP_LOG="error"
export MPLBACKEND=TkAgg
export KUNST_MUSIC_DIR="/home/karna/Music/"
# eval "$(leetcode completions)"

[[ $commands[kubectl] ]] && source <(kubectl completion zsh)

# Generated for envman. Do not edit.
[ -s "$HOME/.config/envman/load.sh" ] && source "$HOME/.config/envman/load.sh"

# (cat ~/.cache/wal/sequences &)
#
# compdef fastanime
#
# _fastanime_completion() {
#     local -a completions
#     local -a completions_with_descriptions
#     local -a response
#     (( ! $+commands[fastanime] )) && return 1
#
#     response=("${(@f)$(env COMP_WORDS="${words[*]}" COMP_CWORD=$((CURRENT-1)) _FASTANIME_COMPLETE=zsh_complete fastanime)}")
#
#     for type key descr in ${response}; do
#         if [[ "$type" == "plain" ]]; then
#             if [[ "$descr" == "_" ]]; then
#                 completions+=("$key")
#             else
#                 completions_with_descriptions+=("$key":"$descr")
#             fi
#         elif [[ "$type" == "dir" ]]; then
#             _path_files -/
#         elif [[ "$type" == "file" ]]; then
#             _path_files -f
#         fi
#     done
#
#     if [ -n "$completions_with_descriptions" ]; then
#         _describe -V unsorted completions_with_descriptions -U
#     fi
#
#     if [ -n "$completions" ]; then
#         compadd -U -V unsorted -a completions
#     fi
# }
#
# if [[ $zsh_eval_context[-1] == loadautofunc ]]; then
#     # autoload from fpath, call function directly
#     _fastanime_completion "$@"
# else
#     # eval/source/. command, register function for later
#     compdef _fastanime_completion fastanime
# fi

# >>> conda initialize >>>
# !! Contents within this block are managed by "conda init" !!
__conda_setup="$(/home/karna/miniconda/bin/conda shell.${SHELL##*/} hook 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "$HOME/miniconda/etc/profile.d/conda.sh" ]; then
        . "$HOME/miniconda/etc/profile.d/conda.sh"
    else
        export PATH="$HOME/miniconda/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

















