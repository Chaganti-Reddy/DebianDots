#!/bin/env bash
set -euo pipefail

# -------------------------- Colors and Logging --------------------------
BOLD=$(tput bold)
RESET=$(tput sgr0)
RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
YELLOW=$(tput setaf 3)
BLUE=$(tput setaf 4)
CYAN=$(tput setaf 6)

die() {
    echo -e "${BOLD}${RED}ERROR:${RESET} $*" >&2
    exit 1
}

info() {
    echo -e "${BOLD}${BLUE}INFO:${RESET} $*"
}

success() {
    echo -e "${BOLD}${GREEN}SUCCESS:${RESET} $*"
}

warning() {
    echo -e "${BOLD}${CYAN}WARNING:${RESET} $*"
}

# Prompt user with default value handling
prompt() {
    local message="${1:-}"
    local default="${2:-}"
    local input
    read -rp "$message [default: $default]: " input
    echo "${input:-$default}"
}

# Function to check if a symlink points to the correct directory
is_symlink_correct() {
    local target="$1"
    local symlink="$2"
    [ -L "$symlink" ] && [ "$(readlink -f "$symlink")" == "$target" ]
}

stow_with_check() {
    local target="$1"
    local symlink="$2"
    local name="$3"

    if is_symlink_correct "$target" "$symlink"; then
        echo -e "${GREEN}$name configuration is already correctly symlinked. Skipping stow.${RESET}"
    else
        if [ -e "$symlink" ] || [ -L "$symlink" ]; then
            echo -e "${CYAN}$name symlink is incorrect. Moving to $symlink.bak${RESET}"
            mv "$symlink" "$symlink.bak" || echo -e "${RED}Failed to move existing $name to $symlink.bak${RESET}"
        fi
        if stow "$name"; then
            echo -e "${GREEN}Successfully stowed $name configuration (symlink created).${RESET}"
        else
            echo -e "${RED}Failed to stow $name configuration${RESET}"
        fi
    fi
}

# Function to check if waldl is already installed
is_waldl_installed() {
    command -v waldl &>/dev/null
}

# Function to install waldl if not already installed
install_waldl() {
    if is_waldl_installed; then
        echo -e "${GREEN}waldl is already installed. Skipping installation.${RESET}"
    else
        echo -e "${CYAN}Installing waldl...${RESET}"
        cd "$HOME/dotfiles/Extras/Extras/waldl-master" && sudo make install && cd "$HOME/dotfiles" || die "waldl installation failed."
        echo -e "${GREEN}waldl installation successful.${RESET}"
    fi
}

# Function to check if a package is installed
is_installed() {
    pacman -Qi "$1" &>/dev/null || paru -Q "$1" &>/dev/null
}

# Install a package if not already installed
install_package() {
    local package_name=$1
    local display_name=$2
    local command=$3

    if is_installed "$package_name"; then
        success "$display_name ($package_name) is already installed."
    else
        info "Installing $display_name ($package_name)..."
        $command "$package_name"
    fi
}

# -------------------------- Error Handling --------------------------
trap 'die "An unexpected error occurred."' ERR

# Optional: log everything to a file (uncomment if needed)
# exec > >(tee -a ~/dotfiles-install.log) 2>&1

# -------------------------- Checks --------------------------
check_privileges() {
    if [[ $EUID -eq 0 ]]; then
        die "This script should not be run as root. Please run as regular user."
    fi

    if ! sudo -v; then
        die "User does not have sudo privileges or password is incorrect."
    fi
}

check_privileges

sudo apt update && sudo apt upgrade

sudo apt install preload yakuake nala curl wget fzf bash-completion flatpak ffmpeg default-jdk git wget nano vim unzip firmware-linux btop neofetch clang cargo tree tlp tlp-rdw xfsprogs ntfs-3g gnome-disk-utility openssh-server libavcodec-extra timeshift aria2 synaptic qalculate-gtk zoxide gcc g++ bat trash-cliyt-dlp ytfzf zsh zsh-autosuggestions zsh-syntax-highlighting stow python3-pip shellcheck mpv pipx texlive-full ccrypt exa fd-find mpd mpc hugo golang nginx lua5.1 gdb gopls tidy patch maven ripgrep tar time unrar unzip git-lfs lolcat net-tools numlockx rsync bc man-db dnsmasq -y

flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

sudo systemctl enable --now tlp.service

# Install latest firefox
sudo apt purge firefox-esr*
sudo install -d -m 0755 /etc/apt/keyrings
wget -q https://packages.mozilla.org/apt/repo-signing-key.gpg -O- | sudo tee /etc/apt/keyrings/packages.mozilla.org.asc > /dev/nul
gpg -n -q --import --import-options import-show /etc/apt/keyrings/packages.mozilla.org.asc | awk '/pub/{getline; gsub(/^ +| +$/,""); if($0 == "35BAA0B33E9EB396F59CA838C0BA5CE6DC6315A3") print "\nThe key fingerprint matches ("$0").\n"; else print "\nVerification failed: the fingerprint ("$0") does not match the expected one.\n"}'
echo "deb [signed-by=/etc/apt/keyrings/packages.mozilla.org.asc] https://packages.mozilla.org/apt mozilla main" | sudo tee -a /etc/apt/sources.list.d/mozilla.list > /dev/null
echo '
Package: *
Pin: origin packages.mozilla.org
Pin-Priority: 1000
' | sudo tee /etc/apt/preferences.d/mozilla
sudo apt-get update && sudo apt-get install firefox

sudo apt-add-repository contrib non-free -y
sudo apt install software-properties-common -y

sudo apt install ttf-mscorefonts-installer

# NodeJS - 22.x
curl -fsSL https://deb.nodesource.com/setup_22.x -o nodesource_setup.sh
sudo -E bash nodesource_setup.sh
sudo apt install -y nodejs

sudo npm install webtorrent-cli -g
sudo npm install -g peerflix
sudo npm install -g bash-language-server

bash install_zsh.sh

# Miniconda

# Define Miniconda installer URL and installer name
MINICONDA_URL="https://repo.anaconda.com/miniconda/Miniconda3-py310_24.3.0-0-Linux-x86_64.sh"
INSTALLER_NAME="Miniconda3.sh"

install_miniconda() {
    info "Setting up Miniconda..."

    source ~/.bashrc
    # Check if conda is already installed
    if command -v conda &>/dev/null; then
        success "Conda is already installed at $(command -v conda). Skipping installation."
        return
    fi

    local install_choice="${1:-}" # Optional positional parameter

    if [[ "$install_choice" =~ ^[Yy]$ ]]; then
        install_choice="y"
    else
        install_choice=$(prompt "Would you like to install Miniconda?" "y")
    fi

    if [[ ! "$install_choice" =~ ^[Yy]$ ]]; then
        warning "Miniconda installation skipped. Proceeding with the setup."
        return
    fi

    info "Miniconda installation will begin now..."

    # Download Miniconda installer
    info "Downloading Miniconda installer..."
    wget -q --show-progress -O "$INSTALLER_NAME" "$MINICONDA_URL"

    # Run the installer
    info "Running the Miniconda installer..."
    bash "$INSTALLER_NAME" -b -p "$HOME/miniconda" # Install silently in the $HOME/miniconda directory

    # Remove the installer after installation
    info "Cleaning up installer files..."
    rm "$INSTALLER_NAME"

    # Check if .bashrc and .zshrc exist and set Conda initialization
    SHELL_CONFIGS=()
    if [[ -f "$HOME/.bashrc" ]]; then
        SHELL_CONFIGS+=("$HOME/.bashrc")
    fi
    if [[ -f "$HOME/.zshrc" ]]; then
        SHELL_CONFIGS+=("$HOME/.zshrc")
    fi

    if [[ ${#SHELL_CONFIGS[@]} -eq 0 ]]; then
        die "Neither .bashrc nor .zshrc found. Exiting setup."
    fi

    # Conda initialization block
    CONDA_BLOCK='
# >>> conda initialize >>>
# !! Contents within this block are managed by "conda init" !!
__conda_setup="$('$HOME/miniconda/bin/conda' shell.${SHELL##*/} hook 2> /dev/null)"
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
# <<< conda initialize <<<'

    # Add Conda initialization to both files if not already present
    for config in "${SHELL_CONFIGS[@]}"; do
        if ! grep -q "conda initialize" "$config"; then
            info "Adding Conda initialization to $config..."
            echo "$CONDA_BLOCK" >>"$config"
        else
            success "Conda initialization block already present in $config."
        fi
    done

    # Now execute the Conda initialization code directly to initialize Conda
    if [[ "$SHELL" == *"bash"* ]]; then
        # Bash initialization
        eval "$($HOME/miniconda/bin/conda shell.bash hook)"
        info "Evaluating $HOME/miniconda/bin/conda shell.bash hook"
    elif [[ "$SHELL" == *"zsh"* ]]; then
        # Zsh initialization
        eval "$($HOME/miniconda/bin/conda shell.zsh hook)"
        info "Evaluating $HOME/miniconda/bin/conda shell.zsh hook"
    else
        die "Unsupported shell detected. Unable to initialize Conda."
    fi

    # Verify Conda and Python installation
    info "Verifying Miniconda installation..."
    conda --version
    python --version

    source ~/.bashrc

    success "Miniconda installation and initialization completed successfully."
    info "Python Version: $(python --version)"
    info "Conda Version: $(conda --version)"
    info "Installation path: $HOME/miniconda"

    sleep 3
    success "Miniconda setup is complete. Proceeding with the script..."
}

install_miniconda


# KVM
sudo apt install qemu-kvm libvirt-clients libvirt-daemon-system bridge-utils virtinst libvirt-daemon virt-manager -y
sudo systemctl status libvirtd
sudo virsh net-start default
sudo virsh net-autostart default
sudo adduser $USER libvirt
sudo adduser $USER libvirt-qemu
newgrp libvirt
newgrp libvirt-qemu

# ANI CLI
git clone "https://github.com/pystardust/ani-cli.git"
sudo cp ani-cli/ani-cli /usr/local/bin
rm -rf ani-cli

pipx install anipy-cli

#VS CODE
curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
sudo install -o root -g root -m 644 microsoft.gpg /etc/apt/keyrings/microsoft-archive-keyring.gpg
sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/microsoft-archive-keyring.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'

sudo apt-get update
sudo apt-get install code -y # or code-insiders

sudo apt install telegram-desktop -y


# FONTS
install_fonts() {
    info "Setting up Fonts..." && sleep 1

    local FONTS_DIR="$HOME/.local/share/fonts"
    local FONTS_SUBDIR="my-fonts-main"
    local FONTS_ZIP="$FONTS_DIR/my-fonts.zip"
    local FONTS_URL="https://gitlab.com/chaganti-reddy1/my-fonts/-/archive/main/my-fonts-main.zip"

    # Check if fonts already exist
    if [ -d "$FONTS_DIR/$FONTS_SUBDIR" ]; then
        success "Fonts directory already exists. Skipping installation..."
        sleep 1
        return
    fi

    # Create fonts directory if it doesn't exist
    warning "Creating fonts directory..."
    mkdir -p "$FONTS_DIR"

    # Download the zip file
    info "Downloading fonts..."
    if curl -L -o "$FONTS_ZIP" "$FONTS_URL"; then
        info "Extracting fonts..."
        unzip -q "$FONTS_ZIP" -d "$FONTS_DIR"

        info "Cleaning up zip file..."
        rm "$FONTS_ZIP"

        success "Fonts have been installed successfully."
        sleep 2
    else
        die "Failed to download fonts from $FONTS_URL"
        exit 1
    fi
}


install_ollama() {
    info "Setting up Ollama..."

    local install_choice="${1:-}" # Optional positional parameter, default to empty if not passed

    if [[ "$install_choice" =~ ^[Yy]$ ]]; then
        install_choice="y"
    else
        install_choice=$(prompt "Would you like to install Ollama (a tool to run large language models locally)?" "y")
    fi

    if [[ "$install_choice" =~ ^[Yy]$ ]]; then
        info "Ollama installation will begin now."

        if ! command -v ollama &>/dev/null; then
            info "Ollama not found. Installing..."

            curl -fsSL https://ollama.com/install.sh -o ollama_install.sh
            chmod +x ollama_install.sh
            VERSION_ID=rolling bash ollama_install.sh
            rm ollama_install.sh

            success "Ollama has been installed. You can now use it to run local large language models."
            sleep 2
            clear

            warning "Now you will see a lot of text but don't panic."
            warning "Just type 'y' or 'n' to choose models for installation as their names appear."
            sleep 7
            clear

            # Start ollama in background
            ollama serve &
            disown
            sleep 1

            # Ask user to install various models
            local models=("deepseek-r1:8b" "deepseek-coder:6.7b" "llama3:8b" "mistral" "zephyr" "llava:7b")

            for model in "${models[@]}"; do
                clear
                local model_choice
                model_choice=$(prompt "Would you like to install the model '$model'?" "y")

                if [[ "$model_choice" =~ ^[Yy]$ ]]; then
                    info "Installing model '$model'..."
                    ollama pull "$model" || warning "Failed to pull model '$model'"
                    success "Model '$model' installed."
                    sleep 1
                else
                    warning "Model '$model' installation skipped."
                    sleep 1
                fi
            done

            clear
            success "Ollama setup completed."
            sleep 2
        else
            success "Ollama is already installed on your system."
            sleep 1
        fi
    else
        warning "Ollama installation skipped. Proceeding with the setup."
        sleep 1
    fi
}

install_pip_packages() {
    info "Setting up PIP Packages..."

    # Safely handle $1, default to an empty string if $1 is not set
    local install_choice
    install_choice="${1:-}" # Use $1 if provided, otherwise default to an empty string

    if [[ -n "$install_choice" && "$install_choice" =~ ^[Yy]$ ]]; then
        install_choice="y"
    else
        install_choice=$(prompt "Would you like to install my PIP packages?" "y")
    fi

    if [[ "$install_choice" =~ ^[Yy]$ ]]; then
        info "Installing PIP packages..."

        # Determine pip install command based on whether conda is available
        local pip_cmd
        if command -v conda &>/dev/null; then
            pip_cmd="pip install"
            info "Conda detected. Using regular pip install."
        else
            pip_cmd="pip install --break-system-packages"
            warning "Conda not found. Using pip with --break-system-packages (Arch-safe)."
        fi

        # List of packages to install
        local pip_packages=(
            "pynvim" "numpy" "pandas" "matplotlib" "seaborn" "scikit-learn" "jupyterlab"
            "ipykernel" "ipywidgets" "python-prctl" "inotify-simple" "psutil" "libclang"
            "opencv-python" "keras" "mov-cli-youtube" "mov-cli" "mov-cli-test" "otaku-watcher"
            "film-central" "daemon" "jupyterlab_wakatime" "pygobject" "spotdl" "beautifulsoup4"
            "requests" "flask" "streamlit" "pywal16" "zxcvbn" "pyaml" "my_cookies" "codeium-jupyter"
            "pymupdf" "tk-tools" "ruff-lsp" "python-lsp-server" "semgrep" "transformers" "spacy"
            "nltk" "sentencepiece" "ultralytics" "roboflow" "pipreqs" "feedparser" "pypdf2" "fuzzywuzzy" "tensorflow" "sentence-transformers" "langchain-ollama" "pymupdf"
        )

        # Install each package if it's not already installed
        for package in "${pip_packages[@]}"; do
            if ! pip show "$package" &>/dev/null; then
                info "Installing $package..."
                $pip_cmd "$package" || warning "Failed to install $package"
            else
                success "$package is already installed."
            fi
        done

        # Install PyTorch (CPU version)
        if ! pip show "torch" &>/dev/null; then
            info "Installing PyTorch (CPU version)..."
            $pip_cmd torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cpu || warning "Failed to install PyTorch"
        else
            success "PyTorch is already installed."
        fi

        success "PIP packages installation completed."
        sleep 1
    else
        warning "PIP packages installation skipped. Proceeding with the setup."
        sleep 1
    fi
}

install_fonts
# install_ollama
install_pip_packages


sudo cp ~/DebianDots/Extras/Extras/etc/nanorc /etc/nanorc
sudo cp ~/DebianDots/Extras/Extras/etc/bash.bashrc /etc/bash.bashrc
sudo cp ~/DebianDots/Extras/Extras/etc/DIR_COLORS /etc/DIR_COLORS
# sudo cp ~/DebianDots/Extras/Extras/etc/environment /etc/environment
sudo cp ~/DebianDots/Extras/Extras/etc/mpd.conf /etc/mpd.conf
# sudo cp ~/DebianDots/Extras/Extras/nvim.desktop /usr/share/applications/nvim.desktop
cp ~/DebianDots/Extras/Extras/.wakatime.cfg.cpt ~/
warning "decrypting your wakatime API key ..."
sleep 1
ccrypt -d ~/.wakatime.cfg.cpt
