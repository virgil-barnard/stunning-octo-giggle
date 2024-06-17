#!/bin/bash

# Generates SSH keys. If there are already keys present the user can overwrite with their own key. 

# To run: 
# 1) Make sure you have sudo with: 
#   su -
#   usermod -a -G sudo vboxuser
#   sudo reboot
# 2) Change permissions of this file to be an executable:
#   chmod +x setup_ssh_keys.sh
# 3) Execute the file with ./setup_ssh_keys.sh

# Check for existing SSH keys
echo "Checking for existing SSH keys..."
key_files=$(ls ~/.ssh/id_*.pub 2> /dev/null)

if [ -n "$key_files" ]; then
    echo "Existing SSH keys found:"
    for key_file in $key_files; do
        echo "----------------------------------"
        echo "Key file: $key_file"
        cat "$key_file"
        echo "----------------------------------"
    done

    read -p "Do you want to overwrite these keys with a new key? (yes/no): " overwrite_choice
    if [[ $overwrite_choice == [yY]es || $overwrite_choice == [yY] ]]; then
        echo "You chose to overwrite existing keys."
    else
        echo "You chose not to overwrite existing keys. Exiting script."
        exit 0
    fi
fi

# Prompt the user for their email address
read -p "Enter your email address for the new SSH key: " user_email

# Generate the SSH key
ssh-keygen -t ed25519 -C "$user_email"

# Print the generated SSH public key
echo "Your new SSH public key is:"
cat ~/.ssh/id_ed25519.pub



