#!/bin/bash
# Script to handle arbitrary number of arguments

echo "Number of arguments: $#"

# Using a for loop to iterate through all arguments
counter=1
for arg in "$@"; do
    echo "Argument $counter: $arg"
    ((counter++))
done

# Alternative method using while loop
echo ""
echo "Using while loop method:"
index=1
while [ $index -le $# ]; do
    eval "current_arg=\${$index}"
    echo "Argument $index: $current_arg"
    ((index++))
done