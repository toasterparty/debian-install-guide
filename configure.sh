#!/usr/bin/env bash
set -e

# Idempotently permit all sudo-enabled users the use of "sudo" without having to type in a password
LINE='%sudo ALL=(ALL) NOPASSWD: ALL'
FILE='/etc/sudoers'
sudo grep -xsqF "$LINE" "$FILE" ||  echo "$LINE" | sudo tee -a "$FILE"

if sudo grep -xsqF "$LINE" "$FILE"; then
    echo "Passwordless Sudo: OK"
else
    read -p "Enable Passwordless Sudo (Y/n): " response
    response=${response:-Y} 
    if [[ $response =~ ^[Yy]$ ]] || [ -z "$response" ]; then
        echo "$line" | sudo tee -a "$file" > /dev/null
        echo "Passwordless Sudo: OK"
    fi
fi
