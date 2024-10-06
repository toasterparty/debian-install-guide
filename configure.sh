#!/usr/bin/env bash
set -e

HOST="https://toasterparty.github.io/debian-setup-guide"
SH="$HOME/sh"

# Download util scripts

FILENAMES=("update.sh" "cron.sh")
mkdir -p $SH && cd $SH
for FILENAME in "${FILENAMES[@]}"; do
    FILEPATH=$SH/$FILENAME
    wget -nv -N $HOST/sh/$FILENAME
    chmod +x $FILEPATH
done

### CONFIG MENU ###

show_menu() {
    echo ""
    echo "Choose an option:"
    echo "1) Enable passwordless sudo"
    echo "2) Update packages"
    echo "3) Install common packages"
    echo "4) Update firmware"
    echo "5) Enable weekly system update"

    # docker
    # git
    # ssh

    echo "98) ALL OF THE ABOVE"
    echo "99) Exit"
}

while true; do
    show_menu
    read -p ">" CHOICE
    case "$CHOICE" in
        1)
            # Enable passwordless sudo
            LINE='%sudo ALL=(ALL) NOPASSWD: ALL'
            FILEPATH='/etc/sudoers'
            sudo grep -xsqF "$LINE" "$FILEPATH" || echo "$LINE" | sudo tee -a "$FILEPATH"
            echo "Passwordless sudo: OK"
            ;;
        2)
            # Update packages
            $SH/update.sh
            ;;
        3)
            # Install common packages
            SYS_PKG="ufw ca-certificates gnupg"
            UTIL_PKG="wget curl openssh-server"
            DEV_PKG="git cmake ccache docker"
            PYTHON_PKG="python3 python3-venv python3-setuptools python3-pip"
            sudo apt-get install -m -y $SYS_PKG $UTIL_PKG $DEV_PKG $PYTHON_PKG
            echo "Common packages installation complete"
            ;;
        4)
            # Update firmware

            # Add firmware to apt sources
            SOURCES_LIST="/etc/apt/sources.list"
            BACKUP_FILE="/etc/apt/sources.list.bak"
            TAGS=("contrib" "non-free" "non-free-firmware")

            if [ ! -f "$BACKUP_FILE" ]; then
                sudo cp $SOURCES_LIST $BACKUP_FILE
            fi

            # Process each line in sources.list
            sudo bash -c 'while read -r line; do
                if [[ -z "$line" || "$line" =~ ^# ]]; then
                    echo "$line"
                    continue
                fi

                new_line="$line"
                
                if ! [[ "$line" =~ contrib ]]; then
                    new_line="$new_line contrib"
                fi

                if ! [[ "$line" =~ non-free[^-] ]]; then
                    new_line="$new_line non-free"
                fi

                if ! [[ "$line" =~ non-free-firmware ]]; then
                    new_line="$new_line non-free-firmware"
                fi

                echo "$new_line"
            done < /etc/apt/sources.list > /etc/apt/sources.list.tmp'

            # Replace the original file with the modified one
            sudo mv /etc/apt/sources.list.tmp /etc/apt/sources.list

            $SH/update.sh
            sudo apt-get install -m -y fwupd firmware-linux-nonfree

            # Reload fwupd service to ensure it's up-to-date
            sudo systemctl daemon-reload
            sudo systemctl restart fwupd

            # Refresh the list of available firmware updates
            echo "Checking for firmware updates..."
            sudo fwupdmgr refresh --force

            # Check for available updates
            sudo fwupdmgr get-updates
            sudo fwupdmgr update

            echo "Done checking for firmware updates. A reboot may or may not be nececssary"
            ;;
        5)
            # Enable weekly system update
            $HOME/sh/cron.sh "update" "$HOME/sh/update.sh" "0 3 * * 1"
            echo System updates will be installed every Monday at 3am
            ;;
        99)
            # Install common packages
            ;;
        99)
            echo "Exiting..."
            exit 0
            ;;
        *)
            echo "Invalid choice, please try again."
            ;;
    esac
done

# Install docker

# if ! command -v docker &> /dev/null || ! sudo docker info &> /dev/null; then
#     # Install Docker GPG key
#     sudo install -m 0755 -d /etc/apt/keyrings
#     curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --yes --dearmor -o /etc/apt/keyrings/docker.gpg

#     # Add Docker repository
#     echo \
#       "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
#       $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
#       sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

#     # Update apt and install Docker packages
#     sudo apt-get update
#     sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
    
#     # run a little test
#     sudo docker run hello-world

#     echo "Docker: OK"
# else
#     echo "Docker: OK"
# fi

# Configure git

# Configure SSH
# ./sh/install.sh openssh-server ufw
# sudo ufw allow ssh -y
# sudo systemctl enable ssh --now
# - Generate an ed25519 key on the client machine if needed
# - Install vscode Remove/SSH extension(s) if needed
# - Edit vscode ssh config to include 
# something like:
# ```
# # Server
# Host odroid-h3p
#     HostName 192.168.0.186
#     User toaster
#     AddKeysToAgent yes
#     IdentityFile ~/.ssh/id_ed25519
# ```
# - Copy the contents of `.ssh/id_ed25519.pub` to the clipboard of the client machine
# - Connect to server via SSH outside of vscode and edit `~/.ssh/authorized_keys` to include the above public key
# - Run pallet command `Remote-SSH: Connect to Host…` and follow instructions for first time connection

# Uninstall GUI
# sudo systemctl set-default multi-user.target
# sudo systemctl stop gdm3
# sudo systemctl disable gdm3
# sudo apt-get remove -y --purge gnome-core
# sudo apt-get remove -y --purge kde-plasma-desktop
# sudo apt-get remove -y --purge xfce4
# sudo apt-get remove -y --purge lxde
# echo Reboot with "sudo reboot" to apply changes
