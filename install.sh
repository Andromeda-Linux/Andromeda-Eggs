#!/bin/bash

# This script installs penguins-eggs on openSUSE
# Installs to /usr/lib/penguins-eggs/ with symlink to /usr/bin/eggs
# Intended for development purposes only

set -e

# Detect current username dynamically
USER_NAME=$(logname)

# Move to project directory if not already there
cd "$(dirname "$0")"

# Rename logo to eggs-logo.png if exists
if [ -f "Andromeda-Logo.png" ]; then
    mv Andromeda-Logo.png eggs-logo.png
fi

# Move logo to branding folder
if [ -f "/home/$USER_NAME/eggs-logo.png" ]; then
    mv "/home/$USER_NAME/eggs-logo.png" "/home/$USER_NAME/Andromeda-Eggs/addons/eggs/theme/calamares/branding/"
fi

# Define sudo or doas
if command -v sudo >/dev/null 2>&1; then
    SUDO='sudo'
else
    SUDO='doas'
fi

clear
echo "Installing penguins-eggs in /usr/lib/penguins-eggs/"

# Install nodejs if missing
if ! command -v node >/dev/null 2>&1; then
    echo "nodejs is not installed, installing it now..."
    $SUDO zypper install -y nodejs20
fi

# Install pnpm if missing
if ! command -v pnpm >/dev/null 2>&1; then
    echo "pnpm is not installed, installing it now..."
    $SUDO npm install -g pnpm
fi

# Install node modules if missing
if [ ! -d node_modules ]; then
    echo "Installing nodejs modules"
    rm -rf pnpm-lock.yaml dist
    pnpm i
fi

# Build project
pnpm build
xdg-user-dirs-update --force

# Install bash completions, icons, binaries, manpages
$SUDO cp scripts/eggs.bash /usr/share/bash-completion/completions/
$SUDO cp g4/* /usr/local/bin
$SUDO cp assets/eggs.png /usr/share/icons/
$SUDO mkdir -p /usr/share/man/man1
$SUDO cp manpages/doc/man/eggs.1.gz /usr/share/man/man1

# Place .desktop files on Desktop
DESKTOP_DIR=$(xdg-user-dir DESKTOP)
cp addons/eggs/adapt/applications/eggs-adapt.desktop "${DESKTOP_DIR}/"
cp assets/penguins-eggs.desktop "${DESKTOP_DIR}/"

# Make .desktop files executable with checksum metadata
for f in "$DESKTOP_DIR"/*.desktop; do 
    chmod +x "$f"
    gio set -t string "$f" metadata::xfce-exe-checksum "$(sha256sum "$f" | awk '{print $1}')"
done

# Remove existing installation
$SUDO rm -rf /usr/lib/penguins-eggs/
$SUDO mkdir -p /usr/lib/penguins-eggs/ 

# Copy files to /usr/lib/penguins-eggs
$SUDO cp -rf addons assets bin conf dist dracut eui ipxe manpages mkinitcpio mkinitfs node_modules /usr/lib/penguins-eggs/
$SUDO cp -f .oclif.manifest.json package.json pnpm-lock.yaml /usr/lib/penguins-eggs/
$SUDO cp -rf scripts syslinux /usr/lib/penguins-eggs/

# Link node binary
if [ ! -d /usr/lib/penguins-eggs/bin ]; then
    $SUDO mkdir -p /usr/lib/penguins-eggs/bin
fi
$SUDO ln -sf /usr/bin/node /usr/lib/penguins-eggs/bin/node

# Create eggs launcher script
cat << 'EOF' | $SUDO tee /usr/lib/penguins-eggs/bin/eggs > /dev/null
#!/usr/bin/env bash
set -e
echoerr() { echo "$@" 1>&2; }
get_script_dir () {
  SOURCE="${BASH_SOURCE[0]}"
  while [ -h "$SOURCE" ]; do
    DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
    SOURCE="$( readlink "$SOURCE" )"
    [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE"
  done
  DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
  echo "$DIR"
}
DIR=$(get_script_dir)
export PB_UPDATE_INSTRUCTIONS="update with \"sudo zypper refresh && sudo zypper up penguins-eggs\""
$DIR/node $DIR/run "$@"
EOF

# Make eggs launcher executable
$SUDO chmod +x /usr/lib/penguins-eggs/bin/eggs

# Symlink to /usr/bin/eggs
$SUDO ln -sf /usr/lib/penguins-eggs/bin/eggs /usr/bin/eggs

# Create symlink for code if code-oss exists but code doesn't
if [ -e /usr/bin/code-oss ] && [ ! -e /usr/bin/code ]; then
    $SUDO ln -s /usr/bin/code-oss /usr/bin/code
fi

# Initialize eggs config
sudo eggs config -n

echo "Installation completed successfully."
