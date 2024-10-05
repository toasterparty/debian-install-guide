#!/usr/bin/env bash

# Idempotently add a cron job to do this every Monday at 3am
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
SCRIPT_PATH=$(readlink -f "$0")

# cron.sh <job-name> <command> <frequency>
# (every monday at 3am)
$SCRIPT_DIR/cron.sh "update" "$SCRIPT_PATH" "0 3 * * 1"

echo "Update system..."
sudo apt-get -qq update -y --allow-releaseinfo-change
sudo apt-get -qq --fix-broken install
sudo dpkg --configure -a
sudo apt-get -qq full-upgrade -y
sudo apt-get -qq clean -y
sudo apt-get -qq --purge autoremove -y
sudo apt-get -qq autoclean -y
echo "System update complete"
