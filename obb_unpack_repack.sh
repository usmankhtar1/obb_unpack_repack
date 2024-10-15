#!/bin/bash

# Check if correct number of arguments are provided
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <obb-file> <output-obb-file>"
    exit 1
fi

# Variables
OBB_FILE=$1
OUTPUT_OBB=$2
EXTRACT_DIR="obb_extracted"

# Step 1: Create directory for extraction
echo "[*] Creating directory $EXTRACT_DIR for extraction"
mkdir -p "$EXTRACT_DIR"

# Step 2: Unpack the OBB file
echo "[*] Unpacking $OBB_FILE"
unzip -q "$OBB_FILE" -d "$EXTRACT_DIR"

# Step 3: Prompt user for modifications
echo "[*] Files have been extracted to $EXTRACT_DIR"
echo "[*] Modify the files as necessary and press Enter when done."
read -p "Press [Enter] key to continue after modifications..."

# Step 4: Repack the files into a new OBB file
echo "[*] Repacking into $OUTPUT_OBB"
cd "$EXTRACT_DIR"
zip -r -0 "../$OUTPUT_OBB" ./*

# Step 5: Cleanup and exit
cd ..
echo "[*] Cleaning up extraction directory"
rm -rf "$EXTRACT_DIR"

echo "[*] Done. New OBB file created as $OUTPUT_OBB"
exit 0