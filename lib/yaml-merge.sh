#!/usr/bin/env bash

# ============================================
# YAML Merge Utility
# ============================================
# Simple YAML merger using yq (if available) or basic cat

set -euo pipefail

merge_yaml() {
    local output_file=$1
    shift
    local input_files=("$@")

    # Check if yq is available
    if command -v yq &>/dev/null; then
        # Use yq for intelligent merge
        log_info "Using yq for YAML merge"

        local merged="${input_files[0]}"
        for file in "${input_files[@]:1}"; do
            if [ -f "$file" ]; then
                merged=$(yq eval-all 'select(fileIndex == 0) * select(fileIndex == 1)' <(echo "$merged") "$file")
            fi
        done

        echo "$merged" > "$output_file"
    else
        # Fallback: simple concatenation with separator
        log_warning "yq not found, using simple concatenation"
        log_info "For better merging, install yq: brew install yq"

        > "$output_file"  # Clear file

        for file in "${input_files[@]}"; do
            if [ -f "$file" ]; then
                echo "# ===== Merged from: $file =====" >> "$output_file"
                cat "$file" >> "$output_file"
                echo "" >> "$output_file"
            fi
        done
    fi
}

# If sourced, make function available
# If executed directly, run with args
if [ "${BASH_SOURCE[0]}" = "${0}" ]; then
    if [ $# -lt 2 ]; then
        echo "Usage: $0 <output_file> <input_file1> [input_file2] ..."
        exit 1
    fi

    merge_yaml "$@"
fi
