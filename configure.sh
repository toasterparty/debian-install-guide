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
    echo "0) ALL OF THE BELOW"
    echo "1) Enable passwordless sudo"
    echo "2) Update packages"
    echo "3) Install common packages"
    echo "4) Update firmware"
    echo "5) Enable weekly system update"
    echo "6) Setup SSH"
    echo "7) Install Docker"
    echo "8) Configure git"
    echo "9) Uninstall GUI"
    echo "10) Exit"
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
            sudo fwupdmgr get-updates || :
            sudo fwupdmgr update || :
            echo "Done checking for firmware updates. A reboot may or may not be nececssary"
            ;;
        5)
            # Enable weekly system update
            $HOME/sh/cron.sh "update" "$HOME/sh/update.sh" "0 3 * * 1"
            echo System updates will be installed every Monday at 3am
            ;;
        6)
            IP=$(hostname -I | awk '{print $1}')
            MAC=$(ip -br link | grep $(ip -br addr show | awk -v ip="$IP" '$0 ~ ip {print $1}') | awk '{print $3}')

            # Setup SSH

            sudo ufw allow ssh
            sudo systemctl enable ssh --now

            echo ""
            echo "SSH server enabled and running. Please configure run configure-ssh.bat on the client PC for easy one-time SSH setup - otherwise you may use the following command to manually connect:"
            echo "    ssh $(logname)@$IP"
            echo ""
            echo "You should also consider setting up a static DHCP rule for $MAC to $IP so this does not change. This can be done in your router's web portal. If you would like to access this machine from an external network, it's recommended you create a port forward rule from a random external port to $IP:22."
            ;;
        7)
            # Install docker
            sudo install -m 0755 -d /etc/apt/keyrings
            sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
            sudo chmod a+r /etc/apt/keyrings/docker.asc

            echo \
            "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
            $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
            sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

            $SH/update.sh

            sudo apt-get install -m -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
            sudo docker run hello-world
            echo "Docker: OK"
            ;;
        8)
            # Configure git
            ;;
        9)
            # Uninstall GUI
            sudo systemctl set-default multi-user.target
            sudo systemctl stop gdm3
            sudo systemctl disable gdm3
            sudo apt-get remove -y --purge gnome-core
            sudo apt-get remove -y --purge kde-plasma-desktop
            sudo apt-get remove -y --purge xfce4
            sudo apt-get remove -y --purge lxde

            echo ""
            echo "GUI Uninstalled - Reboot with "sudo reboot" to apply changes"
            ;;
        10)
            echo "Exiting..."
            exit 0
            ;;
        *)
            echo "Invalid choice, please try again."
            ;;
    esac
done
