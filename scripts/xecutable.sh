#!/bin/bash

# Make files executable
files=(
    1.sh                                                                                                                                                                                           2.sh
    3.sh
    gnomeInstall.sh
    setup.sh
)

for file in "${files[@]}"; do
    if [[ -f "$file" ]]; then
        chmod +x "$file"
        echo "$file is now executable."
    else
        echo "$file does not exist."
    fi
done

