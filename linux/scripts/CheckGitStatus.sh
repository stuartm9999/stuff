#!/bin/bash

ROOT_DIR="${1:-.}"

check_git_repo() {
    local repo_dir="$1"
    
    # Make sure the directory exists
    if [[ ! -d "$repo_dir" ]]; then
        echo "Directory does not exist: $repo_dir"
        return
    fi

    cd "$repo_dir" || return

    # Check for uncommitted changes
    if [[ -n $(git status --porcelain 2>/dev/null) ]]; then
        echo "Uncommitted changes in: $repo_dir"
    fi

    # Check for commits not pushed to remote
    upstream=$(git rev-parse --abbrev-ref --symbolic-full-name @{u} 2>/dev/null)
    if [[ $? -eq 0 ]]; then
        behind=$(git rev-list --count HEAD.."$upstream" 2>/dev/null)
        if [[ "$behind" -ne 0 ]]; then
            echo "Commits not pushed in: $repo_dir"
        fi
    else
        echo "No upstream set for: $repo_dir"
    fi
}

export -f check_git_repo

# Use find safely with null separator for spaces
find "$ROOT_DIR" -type d -name ".git" -print0 | while IFS= read -r -d '' gitdir; do
    repo_dir=$(dirname "$gitdir")
    check_git_repo "$repo_dir"
done

