#!/bin/bash
#This file creates default trivy ignore files

# Loop over all directories (non-recursive) from current directory
for dir in charts/*; do
    # Check if it's a directory
    if [[ -d "$dir" ]]; then
        # If there is no .trivyignore file in the directory
        if [[ ! -f "$dir/.trivyignore" ]]; then
            # Create .trivyignore file
            touch "$dir/.trivyignore"
            echo "Created .trivyignore in $dir"  # Optional: prints out where the file was created
        fi
    fi
done
