#!/bin/bash

# Prompt for the repository path
read -p "Enter the Git repository path: " repo_path

# Check if the path exists and is a valid Git repository
if [ ! -d "$repo_path/.git" ]; then
  echo "The specified path is not a Git repository. Please provide a valid repo path."
  exit 1
fi

# Change to the repository directory
cd "$repo_path" || exit

# Get the current branch name
current_branch=$(git rev-parse --abbrev-ref HEAD)

# Prompt for the branch to push changes to
read -p "Enter branch to push changes (default: $current_branch): " input_branch
branch=${input_branch:-$current_branch}

# Check for unstaged changes
changes=$(git status --porcelain)
unpushed_changes=$(git log origin/"$branch"..HEAD --oneline)

if [ -z "$changes" ] && [ -z "$unpushed_changes" ]; then
  echo "No changes detected. Exiting."
  exit 0
fi

# If there are committed but unpushed changes
if [ -z "$changes" ] && [ -n "$unpushed_changes" ]; then
  echo "You have unpushed commits:"
  echo "$unpushed_changes"
  read -p "Do you want to push these commits to branch '$branch'? (Y/n): " confirm_push
  confirm_push=${confirm_push:-Y}  # Default to "Y" if input is blank
  if [[ "$confirm_push" =~ ^[Yy]$ ]]; then
    echo "Pushing changes to branch '$branch'..."
    git push origin "$branch" && echo "Changes have been pushed to the remote repository." || echo "Push failed. Check your connection or permissions."
  else
    echo "Push cancelled. Changes remain committed locally."
  fi
  exit 0
fi

# Initialize commit counter
commit_counter=0

# Loop through each change and commit individually
echo "Processing changes..."
while IFS= read -r line; do
  # Extract status and file name, handling spaces correctly
  status=$(echo "$line" | awk '{print $1}')
  file=$(echo "$line" | awk '{print substr($0, index($0,$2))}' | sed 's/^ *//')

  # Debugging: Output the status and file to ensure correct handling
  echo "Processing file: \"$file\" with status: $status"

  # Remove any unwanted quotes around the file name
  file=$(echo "$file" | sed 's/^"\(.*\)"$/\1/')

  # Check if the file or directory exists
  if [ ! -e "$file" ] && [ "$status" != "D" ]; then
    echo "Warning: File or directory $file does not exist."
    continue
  fi

  # Determine commit message based on file status
  case "$status" in
  "A") # Added files (new files, untracked)
    commit_message="create $file"
    git add -- "$file"
    ;;
  "M") # Modified files
    commit_message="update $file"
    git add -- "$file"
    ;;
  "D") # Deleted files
    commit_message="delete $file"

    git rm --ignore-unmatch "$file"
    ;;
  "??") # Untracked files (new files)
    commit_message="create $file"
    git add -- "$file"
    ;;
  *) # Other statuses
    echo "Unknown status: $status for file: $file. Skipping."
    continue
    ;;
  esac

  # Commit the change
  echo "Committing: \"$commit_message\""
  git commit -m "$commit_message" && commit_counter=$((commit_counter + 1)) || {
    echo "Commit failed for file: $file"
    continue
  }

done <<<"$(git status --porcelain)"

# Check if there were no commits
if [ "$commit_counter" -eq 0 ]; then
  echo "No new changes to commit."
else
  echo "$commit_counter commit(s) have been successfully made."
fi

# Confirm pushing the changes
read -p "Do you want to push all changes to branch '$branch'? (Y/n): " confirm_push
confirm_push=${confirm_push:-Y}  # Default to "Y" if input is blank
if [[ "$confirm_push" =~ ^[Yy]$ ]]; then
  echo "Pushing changes to branch '$branch'..."
  git push origin "$branch" && echo "Changes have been pushed to the remote repository." || echo "Push failed. Check your connection or permissions."
else
  echo "Push cancelled. Changes remain committed locally."
fi
