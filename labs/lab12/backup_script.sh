#!/bin/bash
# Script to backup itself to a backup directory in home folder

# Create backup directory in home if it doesn't exist
BACKUP_DIR="$HOME/backup"
mkdir -p "$BACKUP_DIR"

# Get the script's filename
SCRIPT_NAME=$(basename "$0")

# Create a timestamp for the backup
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")

# Create backup filename with timestamp
BACKUP_FILE="$BACKUP_DIR/${SCRIPT_NAME}_${TIMESTAMP}.zip"

# Use zip to archive the script
zip -j "$BACKUP_FILE" "$0"

echo "Backup created: $BACKUP_FILE"