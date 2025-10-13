#!/bin/bash
# Script to create tar archive of files in a directory
# Option 1: Archive all files in a directory
# Option 2: Archive only files modified less than a week ago

# Check if directory argument is provided
if [ $# -lt 1 ]; then
    echo "Usage: $0 <directory_path> [modified]"
    echo "  <directory_path> : Path to the directory to archive"
    echo "  [modified]       : Optional flag to archive only files modified less than a week ago"
    echo "Example: $0 /home/user/documents"
    echo "         $0 /home/user/documents modified"
    exit 1
fi

DIRECTORY=$1
MODIFIED_FLAG=$2

# Check if directory exists
if [ ! -d "$DIRECTORY" ]; then
    echo "Error: Directory $DIRECTORY does not exist"
    exit 1
fi

# Get directory name for archive name
DIR_NAME=$(basename "$DIRECTORY")
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
ARCHIVE_NAME="${DIR_NAME}_${TIMESTAMP}.tar.gz"

if [ "$MODIFIED_FLAG" = "modified" ]; then
    # Archive only files modified less than a week ago
    echo "Creating archive of files modified less than a week ago in $DIRECTORY..."
    
    # Find files modified less than 7 days ago and create archive
    find "$DIRECTORY" -type f -mtime -7 -print0 | tar --null --files-from=- -czf "$ARCHIVE_NAME"
    
    if [ $? -eq 0 ]; then
        echo "Archive created successfully: $ARCHIVE_NAME"
        echo "Files in archive:"
        tar -tzf "$ARCHIVE_NAME" | head -20  # Show first 20 files
        if [ $(tar -tzf "$ARCHIVE_NAME" | wc -l) -gt 20 ]; then
            echo "... and $(($(tar -tzf "$ARCHIVE_NAME" | wc -l) - 20)) more files"
        fi
    else
        echo "Error creating archive"
        exit 1
    fi
else
    # Archive all files in the directory
    echo "Creating archive of all files in $DIRECTORY..."
    
    tar -czf "$ARCHIVE_NAME" -C "$(dirname "$DIRECTORY")" "$(basename "$DIRECTORY")"
    
    if [ $? -eq 0 ]; then
        echo "Archive created successfully: $ARCHIVE_NAME"
        echo "Directory structure in archive:"
        tar -tzf "$ARCHIVE_NAME" | head -20  # Show first 20 entries
        if [ $(tar -tzf "$ARCHIVE_NAME" | wc -l) -gt 20 ]; then
            echo "... and $(($(tar -tzf "$ARCHIVE_NAME" | wc -l) - 20)) more entries"
        fi
    else
        echo "Error creating archive"
        exit 1
    fi
fi