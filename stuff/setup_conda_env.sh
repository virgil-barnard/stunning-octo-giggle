#!/bin/bash

# To run: 
# 1) Make sure you have sudo with: 
#   su -
#   usermod -a -G sudo vboxuser
#   sudo reboot
# 2) Change permissions of this file to be an executable:
#   chmod +x setup_conda_env.sh
# 3) Execute the file with ./setup_conda_env.sh

prompt_install_pip_package() {
    local package_name=$1
    read -p "Do you want to install the pip package '$package_name'? (yes/no): " install_choice

    if [[ $install_choice == [yY]es || $install_choice == [yY] ]]; then
        pip install "$package_name"
        echo "Package '$package_name' installed."
    else
        echo "Skipped installation of '$package_name'."
    fi
}

# Prompt for environment name and Python version
read -p "Enter the name for the new Conda environment: " env_name
read -p "Enter the Python version (e.g., 3.8): " python_version

# Create the Conda environment
conda create -n "$env_name" python="$python_version" -y
echo "Conda environment '$env_name' created with Python $python_version."

# Activate the environment
source activate "$env_name"
echo "Activated environment '$env_name'."

# Ask if the user wants to install default packages
prompt_install_pip_package "jupyterlab"

prompt_install_pip_package "matplotlib"

prompt_install_pip_package "scikit-learn"

echo "Finished creating environment. Run conda activate '$env_name' to start the environment."

