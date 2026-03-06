#!/bin/bash
# detect distro and fetch the right installer
set -e

# basic distro detection
if [ -f /etc/arch-release ]; then
    DISTRO="arch"
elif [ -f /etc/fedora-release ]; then
    DISTRO="fedora"
else
    echo "Unsupported distro"
    exit 1
fi

# fetch and execute the proper script
curl -fsSL "https://raw.githubusercontent.com/ios7jbpro/fedintosh/main/scripts/$DISTRO.sh" | bash
