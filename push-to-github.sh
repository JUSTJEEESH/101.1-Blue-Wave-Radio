#!/bin/bash

# Blue Wave Radio - Push to GitHub Script
# This script pushes your code to GitHub so you can clone it in Xcode

echo "🎵 Blue Wave Radio - GitHub Push Script"
echo "========================================"
echo ""

# Navigate to project directory
cd /Users/joshgreen/Documents/101.1-Blue-Wave-Radio

echo "✓ In project directory"
echo ""

# Remove old remote
git remote remove origin 2>/dev/null || true

echo "✓ Removed old remote"
echo ""

# Add GitHub remote
git remote add origin https://github.com/JUSTJEEESH/101.1-Blue-Wave-Radio.git

echo "✓ Added GitHub remote"
echo ""

# Push to GitHub
echo "📤 Pushing to GitHub..."
echo ""
echo "When prompted:"
echo "  Username: JUSTJEEESH"
echo "  Password: Use your Personal Access Token (NOT your GitHub password)"
echo ""

git push -u origin claude/blue-wave-radio-app-01TP6D9mtSdPUt9a3fhj7Ddz

echo ""
echo "✅ Done! Your code is now on GitHub!"
echo ""
echo "🎯 Next Steps:"
echo "1. Open Xcode"
echo "2. File → Clone..."
echo "3. Paste: https://github.com/JUSTJEEESH/101.1-Blue-Wave-Radio.git"
echo "4. Click Clone"
echo ""
echo "🌊 Your Blue Wave Radio app is ready to clone!"
