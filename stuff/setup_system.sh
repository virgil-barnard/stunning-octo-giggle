#!/bin/bash

# To run: 
# 1) Make sure you have sudo with: 
#   su -
#   usermod -a -G sudo vboxuser
#   sudo reboot
# 2) Change permissions of this file to be an executable:
#   chmod +x setup_system.sh
# 3) Execute the file with ./setup_system.sh
# When you run a script with ./setup.sh, it executes in a new subshell. 
# This method is suitable for installation scripts like this because it prevents the main 
# shell's environment from being altered unexpectedly during the script's execution. 
# Any changes to the environment (like variable settings or function definitions) will 
# be limited to the script's subshell and won't affect your current shell. 
# However, changes made to files (like adding lines to .bashrc) will persist.

# Updating and upgrading packages at the beginning can be a good practice, 
# especially for a setup script on a new system. This ensures that your system 
# is up-to-date before you install new software, which can help avoid potential 
# conflicts with older versions of packages and libraries. 
# Also, some installations might depend on the latest versions of certain 
# packages or system libraries.

# Update and upgrade packages
sudo apt-get update
sudo apt-get upgrade -y

# General function to prompt for package installation
prompt_package_install() {
    local package=$1

    read -p "Do you want to install $package? (yes/no): " user_response
    case $user_response in
        [yY]es|[yY])
            echo "Installing $package..."
            if declare -f "$package" > /dev/null; then
                "$package"
            else
                echo "Installation function for $package not found."
            fi
            ;;
        [nN]o|[nN])
            echo "Skipping $package installation."
            ;;
        *)
            echo "Invalid response. Please answer 'yes' or 'no'."
            exit 1
            ;;
    esac
}

# Function to install Miniconda
Miniconda() {
    wget -O Mambaforge.sh "https://github.com/conda-forge/miniforge/releases/latest/download/Mambaforge-$(uname)-$(uname -m).sh"
    bash Mambaforge.sh -b -p "${HOME}/conda"
    rm Mambaforge.sh

    # Add Miniconda to PATH and activate conda in new terminals
    echo 'export PATH="$HOME/conda/bin:$PATH"' >> ~/.bashrc
    echo 'source ~/conda/bin/activate' >> ~/.bashrc

    # Reload .bashrc to apply changes in the current session
    source ~/.bashrc
}

# Function to install Docker
Docker() {
    sudo apt-get update
    sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
    sudo apt-get update
    sudo apt-get install -y docker-ce
    sudo systemctl start docker
    sudo systemctl enable docker
    echo "Docker installed successfully."
    
    # Add the current user to the Docker group
    sudo usermod -aG docker ${USER}

    echo "User ${USER} added to the Docker group. Please reboot for this to take effect."
    echo "Run 'docker run hello-world' to confirm the installation is complete."
}

DockerDesktop() {
    echo "Note that Docker Desktop inside a virtual machine requires nested virtualization."
    echo "In the Settings, System tab, ensure 'Enable Nested VT-x/AMD-V' is checked."
    echo "See: https://docs.docker.com/desktop/vm-vdi/"
    echo "Please download the latest Docker Desktop DEB package from the official Docker website."
    echo "Visit: https://www.docker.com/products/docker-desktop"
    echo "Once downloaded, please provide the full path to the DEB file."

    read -p "Enter the full path to the downloaded Docker Desktop DEB file: " docker_desktop_deb

    if [ -f "$docker_desktop_deb" ]; then
        sudo apt-get update
        sudo apt-get install -y "$docker_desktop_deb"
        echo "Docker Desktop should now be installed on your system."
    else
        echo "File not found at the provided path. Please check the path and try again."
    fi
}

# Function to install Docker Compose
DockerCompose() {
    # Install Docker Compose
    sudo curl -L "https://github.com/docker/compose/releases/download/v2.6.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose

    # Verify Installation
    docker-compose --version

    echo "Docker Compose installed successfully."
}

# Function to install net-tools and run ifconfig
NetTools() {
    sudo apt-get install -y net-tools
    echo "net-tools installed successfully."
    echo "Running ifconfig..."
    ifconfig
}

# Function to install Neo4j
Neo4j() {
    wget -O - https://debian.neo4j.com/neotechnology.gpg.key | sudo apt-key add -
    echo 'deb https://debian.neo4j.com stable 4.4' | sudo tee -a /etc/apt/sources.list.d/neo4j.list
    sudo apt-get update
    sudo apt-get install -y neo4j

    echo "Neo4j installed successfully."
    echo "You can start Neo4j using 'sudo systemctl start neo4j' and access it on http://localhost:7474"
}

# Function to install Clang
Clang() {
    sudo apt-get update
    sudo apt-get install -y clang
    echo "Clang installation completed."
}

echo "Your architectuer is: "
uname -m

# Call the function to prompt for Miniconda installation
prompt_package_install "Miniconda"

# Call the function to prompt for Docker installation
prompt_package_install "Docker"

# Call the function to prompt for DockerDesktop installation
prompt_package_install "DockerDesktop"

# Call the function to prompt for Docker Compose installation
prompt_package_install "DockerCompose"

# Call the function to prompt for net-tools installation and running ifconfig
prompt_package_install "NetTools"

# Call the function to prompt for Neo4j installation
prompt_package_install "Neo4j"

# Call the function to prompt for Clang installation
prompt_package_install "Clang"

echo "System built. You must restart your terminal for all installs to take effect."

