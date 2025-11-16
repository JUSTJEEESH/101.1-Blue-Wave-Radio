#!/bin/bash

# Blue Wave Radio - Automatic Setup Script
# This creates the Xcode project for you automatically

echo ""
echo "🎵 Blue Wave Radio - Automatic Setup"
echo "====================================="
echo ""

# Get the directory where this script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$SCRIPT_DIR"

echo "📁 Working in: $SCRIPT_DIR"
echo ""

# Check if Xcode is installed
if ! command -v xcodebuild &> /dev/null; then
    echo "❌ Error: Xcode is not installed"
    echo "Please install Xcode from the App Store first"
    exit 1
fi

echo "✓ Xcode found"
echo ""

# Create Xcode project
echo "🔨 Creating Xcode project..."
echo ""

# Create the project using xcodebuild
xcodebuild -create-xcodeproj \
    -name BlueWaveRadio \
    -organization "Blue Wave Radio" \
    -product-name BlueWaveRadio

if [ -f "BlueWaveRadio.xcodeproj/project.pbxproj" ]; then
    echo "✓ Xcode project created"
else
    echo "❌ Failed to create Xcode project"
    echo ""
    echo "Manual Setup Required:"
    echo "1. Open Xcode"
    echo "2. File → New → Project"
    echo "3. iOS → App → Next"
    echo "4. Product Name: BlueWaveRadio"
    echo "5. Interface: SwiftUI"
    echo "6. Language: Swift"
    echo "7. Save in this folder: $SCRIPT_DIR"
    echo "8. Delete ContentView.swift and BlueWaveRadioApp.swift"
    echo "9. Drag BlueWaveRadio folder into Xcode"
    exit 1
fi

echo ""
echo "✅ Setup Complete!"
echo ""
echo "🎯 Next Steps:"
echo "1. Double-click: BlueWaveRadio.xcodeproj"
echo "2. In Xcode, delete: ContentView.swift and BlueWaveRadioApp.swift"
echo "3. Drag the 'BlueWaveRadio' folder into Xcode project navigator"
echo "4. Go to Signing & Capabilities → Select your Team"
echo "5. Add Capability: Background Modes → Check Audio"
echo "6. Press ⌘+R to build and run!"
echo ""
echo "📖 See START-HERE.md for detailed instructions"
echo ""
