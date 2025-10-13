#!/bin/bash
# Script to mimic ls command without using ls or dir

# Default to current directory if no argument provided
DIRECTORY="${1:-.}"

# Check if directory exists
if [ ! -d "$DIRECTORY" ]; then
    echo "Error: $DIRECTORY is not a directory" >&2
    exit 1
fi

# Print directory contents with permissions
for item in "$DIRECTORY"/*; do
    # Remove directory path from item name for display
    basename_item=$(basename "$item")
    
    # Get file permissions, owner, size, and modification time
    if [ -e "$item" ]; then  # Check if the item actually exists (in case of glob with no matches)
        permissions=$(stat -c "%A" "$item" 2>/dev/null || stat -f "%Sp" "$item" 2>/dev/null)
        owner=$(stat -c "%U" "$item" 2>/dev/null || stat -f "%Su" "$item" 2>/dev/null)
        size=$(stat -c "%s" "$item" 2>/dev/null || stat -f "%z" "$item" 2>/dev/null)
        mod_time=$(stat -c "%y" "$item" 2>/dev/null || stat -f "%Sm" "$item" 2>/dev/null)
        
        # Show different indicators for different file types
        if [ -d "$item" ]; then
            type_indicator="d"
            name_with_indicator="$basename_item/"
        elif [ -L "$item" ]; then
            type_indicator="l"
            name_with_indicator="$basename_item@ -> $(readlink "$item")"
        elif [ -x "$item" ]; then
            type_indicator="-"
            name_with_indicator="$basename_item*"
        else
            type_indicator="-"
            name_with_indicator="$basename_item"
        fi
        
        printf "%-10s %-10s %8s %s %s\n" "$permissions" "$owner" "$size" "$mod_time" "$name_with_indicator"
    fi
done

# Also show hidden files (those starting with .)
for item in "$DIRECTORY"/.*; do
    basename_item=$(basename "$item")
    
    # Skip current directory (.) and parent directory (..)
    if [ "$basename_item" != "." ] && [ "$basename_item" != ".." ]; then
        if [ -e "$item" ]; then
            permissions=$(stat -c "%A" "$item" 2>/dev/null || stat -f "%Sp" "$item" 2>/dev/null)
            owner=$(stat -c "%U" "$item" 2>/dev/null || stat -f "%Su" "$item" 2>/dev/null)
            size=$(stat -c "%s" "$item" 2>/dev/null || stat -f "%z" "$item" 2>/dev/null)
            mod_time=$(stat -c "%y" "$item" 2>/dev/null || stat -f "%Sm" "$item" 2>/dev/null)
            
            if [ -d "$item" ]; then
                type_indicator="d"
                name_with_indicator="$basename_item/"
            elif [ -L "$item" ]; then
                type_indicator="l"
                name_with_indicator="$basename_item@ -> $(readlink "$item")"
            elif [ -x "$item" ]; then
                type_indicator="-"
                name_with_indicator="$basename_item*"
            else
                type_indicator="-"
                name_with_indicator="$basename_item"
            fi
            
            printf "%-10s %-10s %8s %s %s\n" "$permissions" "$owner" "$size" "$mod_time" "$name_with_indicator"
        fi
    fi
done