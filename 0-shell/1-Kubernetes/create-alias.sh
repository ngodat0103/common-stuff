#!/bin/bash

# Define the alias and the command
ALIAS_NAME="ksetns"
ALIAS_COMMAND='alias ksetns="kubectl config set-context --current --namespace"'

# Path to the .bashrc file
BASHRC_FILE="$HOME/.bashrc"

# Check if the alias already exists in the .bashrc file
if grep -q "$ALIAS_NAME=" "$BASHRC_FILE"; then
    echo "Alias '$ALIAS_NAME' already exists in $BASHRC_FILE."
else
    # Add the alias to the .bashrc file
    echo "$ALIAS_COMMAND" >> "$BASHRC_FILE"
    echo "Alias '$ALIAS_NAME' added to $BASHRC_FILE."
    
    # Reload the .bashrc file to apply changes
    source "$BASHRC_FILE"
    echo "$ALIAS_NAME alias is now available."
fi

