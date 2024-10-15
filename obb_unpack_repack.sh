#!/bin/bash

# Check if correct number of arguments is provided
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <obb-file> <output-obb-file>"
    exit 1
fi

# Variables
OBB_FILE=$1
OUTPUT_OBB=$2
EXTRACT_DIR="obb_extracted"
TEMP_OBB_DIR="obb_temp"

# Step 1: Create directories for extraction and temporary output
echo "[*] Creating directories $EXTRACT_DIR for extraction and $TEMP_OBB_DIR for temporary repacking"
mkdir -p "$EXTRACT_DIR"
mkdir -p "$TEMP_OBB_DIR"

# Step 2: Unpack the OBB file
echo "[*] Unpacking $OBB_FILE"
unzip -q "$OBB_FILE" -d "$EXTRACT_DIR"

# Step 3: Check if the extraction was successful
if [ "$(ls -A $EXTRACT_DIR)" ]; then
    echo "[*] Extraction successful. Files have been extracted to $EXTRACT_DIR"
else
    echo "[!] Extraction failed or no files were found in the OBB file!"
    rm -rf "$EXTRACT_DIR"
    rm -rf "$TEMP_OBB_DIR"
    exit 1
fi

# Step 4: Prompt user for modifications
echo "[*] Modify the files as necessary in $EXTRACT_DIR and press Enter when done."
read -p "Press [Enter] key to continue after modifications..."

# Step 5: Check if the output directory exists
OUTPUT_DIR=$(dirname "$OUTPUT_OBB")
if [ ! -d "$OUTPUT_DIR" ]; then
    echo "[!] Output directory does not exist: $OUTPUT_DIR"
    exit 1
fi

# Step 6: Repack the files into a new OBB file in a temporary directory
echo "[*] Repacking into temporary directory $TEMP_OBB_DIR"
cd "$EXTRACT_DIR"

# Repack the files into the temporary OBB file
zip -r -0 "../$TEMP_OBB_DIR/temp.obb" ./*

# Step 7: Move the repacked OBB file to the desired output location
echo "[*] Moving repacked OBB to $OUTPUT_OBB"
mv "../$TEMP_OBB_DIR/temp.obb" "$OUTPUT_OBB"

# Step 8: Verify the repacking process
if [ -f "$OUTPUT_OBB" ]; then
    echo "[*] OBB repacked successfully as $OUTPUT_OBB"
else
    echo "[!] Repacking failed. No OBB file created."
    cd ..
    rm -rf "$EXTRACT_DIR"
    rm -rf "$TEMP_OBB_DIR"
    exit 1
fi

# Step 9: Cleanup and exit
cd ..
echo "[*] Cleaning up extraction and temporary directories"
rm -rf "$EXTRACT_DIR"
rm -rf "$TEMP_OBB_DIR"

echo "[*] Done. New OBB file created as $OUTPUT_OBB"
exit 0
