#!/bin/bash

# The directory you want to add to your PATH
dir_to_add="/home/akira/common-stuff/0-shell"

# Check if the directory exists
if [ ! -d "$dir_to_add" ]; then
  echo "Directory does not exist: $dir_to_add"
  echo "Please make sure the directory exists before proceeding."
  exit 1
fi

# Check if the directory is already in the PATH
if echo "$PATH" | grep -q "$dir_to_add"; then
  echo "The directory is already in your PATH."
else
  echo "Adding $dir_to_add to PATH..."

  # Add the directory to PATH in .bashrc
  echo "export PATH=\$PATH:$dir_to_add" >> ~/.bashrc

  # Reload the .bashrc to apply the changes immediately
  source ~/.bashrc

  echo "Directory $dir_to_add added to PATH."
fi

chmod 744 $dir_to_add/*

