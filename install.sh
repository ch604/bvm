#!/bin/bash
# bvm - bash version manager
# v1.0.3
# github.com/ch604/bvm

set -u -o pipefail

BVM_INSTALLDIR="$HOME/.bvm"

echo "Installing BVM to $BVM_INSTALLDIR ..."

# make and populate our install dir
mkdir -p "$BVM_INSTALLDIR"
wget -q https://raw.githubusercontent.com/ch604/bvm/refs/heads/main/functions.sh -P "$BVM_INSTALLDIR"

# make our rc file and include it
wget -q https://raw.githubusercontent.com/ch604/bvm/refs/heads/main/.bash_bvm -P "$BVM_INSTALLDIR"
sed -i 's|\(BVM_INSTALLDIR=\)_____|\1"'"$BVM_INSTALLDIR"'"|' "$BVM_INSTALLDIR/.bash_bvm"
! grep -q "bash version manager" "$HOME/.bashrc" && echo -e "\n#added by bash version manager\n[ -f $BVM_INSTALLDIR/.bash_bvm ] && . $BVM_INSTALLDIR/.bash_bvm" >> "$HOME/.bashrc"

echo "Done! Re-source your ~/.bashrc and run \`bvm -h\` to begin your first install."