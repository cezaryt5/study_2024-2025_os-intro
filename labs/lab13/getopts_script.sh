#!/bin/bash
# Script using getopts to parse command line options:
# -i<inputfile> — read data from specified file
# -o<outputfile> — output data to specified file
# -p<pattern> — specify pattern for search
# -C — distinguish uppercase and lowercase
# -n — output line numbers

# Initialize variables
INPUT_FILE=""
OUTPUT_FILE=""
PATTERN=""
CASE_SENSITIVE=false
SHOW_LINE_NUMBERS=false

# Parse command line options
while getopts "i:o:p:Cn" opt; do
    case $opt in
        i)
            INPUT_FILE="$OPTARG"
            ;;
        o)
            OUTPUT_FILE="$OPTARG"
            ;;
        p)
            PATTERN="$OPTARG"
            ;;
        C)
            CASE_SENSITIVE=true
            ;;
        n)
            SHOW_LINE_NUMBERS=true
            ;;
        \?)
            echo "Usage: $0 -i<inputfile> -o<outputfile> -p<pattern> [-C] [-n]" >&2
            echo "  -i<inputfile>   Read data from specified file" >&2
            echo "  -o<outputfile>  Output data to specified file" >&2
            echo "  -p<pattern>     Specify pattern for search" >&2
            echo "  -C              Distinguish uppercase and lowercase" >&2
            echo "  -n              Output line numbers" >&2
            exit 1
            ;;
        :)
            echo "Option -$OPTARG requires an argument." >&2
            exit 1
            ;;
    esac
done

# Check if required arguments are provided
if [ -z "$INPUT_FILE" ] || [ -z "$OUTPUT_FILE" ] || [ -z "$PATTERN" ]; then
    echo "Error: All options -i, -o, and -p are required." >&2
    echo "Usage: $0 -i<inputfile> -o<outputfile> -p<pattern> [-C] [-n]" >&2
    exit 1
fi

# Check if input file exists
if [ ! -f "$INPUT_FILE" ]; then
    echo "Error: Input file $INPUT_FILE does not exist." >&2
    exit 1
fi

# Prepare grep options
GREP_OPTIONS=""

if [ "$CASE_SENSITIVE" = false ]; then
    GREP_OPTIONS="$GREP_OPTIONS -i"
fi

if [ "$SHOW_LINE_NUMBERS" = true ]; then
    GREP_OPTIONS="$GREP_OPTIONS -n"
fi

# Perform the search and output to the specified file
grep $GREP_OPTIONS "$PATTERN" "$INPUT_FILE" > "$OUTPUT_FILE"

echo "Search completed. Results saved to $OUTPUT_FILE"