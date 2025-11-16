# Cloning the Blue Wave Radio App from GitHub in Xcode

## Repository Information

**GitHub Repository URL:**
```
https://github.com/JUSTJEEESH/101.1-Blue-Wave-Radio.git
```

**SSH URL (if you have SSH keys set up):**
```
git@github.com:JUSTJEEESH/101.1-Blue-Wave-Radio.git
```

**Branch to use:**
```
claude/blue-wave-radio-app-01TP6D9mtSdPUt9a3fhj7Ddz
```

---

## Option 1: Clone Directly in Xcode (Recommended)

### Step 1: Open Xcode Clone Dialog

1. Launch **Xcode**
2. Close any open projects
3. In the Welcome window, click **"Clone Git Repository..."**
   - Or go to **File** → **Clone...**

### Step 2: Enter Repository URL

1. Paste this URL:
   ```
   https://github.com/JUSTJEEESH/101.1-Blue-Wave-Radio.git
   ```

2. Click **"Clone"**

### Step 3: Choose Location

1. Select where you want to save the project (e.g., `~/Documents/`)
2. Click **"Clone"**

### Step 4: Switch to App Branch

1. Once cloned, Xcode will open the project
2. In the top toolbar, click the **branch name** (next to the play/stop buttons)
3. Select **"claude/blue-wave-radio-app-01TP6D9mtSdPUt9a3fhj7Ddz"**
4. Click **"Switch to Branch"**

### Step 5: Open the Xcode Project

**Important:** The repository contains the source files but NOT the Xcode project file yet.

You need to create an Xcode project and import the files:

1. In Xcode: **File** → **New** → **Project**
2. Choose **iOS** → **App**
3. Configure:
   - **Product Name**: `BlueWaveRadio`
   - **Organization Identifier**: `com.bluewaveradio` (or your own)
   - **Interface**: **SwiftUI**
   - **Language**: **Swift**
   - **Storage**: **None**

4. Save it **INSIDE** the cloned repository folder

5. Delete the default files:
   - `ContentView.swift`
   - `BlueWaveRadioApp.swift`

6. Drag the `BlueWaveRadio` folder from the cloned repo into your Xcode project:
   - Check ✅ **"Copy items if needed"**
   - Select **"Create groups"**
   - Target: **BlueWaveRadio**

7. Copy `Info.plist` to your project

---

## Option 2: Clone via Terminal + Open in Xcode

### Step 1: Clone Repository

Open **Terminal** and run:

```bash
cd ~/Documents
git clone https://github.com/JUSTJEEESH/101.1-Blue-Wave-Radio.git
cd 101.1-Blue-Wave-Radio
git checkout claude/blue-wave-radio-app-01TP6D9mtSdPUt9a3fhj7Ddz
```

### Step 2: Follow Steps 5-7 from Option 1 Above

Create the Xcode project inside the cloned folder and import the files.

---

## Option 3: Use Pre-configured Xcode Project (If Available)

If someone commits an `.xcodeproj` file to the repository, you can:

1. Clone the repository (Option 1 or 2)
2. Navigate to the folder
3. Double-click `BlueWaveRadio.xcodeproj`
4. Xcode will open with everything configured

---

## After Cloning: Configure the Project

### 1. Select Development Team

1. Click the **project** in the navigator (blue icon at top)
2. Select the **BlueWaveRadio** target
3. Go to **"Signing & Capabilities"** tab
4. Under **"Team"**, select your Apple Developer account

### 2. Add Required Capabilities

1. Click **"+ Capability"**
2. Add **"Background Modes"**
   - Check ✅ **"Audio, AirPlay, and Picture in Picture"**

3. Click **"+ Capability"**
4. Add **"Push Notifications"**

### 3. Verify Info.plist

Make sure `Info.plist` includes:
- `NSCalendarsUsageDescription`
- `NSUserNotificationsUsageDescription`
- `UIBackgroundModes` → `audio`

### 4. Build and Run

1. Select a simulator: **iPhone 15 Pro**
2. Press **⌘ + R** to build and run

---

## Quick Reference Card

| Item | Value |
|------|-------|
| **Repository** | `https://github.com/JUSTJEEESH/101.1-Blue-Wave-Radio.git` |
| **Branch** | `claude/blue-wave-radio-app-01TP6D9mtSdPUt9a3fhj7Ddz` |
| **Product Name** | `BlueWaveRadio` |
| **Bundle ID** | `com.bluewaveradio.BlueWaveRadio` |
| **Min iOS** | 17.0 |
| **Interface** | SwiftUI |
| **Language** | Swift 6.0 |

---

## Troubleshooting

### "Repository not found"

- Make sure the repository is **public** on GitHub
- Or if private, make sure you're logged into GitHub in Xcode:
  - **Xcode** → **Settings** → **Accounts** → Add GitHub account

### "No Xcode project found"

- Follow **Option 1, Steps 5-7** to create the project and import files

### "Missing files" after clone

- Make sure you switched to the correct branch: `claude/blue-wave-radio-app-01TP6D9mtSdPUt9a3fhj7Ddz`
- Check that you dragged the `BlueWaveRadio` folder into Xcode

### Build errors

- Clean build folder: **Product** → **Clean Build Folder** (⇧⌘K)
- Make sure all files have target membership checked
- Verify Swift version is set to Swift 6

---

## Git Commands Reference

```bash
# Clone repository
git clone https://github.com/JUSTJEEESH/101.1-Blue-Wave-Radio.git

# Navigate into repository
cd 101.1-Blue-Wave-Radio

# List all branches
git branch -a

# Switch to app branch
git checkout claude/blue-wave-radio-app-01TP6D9mtSdPUt9a3fhj7Ddz

# Pull latest changes
git pull origin claude/blue-wave-radio-app-01TP6D9mtSdPUt9a3fhj7Ddz

# Check status
git status
```

---

## Video Tutorial Steps

For a visual guide:

1. **Xcode Welcome Screen** → "Clone Git Repository"
2. **Paste URL**: `https://github.com/JUSTJEEESH/101.1-Blue-Wave-Radio.git`
3. **Choose folder** → Desktop or Documents
4. **Click Clone**
5. **Wait for download** (~1 minute)
6. **Switch branch** (top toolbar) → `claude/blue-wave-radio-app-01TP6D9mtSdPUt9a3fhj7Ddz`
7. **Create new project** inside cloned folder
8. **Import files** from `BlueWaveRadio/` folder
9. **Configure signing** (add your team)
10. **Build & Run** (⌘R)

---

## Need Help?

If you encounter issues:
- Check that repository exists at: https://github.com/JUSTJEEESH/101.1-Blue-Wave-Radio
- Ensure repository is public or you have access
- Verify you have Xcode 15+ installed
- Try using HTTPS URL instead of SSH if authentication fails

**Repository must be pushed to GitHub first!** If you created this locally, you need to create a GitHub repository and push the code there first.
