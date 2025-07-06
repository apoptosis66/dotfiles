#!/bin/bash

# Source directory
source_dir="$HOME/.local/share/7DaysToDie/"
source_folder1="Saves"
source_folder2="LocalPrefabs"

# Backup directory
backup_dir="$HOME/7dtd/"

# Check if source directory exists
if [ ! -d "$source_dir" ]; then
  echo "Error: Source directory '$source_dir' not found."
  exit 1
fi

# Check if backup directory exists, create it if it doesn't
if [ ! -d "$backup_dir" ]; then
  echo "Error: Backup directory '$backup_dir' not found."
  exit 1
fi

# Create timestamped backup directory name
timestamp=$(date +%Y-%m-%d-%H-%M-%S)
backup_name1="$backup_dir/$timestamp"_"$source_folder1"
backup_name2="$backup_dir/$timestamp"_"$source_folder2"

# Create the backup (using rsync for efficient copying)
rsync -ah "$source_dir$source_folder1/" "$backup_name1"
rsync -ah "$source_dir$source_folder2/" "$backup_name2"

if [ $? -eq 0 ]; then # Check if rsync was successful.
    echo "Backup created: $backup_name1"
else
    echo "Error: Backup failed."
    exit 1
fi

# Keep only the last 10 backups
find "$backup_dir" -maxdepth 1 -type d -name "*_$source_folder1" | sort -r | tail -n +6 | xargs rm -rf
find "$backup_dir" -maxdepth 1 -type d -name "*_$source_folder2" | sort -r | tail -n +6 | xargs rm -rf

if [ $? -eq 0 ]; then # Check if cleanup was successful.
    echo "Old backups removed."
else
    echo "Error: Could not remove old backups. Check permissions."
    exit 1
fi

echo "Backup process complete."

exit 0
