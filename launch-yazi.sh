#!/bin/bash

# Set the working directory
cd "$HOME/.config/wezterm" || exit 1

# Check if the eee-yazi.sh script exists
if [ ! -f "$HOME/.emacs.d/.local/straight/build-30.1/eee/eee-yazi.sh" ]; then
  echo "Error: eee-yazi.sh script not found"
  exit 1
fi

# Run the script with proper error handling
"$HOME/.emacs.d/.local/straight/build-30.1/eee/eee-yazi.sh" "$HOME/.config/wezterm" > /tmp/ee-stdout-ee-yazi-project.tmp 2>&1 