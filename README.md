# Blue Wave Radio Roatan iOS App

An iOS application for streaming 101.1 Blue Wave Radio from Roatan, Honduras, with integrated music events and restaurant discovery features.

## Overview

The Blue Wave Radio Roatan app provides:
- **Live Radio Streaming**: Stream 101.1 Blue Wave Radio with background playback, lock screen controls, and sleep timer
- **Music Scene**: Browse and discover live music events happening around Roatan
- **Dine Out**: Find restaurants by area and cuisine across the island

## Requirements

- Xcode 26.1 or later
- iOS 17.0+ / iPadOS 17.0+
- Swift 6.0
- SwiftUI

## Project Structure

```
BlueWaveRadio/
├── App/
│   ├── BlueWaveRadioApp.swift       # Main app entry point
│   └── ContentView.swift             # Tab navigation
├── Models/
│   ├── MusicEvent.swift              # Music event data model
│   ├── Restaurant.swift              # Restaurant data model
│   └── RadioShow.swift               # Radio show schedule model
├── Services/
│   ├── AudioStreamManager.swift      # Audio streaming service
│   ├── MusicSceneManager.swift       # Music events data service
│   ├── DineOutManager.swift          # Restaurant data service
│   └── NotificationManager.swift     # Local notifications service
├── Views/
│   ├── Streaming/
│   │   ├── StreamingView.swift       # Radio player UI
│   │   ├── ProgrammingScheduleView.swift
│   │   └── SleepTimerView.swift
│   ├── MusicScene/
│   │   ├── MusicSceneView.swift      # Events list
│   │   └── EventDetailView.swift     # Event details
│   └── DineOut/
│       ├── DineOutView.swift         # Restaurant list
│       └── RestaurantDetailView.swift # Restaurant details
├── Utilities/
│   └── Color+Theme.swift             # Theme colors
├── Resources/
│   └── Localizable.strings           # Localization strings
└── Info.plist                        # App configuration

```

## Setup Instructions

### 1. Open in Xcode

1. Launch Xcode 26.1 or later
2. Choose "Create a new Xcode project"
3. Select "App" under iOS
4. Configure:
   - **Product Name**: BlueWaveRadio
   - **Team**: Your development team
   - **Organization Identifier**: com.bluewaveradio (or your identifier)
   - **Bundle Identifier**: com.bluewaveradio.BlueWaveRadio
   - **Interface**: SwiftUI
   - **Language**: Swift
   - **Storage**: None (we'll use UserDefaults)

5. Save the project in a temporary location

### 2. Replace Files

1. Delete the default `ContentView.swift` and `BlueWaveRadioApp.swift` from the Xcode project
2. Drag all folders from this `BlueWaveRadio/` directory into your Xcode project:
   - Select "Copy items if needed"
   - Select "Create groups"
   - Add to target: BlueWaveRadio

### 3. Configure Build Settings

1. Select the project in the navigator
2. Select the "BlueWaveRadio" target
3. Go to "Signing & Capabilities":
   - Select your development team
   - Enable "Background Modes" capability
   - Check "Audio, AirPlay, and Picture in Picture"
   - Enable "Push Notifications" capability (for local notifications)

4. Go to "General":
   - Set "Minimum Deployments" to iOS 17.0
   - Verify "Supported Destinations" includes iPhone and iPad

5. Go to "Info":
   - Verify custom Info.plist settings are loaded from `Info.plist`

### 4. Add Permissions

The `Info.plist` already includes required permission descriptions:
- Calendar access for adding events
- Notifications for show and event reminders
- Network access for streaming

### 5. Build and Run

1. Select a simulator (iPhone 15 Pro recommended) or physical device
2. Press `Cmd+B` to build
3. Press `Cmd+R` to run

## Features

### Radio Streaming
- Live stream from Shoutcast server
- Background audio playback
- Lock screen controls with metadata
- Volume control
- Skip forward/backward buttons
- Sleep timer (15, 30, 45, 60 minutes)
- Programming schedule viewer
- AirPlay support

### Music Scene
- Browse upcoming music events
- Search events by name, venue, or description
- View event details (date, time, venue, description)
- Add events to Calendar
- Set event reminders
- Share events
- Mark events as favorites
- Pull to refresh
- Offline caching

### Dine Out
- Browse restaurants by island area (6 areas)
- Search by cuisine or name
- View restaurant details
- Call restaurants directly
- View Facebook pages
- Share restaurant info
- Mark restaurants as favorites
- Featured partner highlighting
- Pull to refresh
- Offline caching

## Technical Details

### Architecture
- **Pattern**: MVVM (Model-View-ViewModel)
- **UI Framework**: SwiftUI with @Observable (Swift 6)
- **Audio**: AVFoundation (AVPlayer, AVAudioSession)
- **Networking**: URLSession for HTTP requests
- **Persistence**: UserDefaults for caching and favorites
- **Notifications**: UserNotifications framework (local only)
- **Calendar**: EventKit for calendar integration

### Data Sources
- **Radio Stream**: `https://streaming.shoutcast.com/101-1-blue-wave-radio-roatan`
- **Music Events**: `https://www.bluewaveradio.live/roatanmusicscene` (web scraping)
- **Restaurants**: `https://www.dineoutroatan.com/` (web scraping)

### Color Theme
- Primary Blue: `#003366`
- Accent Turquoise: `#00BFFF`
- Neutral Sand: `#F5F5DC`

### Accessibility
- VoiceOver labels on all interactive elements
- Dynamic Type support
- SF Symbols for consistent iconography
- High contrast mode support
- Semantic colors for dark mode

### Localization
- English (default)
- Spanish support ready (requires translation of `Localizable.strings`)

## Testing

### Unit Testing
1. Select "Test" from the Product menu or press `Cmd+U`
2. Tests should cover:
   - Audio streaming initialization
   - Data parsing from web sources
   - Favorites management
   - Search functionality

### UI Testing
1. Test key user flows:
   - Play/pause radio stream
   - Browse and search events
   - Add event to calendar
   - Browse restaurants by area
   - Call restaurant from detail view

## Known Limitations

1. **Web Scraping**: Music events and restaurant data use basic HTML parsing. If website structure changes, parsing may fail. Fallback placeholder data is provided.

2. **Stream Metadata**: Shoutcast Icy metadata depends on the stream server configuration. If unavailable, displays static station info.

3. **Offline Mode**: Cached data is available offline, but refresh requires internet connection.

## Future Enhancements

Recommended improvements for future versions:

1. **JSON APIs**: Replace web scraping with proper JSON endpoints for reliability
2. **Core Data**: Implement full Core Data stack for better offline support
3. **Social Features**: User reviews, ratings, and check-ins
4. **Map Integration**: MapKit integration for restaurant locations
5. **Favorites Sync**: iCloud sync for favorites across devices
6. **CarPlay**: CarPlay integration for in-car listening
7. **Analytics**: App Store Connect analytics integration
8. **Deep Linking**: Universal links for sharing specific content
9. **Widget**: Lock screen and home screen widgets for quick access
10. **Apple Music**: Integration to save playing tracks to playlists

## License

Copyright © 2025 Blue Wave Radio Roatan. All rights reserved.

## Support

For issues or questions about the app:
- Website: https://www.bluewaveradio.live
- Email: info@bluewaveradio.live
- Phone: +504-xxxx-xxxx

## Credits

Developed for 101.1 Blue Wave Radio, Roatan, Honduras
