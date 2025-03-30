#!/bin/bash

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Print colored message
print_message() {
    echo -e "${BLUE}[Setup] ${GREEN}$1${NC}"
}

print_error() {
    echo -e "${BLUE}[Setup] ${RED}$1${NC}"
}

# Check if running as root
if [ "$EUID" -ne 0 ]; then 
    print_error "Please run as root or with sudo"
    exit 1
fi

# Detect OS
if [ -f /etc/os-release ]; then
    . /etc/os-release
    OS=$NAME
else
    print_error "Cannot detect OS"
    exit 1
fi

# Install Python 3.11 based on OS
install_python() {
    case $OS in
        "Ubuntu" | "Debian GNU/Linux")
            print_message "Installing Python 3.11 on Ubuntu/Debian..."
            apt-get update
            apt-get install -y software-properties-common
            add-apt-repository -y ppa:deadsnakes/ppa
            apt-get update
            apt-get install -y python3.11 python3.11-venv python3.11-dev
            ;;
            
        "CentOS Linux" | "Red Hat Enterprise Linux")
            print_message "Installing Python 3.11 on CentOS/RHEL..."
            yum install -y gcc openssl-devel bzip2-devel libffi-devel
            wget https://www.python.org/ftp/python/3.11.0/Python-3.11.0.tgz
            tar xzf Python-3.11.0.tgz
            cd Python-3.11.0
            ./configure --enable-optimizations
            make altinstall
            cd ..
            rm -rf Python-3.11.0 Python-3.11.0.tgz
            ;;
            
        *)
            print_error "Unsupported operating system: $OS"
            exit 1
            ;;
    esac
}

# Set Python 3.11 as default
set_python_default() {
    print_message "Setting Python 3.11 as default..."
    
    # Update alternatives
    update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.11 1
    update-alternatives --set python3 /usr/bin/python3.11
    
    # Install pip for Python 3.11
    curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
    python3.11 get-pip.py
    rm get-pip.py
    
    # Install essential packages
    python3.11 -m pip install --upgrade pip setuptools wheel
}

# Verify installation
verify_installation() {
    print_message "Verifying Python installation..."
    
    if command -v python3.11 &> /dev/null; then
        VERSION=$(python3.11 --version)
        print_message "Python 3.11 installed successfully: $VERSION"
        
        PIP_VERSION=$(pip3 --version)
        print_message "pip version: $PIP_VERSION"
    else
        print_error "Python 3.11 installation failed"
        exit 1
    fi
}

# Main execution
main() {
    print_message "Starting Python 3.11 installation..."
    install_python
    set_python_default
    verify_installation
    print_message "Installation complete!"
    print_message "Please log out and log back in for changes to take effect."
}

# Run the script
main 