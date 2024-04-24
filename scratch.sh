#!/bin/bash
input_directory=$1
output_directory=$2
if [ ! -d "$output_directory" ]; then
    mkdir -p "$output_directory"
fi
copy_and_rename_files() {
    local src_dir="$1"
    local dest_dir="$2"
    local files=("$src_dir"/*)
    for file in "${files[@]}"; do
        if [ -d "$file" ]; then
            copy_and_rename_files "$file" "$dest_dir"
        elif [ -f "$file" ]; then
            filename=$(basename -- "$file")
            dest_file="$dest_dir/${filename}"
            if [ -f "$dest_file" ]; then
                i=1
                while [ -f "$dest_dir/($i) ${filename}" ]; do
                    ((i++))
                done
                cp "$file" "$dest_dir/($i) ${filename} "
            else
                cp "$file" "$dest_file"
            fi
        fi
    done
}
copy_and_rename_files "$input_directory" "$output_directory"