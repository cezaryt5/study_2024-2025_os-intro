#!/bin/bash
# Script to count files by extension in a specified directory

# Check if correct number of arguments provided
if [ $# -ne 2 ]; then
    echo "Usage: $0 <file_extension> <directory_path>"
    echo "Example: $0 .txt /home/user/documents"
    exit 1
fi

# Get arguments
EXTENSION=$1
DIRECTORY=$2

# Check if directory exists
if [ ! -d "$DIRECTORY" ]; then
    echo "Error: Directory $DIRECTORY does not exist"
    exit 1
fi

# Count files with the specified extension
# Using find to locate files, then counting them
COUNT=$(find "$DIRECTORY" -type f -name "*$EXTENSION" | wc -l)

echo "Number of files with extension $EXTENSION in $DIRECTORY: $COUNT"

# Optionally, list the files found
echo ""
echo "Files found:"
find "$DIRECTORY" -type f -name "*$EXTENSION"