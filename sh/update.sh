#!/usr/bin/env bash

# Idempotently add a cron job to do this every Monday at 3am
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
SCRIPT_PATH=$(readlink -f "$0")

# cron.sh <job-name> <command> <frequency>
# (every monday at 3am)
$SCRIPT_DIR/cron.sh "update" "$SCRIPT_PATH" "0 3 * * 1"

sudo apt-get update -y --allow-releaseinfo-change
sudo apt-get --fix-broken install
sudo dpkg --configure -a
sudo apt full-upgrade -y
sudo apt-get clean -y
sudo apt-get --purge autoremove -y
sudo apt-get autoclean -y
