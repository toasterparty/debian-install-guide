#!/usr/bin/env bash

# Idempotently add a cron job to do this every Monday at 3am
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
SCRIPT_PATH=$(readlink -f "$0")

# cron.sh <job-name> <command> <frequency>
# (every monday at 3am)
# $SCRIPT_DIR/cron.sh "update" "$SCRIPT_PATH" "0 3 * * 1"
echo $SCRIPT_DIR/cron.sh "update" "$SCRIPT_PATH" "0 3 * * 1"

echo "Update system..."
sudo -qq apt-get update -y --allow-releaseinfo-change
sudo -qq apt-get --fix-broken install
sudo dpkg --configure -a
sudo -qq apt full-upgrade -y
sudo -qq apt-get clean -y
sudo -qq apt-get --purge autoremove -y
sudo -qq apt-get autoclean -y
echo "System update complete"
