#!/bin/bash
# Script to create numbered files or delete them
# Usage: ./file_manager.sh -n <number_of_files> (to create)
#        ./file_manager.sh -d (to delete created files)

# Default values
NUM_FILES=0
DELETE_MODE=false

# Parse command line arguments
while getopts "n:d" opt; do
    case $opt in
        n)
            NUM_FILES=$OPTARG
            ;;
        d)
            DELETE_MODE=true
            ;;
        \?)
            echo "Usage: $0 -n <number_of_files> (to create files)"
            echo "       $0 -d (to delete created files)"
            echo "Example: $0 -n 5 (creates 1.tmp, 2.tmp, ..., 5.tmp)"
            echo "         $0 -d (deletes all *.tmp files created by this script)"
            exit 1
            ;;
        :)
            echo "Option -$OPTARG requires an argument." >&2
            exit 1
            ;;
    esac
done

# Check if we're in delete mode
if [ "$DELETE_MODE" = true ]; then
    # Delete all numbered tmp files
    echo "Deleting all numbered .tmp files..."
    
    # Find and delete numbered tmp files (e.g., 1.tmp, 2.tmp, etc.)
    for file in [0-9]*.tmp; do
        if [ -f "$file" ]; then
            rm "$file"
            echo "Deleted: $file"
        fi
    done
    
    # Also try with multiple digits
    for file in [0-9]*[0-9]*.tmp; do
        if [ -f "$file" ]; then
            rm "$file"
            echo "Deleted: $file"
        fi
    done
    
    echo "Deletion completed."
else
    # Check if number of files is provided
    if [ $NUM_FILES -le 0 ]; then
        echo "Error: Please specify a positive number of files to create using -n option."
        echo "Usage: $0 -n <number_of_files>"
        exit 1
    fi
    
    # Create numbered files
    echo "Creating $NUM_FILES numbered .tmp files..."
    
    for ((i=1; i<=NUM_FILES; i++)); do
        filename="${i}.tmp"
        touch "$filename"
        echo "Created: $filename"
    done
    
    echo "Creation completed."
fi