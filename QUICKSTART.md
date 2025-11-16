# Quick Start Guide

Get the Blue Wave Radio Roatan app running in minutes!

## Prerequisites

- **Xcode 26.1+** installed on your Mac
- **macOS** with iOS 17+ Simulator or physical iOS device
- **Apple Developer Account** (free or paid)

## Setup in 5 Steps

### Step 1: Create New Xcode Project

1. Open Xcode
2. File → New → Project
3. Choose **iOS** → **App**
4. Click **Next**

### Step 2: Configure Project

Fill in the project details:
- **Product Name**: `BlueWaveRadio`
- **Team**: Select your team
- **Organization Identifier**: `com.bluewaveradio` (or your own)
- **Bundle Identifier**: Will auto-generate as `com.bluewaveradio.BlueWaveRadio`
- **Interface**: **SwiftUI**
- **Language**: **Swift**
- **Storage**: **None**

Click **Next** and save to a temporary folder.

### Step 3: Import Source Files

1. In Xcode, **delete** these auto-generated files:
   - `BlueWaveRadioApp.swift`
   - `ContentView.swift`
   - `Assets.xcassets` (we'll recreate)

2. From this repository, **drag** the entire `BlueWaveRadio` folder into Xcode:
   - Make sure "Copy items if needed" is **checked**
   - Make sure "Create groups" is selected
   - Make sure target "BlueWaveRadio" is **checked**

3. Copy the `Info.plist` to replace the default one (or manually configure)

### Step 4: Configure Capabilities

1. Select your project in the navigator
2. Select the **BlueWaveRadio** target
3. Go to **Signing & Capabilities** tab

4. **Add Capability** → **Background Modes**
   - Check: ✅ Audio, AirPlay, and Picture in Picture

5. **Add Capability** → **Push Notifications**
   (Used for local notifications only)

6. In the **General** tab:
   - Set **Minimum Deployments** to **iOS 17.0**

### Step 5: Build and Run

1. Select a simulator: **iPhone 15 Pro** (recommended)
2. Press **⌘ + R** to build and run

That's it! 🎉

## First Run

On the first launch:
1. You'll be asked for **notification permissions** → **Allow**
2. The app will load placeholder data for music events and restaurants
3. Tap the **Radio** tab and press **Play** to start streaming

## Troubleshooting

### Build Fails with "Cannot find type..."

**Solution**: Make sure all files are added to the target
- Select each Swift file in the navigator
- Check the "Target Membership" in the File Inspector (right panel)
- Ensure "BlueWaveRadio" is checked

### Audio Stream Not Playing

**Solution**: Check your network connection
- The stream requires internet access
- Try on a different network if blocked
- Check Info.plist for App Transport Security settings

### "Missing Info.plist values" Error

**Solution**: Manually add to Info.plist:
```xml
<key>NSCalendarsUsageDescription</key>
<string>We need access to your calendar to add music events.</string>
<key>NSUserNotificationsUsageDescription</key>
<string>We'd like to notify you about shows and events.</string>
<key>UIBackgroundModes</key>
<array>
    <string>audio</string>
</array>
```

### Signing Errors

**Solution**:
1. Go to Signing & Capabilities
2. Select your Team
3. Let Xcode automatically manage signing

### Simulator Not Showing

**Solution**:
1. Xcode → Preferences → Platforms
2. Download iOS 17+ simulators if missing

## Testing Features

### Test Radio Streaming
1. Tap **Radio** tab
2. Tap large **Play** button
3. Audio should start playing within 5 seconds
4. Lock your device → Controls should appear on lock screen
5. Try **Sleep Timer** → Set 15 minutes → Verify countdown

### Test Music Scene
1. Tap **Music Scene** tab
2. Should see placeholder events
3. Tap an event → View details
4. Tap **Add to Calendar** → Grant permission → Check Calendar app
5. Search for "reggae" → Should filter results

### Test Dine Out
1. Tap **Dine Out** tab
2. Should see restaurants grouped by area
3. Change area using segmented picker
4. Tap a restaurant → View details
5. If restaurant has phone → Tap to call (on device)
6. Search for "seafood" → Should filter by cuisine

## Next Steps

- **Customize**: Update colors in `Color+Theme.swift`
- **Localize**: Translate `Localizable.strings` for Spanish
- **Deploy**: Archive and upload to App Store Connect
- **Test on Device**: Run on physical iPhone for best experience

## Getting Help

Issues? Check:
1. **README.md** - Full documentation
2. **Code Comments** - Inline documentation
3. **Xcode Console** - Error messages

## Quick Reference

**Key Files**:
- `BlueWaveRadioApp.swift` - App entry point
- `ContentView.swift` - Main tab navigation
- `AudioStreamManager.swift` - Radio streaming logic
- `StreamingView.swift` - Radio player UI

**Key Frameworks**:
- SwiftUI - UI
- AVFoundation - Audio streaming
- UserNotifications - Local notifications
- EventKit - Calendar integration

**Stream URL**: `https://streaming.shoutcast.com/101-1-blue-wave-radio-roatan`

Happy coding! 🎵🏝️📻
