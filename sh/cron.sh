#!/bin/bash
set -e

# Validate number of arguments
if [ "$#" -ne 3 ]; then
    echo "Usage: $0 <job-name> <command> <frequency>"
    exit 1
fi

JOB_NAME=$1
COMMAND=$2
FREQUENCY=$3
LOG_DIR="$HOME/logs"
LOG_FILE="$LOG_DIR/$JOB_NAME.log"

# Ensure log directory exists
mkdir -p "$LOG_DIR"

# Escape the special characters in command and frequency for use in sed expressions
ESCAPED_COMMAND=$(echo "$COMMAND" | sed 's/[&/\]/\\&/g')
ESCAPED_FREQUENCY=$(echo "$FREQUENCY" | sed 's/[&/\]/\\&/g')

# Prepare cron job line with log redirection
CRON_JOB="$FREQUENCY $COMMAND >> $LOG_FILE 2>&1"

# Check for existing cron job
EXISTING_JOB=$(crontab -l | grep "# $JOB_NAME$")

if [ -z "$EXISTING_JOB" ]; then
    # No existing job, add new
    (crontab -l 2>/dev/null; echo "$CRON_JOB # $JOB_NAME") | crontab -
    echo "Cron job '$JOB_NAME' added successfully."
else
    # Existing job found, replace it
    (crontab -l | grep -v "# $JOB_NAME$" | sed "/$ESCAPED_COMMAND/d"; echo "$CRON_JOB # $JOB_NAME") | crontab -
    echo "Cron job '$JOB_NAME' updated successfully."
fi
