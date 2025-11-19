#!/bin/bash

# Exit if no arguments provided
if [[ $# -eq 0 ]]; then
    echo "Usage: $0 <pkg1.pkg.tar.zst> <pkg2.pkg.tar.zst> ..."
    exit 1
fi

# Process each package given as argument
for PKG in "$@"; do
    echo "---------------------------------------------"
    echo "[*] Processing: $PKG"

    # Check file existence
    if [[ ! -f "$PKG" ]]; then
        echo "[!] File not found: $PKG"
        continue
    fi

    # Extract base name
    BASENAME=$(basename "$PKG" .pkg.tar.zst)

    # Parse package name and version from filename
    PACKAGE_NAME=$(echo "$BASENAME" | sed 's/-[0-9].*//')
    VERSION=$(echo "$BASENAME" | sed "s/${PACKAGE_NAME}-//" | sed 's/-any//')

    echo "[*] Package name: $PACKAGE_NAME"
    echo "[*] Version: $VERSION"

    # Create working directory
    WORKDIR=$(mktemp -d)
    DEBDIR="$WORKDIR/deb"
    mkdir -p "$DEBDIR/DEBIAN"

    echo "[*] Extracting Arch package..."
    if ! tar --use-compress-program=unzstd -xf "$PKG" -C "$WORKDIR"; then
        echo "[!] Extraction failed for: $PKG"
        continue
    fi

    echo "[*] Searching for font directory..."
    FONT_DIR_ARCH=$(find "$WORKDIR" -type d -path "*/usr/share/fonts*" | head -n 1)

    if [[ -z "$FONT_DIR_ARCH" ]]; then
        echo "[!] No font directory found inside: $PKG"
        continue
    fi

    # Prepare Debian font path
    FONT_DIR_DEB="$DEBDIR/usr/share/fonts/truetype/$PACKAGE_NAME"
    mkdir -p "$FONT_DIR_DEB"

    echo "[*] Copying font files..."
    cp -r "$FONT_DIR_ARCH"/* "$FONT_DIR_DEB"/

    # Create Debian control file
    echo "[*] Creating control file..."
    cat <<EOF > "$DEBDIR/DEBIAN/control"
Package: $PACKAGE_NAME
Version: $VERSION
Section: fonts
Priority: optional
Architecture: all
Maintainer: kio <kio@kio>
Description: $PACKAGE_NAME (converted from Arch Linux pkg.tar.zst)
EOF

    # Add post-install script to refresh font cache
    cat <<EOF > "$DEBDIR/DEBIAN/postinst"
#!/bin/sh
set -e
fc-cache -f
EOF
    chmod 755 "$DEBDIR/DEBIAN/postinst"

    # Build .deb package
    OUTPUT_DEB="${PACKAGE_NAME}_${VERSION}_all.deb"
    echo "[*] Building .deb package: $OUTPUT_DEB"
    if dpkg-deb --build "$DEBDIR" "$OUTPUT_DEB"; then
        echo "[+] Successfully created: $OUTPUT_DEB"
    else
        echo "[!] Failed to build .deb for: $PKG"
    fi

    # Clean up
    rm -rf "$WORKDIR"
done

echo "---------------------------------------------"
echo "[✓] All packages processed."
