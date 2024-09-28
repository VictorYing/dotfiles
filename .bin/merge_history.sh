#!/bin/bash

# Combine each timestamp with its corresponding command into one line
combined_file=$(mktemp)
for histfile in ${DOTFILES_HOME}/.bash/histories/* ~/.bash_history; do
    [ -f "$histfile" ] || continue;
    awk 'NR%2{printf "%s ",$0;next;}1' "$histfile" >> "$combined_file"
done

# Sort by timestamp and uniq
sorted_file=$(mktemp)
sort -u "$combined_file" > "$sorted_file"

# Split the combined lines back into the original format
awk '{print $1; sub($1" ",""); print}' "$sorted_file" > ~/.bash_history

rm "$combined_file" "$sorted_file"
