#!/bin/sh

# check for root access
SUDO=
if [ "$(id -u)" -ne 0 ]; then
    SUDO=$(command -v sudo 2> /dev/null)

    if [ ! -x "${SUDO}" ]; then
        echo "Error: Run this script as root"
        exit 1
    fi
fi


set -e
ARCH=$(uname -m)
INSTALL_ZSH=false
INSTALL_PYTHON=false
INSTALL_DOCKER=false
ASSUME_YES=false

show_help() {
    echo "Usage: $0 [options]"
    echo ""
    echo "Options:"
    echo "  -n                Non-interactive mode (assume yes)."
    echo "  -z                Install ZSH."
    echo "  -p                Install Python."
    echo "  -d                Install Docker."
    echo "  -h                Show this help message."
    echo ""
}

# Parse command line arguments. Available arguments are:
# -n                Non-interactive mode.
# -z                Install ZSH.
# -p                Install Python.
# -d                Install Docker.
# -h                Show help.
while getopts 'nzpdh' opt
do
    case $opt in
        n) ASSUME_YES=true ;;
        z) INSTALL_ZSH=true ;;
        p) INSTALL_PYTHON=true ;;
        d) INSTALL_DOCKER=true ;;
        h) show_help; exit 0 ;;
        *) show_help; exit 1 ;;
    esac
done

check_cmd() {
    command -v "$1" 2> /dev/null
}

get_install_opts_for_apt() {
    flags=$(get_install_opts_for "apt")
    RETVAL="$flags"
}

get_install_opts_for_dnf() {
    flags=$(get_install_opts_for "dnf")
    RETVAL="$flags"
}

get_install_opts_for_yum() {
    flags=$(get_install_opts_for "yum")
    RETVAL="$flags"
}

get_install_opts_for_zypper() {
    flags=$(get_install_opts_for "zypper")
    RETVAL="$flags"
}

get_install_opts_for() {
    if $ASSUME_YES; then
        case "$1" in
            zypper)
                echo "-n";;
            *)
                echo "-y";;
        esac
    fi
    echo ""
}

# Zsh functions

install_zsh_apt() {
    if check_cmd apt; then
        get_install_opts_for_apt
        opts="${RETVAL}"
        echo "Updating package lists..."
        ${SUDO} apt-get update $opts

        # Update SO packages
        echo "Updating SO packages..."
        ${SUDO} apt-get dist-upgrade $opts

        # Cleaning SO packages
        echo "Cleaning up unused packages..."
        ${SUDO} apt-get auto-remove $opts

        # Install zsh
        echo "Installing zsh..."
        ${SUDO} apt-get install $opts zsh git wget
    fi
}

install_zsh_dnf() {
    if check_cmd dnf5; then
        get_install_opts_for_dnf
        opts="${RETVAL}"
        echo "Installing dnf5..."
        ${SUDO} dnf5 install $opts dnf5

        # Update package lists
        echo "Updating package lists..."
        ${SUDO} dnf5 check-update $opts || true

        # Update SO packages
        echo "Updating system packages..."
        ${SUDO} dnf5 upgrade $opts

        # Cleaning SO packages
        echo "Cleaning up unused packages..."
        ${SUDO} dnf5 autoremove $opts

        # Install zsh, git, wget
        echo "Installing zsh, git, and wget..."
        ${SUDO} dnf5 install $opts zsh git wget
    fi
    if check_cmd dnf; then
        opts=$(get_install_opts_for_dnf)
        echo "Installing dnf..."
        ${SUDO} dnf install $opts dnf

        # Update package lists
        echo "Updating package lists..."
        ${SUDO} dnf check-update $opts || true

        # Update SO packages
        echo "Updating system packages..."
        ${SUDO} dnf upgrade $opts

        # Cleaning SO packages
        echo "Cleaning up unused packages..."
        ${SUDO} dnf autoremove $opts

        # Install zsh, git, wget
        echo "Installing zsh, git, and wget..."
        ${SUDO} dnf install $opts zsh git wget
    fi
}

install_zsh_zypper() {
    if check_cmd zypper; then
        get_install_opts_for_zypper
        opts="${RETVAL}"
        echo "Updating package lists..."
        ${SUDO} zypper refresh $opts

        # Cleaning SO packages
        echo "Cleaning up unused packages..."
        ${SUDO} zypper clean $opts

        # Install zsh
        echo "Installing zsh..."
        ${SUDO} zypper install $opts zsh git wget
    fi
}

install_zsh_yum() {
    if check_cmd yum && check_cmd yum-config-manager; then
        get_install_opts_for_yum
        opts="${RETVAL}"
        repo="${REPO_URL_RPM}"
        if [ ! -f "${REPO_URL_RPM}" ]; then
            repo="${repo}/${ARCH}"
        fi

        ${SUDO} rpm -v --import "${PUB_KEY}"
        ${SUDO} yum-config-manager --add-repo "${repo}"
        if [ ! -z "${APP_VERSION}" ]; then
            ${SUDO} yum ${opts} install --nogpgcheck "${PACKAGE}"-"${APP_VERSION}"."${ARCH}"    
        else
            ${SUDO} yum ${opts} install --nogpgcheck "${PACKAGE}"
        fi
    fi
}

install_zsh() {
    # Install Oh My Zsh
    echo "Installing Oh My Zsh..."
    sh -c "$(wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)" "" --unattended

    # Set Zsh as default shell for the current session
    echo "Switching to zsh..."
    export SHELL=$(which zsh)

    # Cloning plugin projects
    echo "Cloning plugin projects..."
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting"
    git clone https://github.com/zsh-users/zsh-autosuggestions "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions"
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf

    # Install fzf
    echo "Installing fzf plugin..."
    ~/.fzf/install --all

    # Path to the .zshrc file (adjust if needed)
    ZSHRC_FILE="$HOME/.zshrc"

    # Check if .zshrc exists
    if [ ! -f "$ZSHRC_FILE" ]; then
        echo "Error: .zshrc file not found at $ZSHRC_FILE"
        exit 1
    fi

    # Replace the plugins=(git) line with the new plugins
    echo "Updating plugins in $ZSHRC_FILE..."
    sed -i 's/plugins=(git)/plugins=(\
    git\
    zsh-syntax-highlighting\
    zsh-autosuggestions\
    fzf\
    )/' "$ZSHRC_FILE"

    # Inform the user that the update was successful
    echo "Plugins updated successfully in $ZSHRC_FILE"
}

# Python functions

install_python_apt() {
    if check_cmd apt; then
        get_install_opts_for_apt
        opts="${RETVAL}"
        echo "Updating package lists..."
        $SUDO apt-get update $opts

        # Update SO packages
        echo "Updating SO packages..."
        $SUDO apt-get dist-upgrade $opts

        # Cleaning SO packages
        echo "Cleaning up unused packages..."
        $SUDO apt-get auto-remove $opts

        #Instalando UV
        echo "Instalando requirements system packages..."
        $SUDO apt install $opts make curl build-essential libssl-dev zlib1g-dev \
            libbz2-dev libreadline-dev wget curl llvm libncursesw5-dev \
            xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev
    fi
}

install_python_dnf() {
    if check_cmd dnf5; then
        get_install_opts_for_dnf
        opts="${RETVAL}"
        echo "Updating dnf5..."
        sudo dnf5 install -y dnf5

        # Install required system packages on Fedora using dnf5
        $SUDO dnf5 install $opts make curl gcc gcc-c++ openssl-devel \
            bzip2-devel readline-devel wget llvm ncurses-devel xz tk-devel \
            libxml2-devel 
    fi
    if check_cmd dnf; then
        get_install_opts_for_dnf
        opts="${RETVAL}"
        echo "Updating dnf..."
        sudo dnf install -y dnf

        # Install required system packages on Fedora using dnf
        $SUDO dnf install $opts make curl gcc gcc-c++ openssl-devel \
            bzip2-devel readline-devel wget llvm ncurses-devel xz tk-devel \
            libxml2-devel xmlsec1-devel libffi-devel lzma-sdk-devel
    fi
}

install_python_yum() {
    if check_cmd yum && check_cmd yum-config-manager; then
        get_install_opts_for_yum
        opts="${RETVAL}"

        echo "Updating package lists..."
        $SUDO yum check-update $opts || true

        # Update SO packages
        echo "Updating system packages..."
        $SUDO yum upgrade $opts

        # Cleaning SO packages
        echo "Cleaning up unused packages..."
        $SUDO yum autoremove $opts

        # Install required system packages on Fedora using yum
        $SUDO yum install $opts make curl gcc gcc-c++ openssl-devel bzip2-devel \
            readline-devel wget llvm ncurses-devel xz tk-devel \
            libxml2-devel xmlsec1-devel libffi-devel lzma-sdk-devel
    fi

}

install_python_zypper() {
    if check_cmd zypper; then
        get_install_opts_for_zypper
        opts="${RETVAL}"
        echo "Updating package lists..."
        $SUDO zypper refresh $opts

        # Cleaning SO packages
        echo "Cleaning up unused packages..."
        $SUDO zypper clean $opts

        # Install required system packages on Fedora using zypper
        $SUDO zypper install $opts make curl gcc gcc-c++ libopenssl-devel libbz2-devel \
            readline-devel wget llvm ncurses-devel xz-devel tk-devel \
            libxml2-devel libxmlsec1-devel libffi-devel
    fi
}

install_python(){
    # Install or upgrade uv - preferred method is via rpm or curl installer
    echo "Installing uv..."
    curl -LsSf https://astral.sh/uv/install.sh | sh
    export PATH="$HOME/.local/bin:$PATH"

    # Install global Python version using uv
    install_python_global
}


install_python_global() {
  uv python install 3.12.11
  uv python pin 3.12.11
}




if $INSTALL_ZSH; then
    install_zsh_apt
    install_zsh_dnf
    install_zsh_zypper
    install_zsh_yum
    install_zsh
fi


if $INSTALL_PYTHON; then
    install_python_apt
    install_python_dnf
    install_python_zypper
    install_python_yum
    install_python
fi

