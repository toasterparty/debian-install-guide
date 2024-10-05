#!/usr/bin/env bash
set -e

HOST="https://toasterparty.github.io/debian-setup-guide"

# Enable Passwordless sudo

LINE='%sudo ALL=(ALL) NOPASSWD: ALL'
FILEPATH='/etc/sudoers'
sudo grep -xsqF "$LINE" "$FILEPATH" || echo "$LINE" | sudo tee -a "$FILEPATH"
echo "Passwordless Sudo: OK"

# Download util script

FILENAMES=("update.sh" "cron.sh")
for FILENAME in "${FILENAMES[@]}"; do
    FILEPATH=$HOME/sh/$FILENAME
    wget -nv -N -O $FILEPATH $HOST/sh/$FILENAME
    chmod +x $FILEPATH
    echo "~/sh/$FILENAME OK"
done

# Initial Update

$HOME/sh/update.sh
