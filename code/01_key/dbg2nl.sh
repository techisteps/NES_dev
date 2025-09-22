#!/bin/bash

# Usage: ./dbg2nl.sh input.dbg > output.nl

if [ -z "$1" ]; then
  echo "Usage: $0 input.dbg"
fi


grep "^sym" "$1" | while IFS= read -r line; do
    # Extract addrsize
    addrsize=$(echo "$line" | grep -o 'addrsize=[^,]*' | cut -d= -f2)

    if [ "$addrsize" = "absolute" ]; then
        # Extract name and val
        name=$(echo "$line" | grep -o 'name="[^"]*"' | cut -d'"' -f2)
        val=$(echo "$line" | grep -o 'val=0x[0-9A-Fa-f]*' | cut -d= -f2)

        # Format val to $xxxx
        hexval="\$${val:2}"

        echo "${hexval}#${name}#"

    fi

    # # Extract symbol name and address
    # name=$(echo "$line" | cut -d',' -f2)
    # addr=$(echo "$line" | cut -d',' -f4)

    # # Convert address to uppercase hex format
    # printf "%04X %s\n" "$addr" "$name"    
done