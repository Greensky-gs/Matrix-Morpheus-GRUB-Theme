#!/bin/bash
# ===============================================================
# Matrix Morpheus GRUB Theme Installer
# Repository: https://github.com/Greensky-gs/Matrix-GRUB-Theme
# Forked from: https://github.com/Priyank-Adhav/Matrix-Morpheus-GRUB-Theme
# ===============================================================

set -e

THEME_NAME="Matrix"
THEME_DIR="/boot/grub/themes"
GRUB_CFG="/etc/default/grub"
GRUB_FILE="/boot/grub/grub.cfg"

echo ""
echo "==========================="
echo "Installer theme GRUB Matrix"
echo "==========================="
echo ""

# Check for root privileges
if [ "$EUID" -ne 0 ]; then
	echo "Veuillez exécuter le script en administrateur (sudo)."
    exit 1
fi

if [ "$1" == "cachy" ]; then
	THEME_NAME="Matrix_Cachy"
	echo "Installation du theme Cachy OS"
elif [ "$1" == "debian" ]; then
	THEME_NAME="Matrix_Debian"
	echo "Installation du theme Debian"
else
	echo "Veuillez spécifier \"cachy\" ou \"debian\""
	exit 1
fi

# Ensure theme directory exists 
echo "Création du répertoire du theme..."
mkdir -p "$THEME_DIR"

# Copy theme files 
echo "Installation du theme..."
cp -r "$THEME_NAME" "$THEME_DIR/" || {
    echo "Echec de la copie des fichiers... Abandon."
    exit 1
}

# Configure GRUB to use the new theme 
echo "Mise a jour configuration Grub..."
if grep -q '^GRUB_THEME=' "$GRUB_CFG"; then
    sed -i "s|^GRUB_THEME=.*|GRUB_THEME=\"${THEME_DIR}/${THEME_NAME}/theme.txt\"|" "$GRUB_CFG"
else
    echo "" >> "$GRUB_CFG"
    echo "GRUB_THEME=\"${THEME_DIR}/${THEME_NAME}/theme.txt\"" >> "$GRUB_CFG"
fi

# Regenerate GRUB
echo "Reconstruction de la configuration GRUB..."
if command -v grub-mkconfig >/dev/null 2>&1; then
    grub-mkconfig -o "$GRUB_FILE" >/dev/null
    echo "Configuration GRUB reconstruite avec success"
else
    echo "Command grub-mkconfig introuvable. Veuillez mettre a jour la configuration manuellement"
    exit 1
fi

echo ""
echo "Installation reussie"
echo "Rebootez pour voir les effets"
echo ""
