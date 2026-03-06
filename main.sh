#!/bin/bash
set -e

# detect distro
if [ -f /etc/arch-release ]; then
    DISTRO="arch"
elif [ -f /etc/fedora-release ]; then
    DISTRO="fedora"
else
    echo "Unsupported distro"
    exit 1
fi

# download the correct script
TMP_SCRIPT=$(mktemp)
curl -fsSL "https://raw.githubusercontent.com/ios7jbpro/fedintosh/main/scripts/$DISTRO.sh" -o "$TMP_SCRIPT"

# optionally inspect/edit before running
echo "Downloaded installer: $TMP_SCRIPT"
chmod +x "$TMP_SCRIPT"

# run it interactively
"$TMP_SCRIPT"
