# 🎵 Blue Wave Radio - Start Here!

## ⚠️ Important: After Cloning

Since this repository contains **source files only** (not a complete Xcode project), follow these steps:

---

## 📱 Quick Setup (2 Minutes)

### Step 1: You've Already Cloned ✅

You cloned the repo and it opened in Finder. That's correct!

### Step 2: Create Xcode Project

1. **Open Xcode**
2. **File → New → Project**
3. Choose **iOS** → **App**
4. Click **Next**

### Step 3: Configure Project

Fill in these **exact values**:

- **Product Name**: `BlueWaveRadio`
- **Team**: Select your development team
- **Organization Identifier**: `com.bluewaveradio` (or your own)
- **Interface**: **SwiftUI**
- **Language**: **Swift**
- **Storage**: **None**
- **Include Tests**: Unchecked (optional)

Click **Next**

### Step 4: Save Location

**IMPORTANT:** Save the project **INSIDE** the folder you just cloned!

Example:
```
/Users/joshgreen/Documents/101.1-Blue-Wave-Radio/BlueWaveRadio.xcodeproj
```

Click **Create**

### Step 5: Delete Auto-Generated Files

In Xcode's Project Navigator (left sidebar), **delete** these files:
- `ContentView.swift` (select → Delete → Move to Trash)
- `BlueWaveRadioApp.swift` (select → Delete → Move to Trash)

### Step 6: Add Source Files

1. In **Finder**, navigate to the cloned folder
2. Find the **`BlueWaveRadio`** folder (the one with App, Models, Views, etc.)
3. **Drag** this entire folder into Xcode's Project Navigator
4. When prompted:
   - ✅ Check **"Copy items if needed"**
   - ✅ Select **"Create groups"**
   - ✅ Add to target: **BlueWaveRadio**
5. Click **Finish**

### Step 7: Add Capabilities

1. Click the **blue project icon** at the top of the navigator
2. Select the **BlueWaveRadio** target
3. Go to **"Signing & Capabilities"** tab
4. Click **"+ Capability"** button
5. Add **"Background Modes"**
   - Check: ✅ **Audio, AirPlay, and Picture in Picture**
6. Click **"+ Capability"** again
7. Add **"Push Notifications"**

### Step 8: Build and Run! 🚀

1. Select a simulator: **iPhone 15 Pro** (from the device menu at top)
2. Press **⌘ + R** (or click the Play button)
3. Wait for build to complete
4. The app launches! 🎉

---

## 🎯 Your App is Ready!

You should now see:
- **Radio Tab**: Stream 101.1 Blue Wave Radio
- **Music Scene Tab**: Browse music events
- **Dine Out Tab**: Browse restaurants

---

## ❓ Troubleshooting

### "Missing files" errors
- Make sure you dragged the `BlueWaveRadio` folder (not individual files)
- Check that all files show the target "BlueWaveRadio" in File Inspector

### Build errors
- Product → Clean Build Folder (⇧⌘K)
- Make sure Xcode is version 15+
- Check that iOS deployment target is 17.0

### "No signing certificate"
- In Signing & Capabilities, select your Team
- Let Xcode automatically manage signing

---

## 📚 More Documentation

- **README.md** - Complete project documentation
- **QUICKSTART.md** - Detailed setup guide
- **CHANGELOG.md** - Version history

---

## 🆘 Still Stuck?

If you're having issues, the fastest way is:

1. Close Xcode
2. Delete the `.xcodeproj` file you created
3. Start over from Step 1 above
4. Follow each step carefully

---

**Why isn't there an .xcodeproj file included?**

Xcode project files contain user-specific paths and settings. By creating it fresh on your Mac, you avoid configuration conflicts and signing issues.

---

🌊 **Enjoy your Blue Wave Radio app!**
