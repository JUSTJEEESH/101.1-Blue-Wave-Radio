# Changelog

All notable changes to the Blue Wave Radio Roatan iOS app will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2025-01-XX (Pending Release)

### Added - Initial Release

#### Radio Streaming
- Live audio streaming from Shoutcast server
- Background audio playback with lock screen controls
- Now playing metadata display (artist/track info)
- Volume control with slider
- Skip forward (30s) and backward (10s) buttons
- Sleep timer (15, 30, 45, 60 minutes)
- Programming schedule viewer with show details
- AirPlay support for casting to other devices
- Auto-reconnect on network interruption

#### Music Scene
- Browse upcoming music events on Roatan
- Event listings with venue, date, time, and description
- Search events by title, venue, or description
- Event detail view with full information
- Add events to iOS Calendar with EventKit integration
- Set event reminders (1 hour before event)
- Share events via system share sheet
- Mark events as favorites
- Pull-to-refresh to update event listings
- Offline caching with UserDefaults
- Last updated timestamp display
- Placeholder events when data unavailable

#### Dine Out Roatan
- Browse restaurants by island area (6 areas)
  - West End
  - West Bay
  - Sandy Bay
  - French Harbour
  - Oak Ridge
  - East End
- Restaurant listings with cuisine tags
- Featured partner highlighting
- Search restaurants by name or cuisine
- Restaurant detail view with contact information
- Direct phone calling integration
- Email integration
- Facebook page links
- Share restaurant information
- Mark restaurants as favorites
- Pull-to-refresh to update listings
- Offline caching with UserDefaults
- Area-based filtering with segmented picker

#### User Interface
- Tab-based navigation (Radio, Music Scene, Dine Out)
- Island-themed color scheme (Blue, Turquoise, Sand)
- SF Symbols for all icons (iOS design consistency)
- Dark mode support
- Dynamic Type support for accessibility
- VoiceOver labels for screen readers
- SwiftUI-based modern interface
- Smooth animations and transitions
- Pull-to-refresh on content lists
- Search bars with debouncing

#### Technical Features
- MVVM architecture pattern
- Swift 6.0 with @Observable macro
- SwiftUI for all UI components
- AVFoundation for audio streaming
- URLSession for network requests
- UserDefaults for data persistence
- UserNotifications for local notifications
- EventKit for calendar integration
- Native iOS frameworks only (no third-party dependencies)
- Web scraping for content from partner websites
- Background refresh for content updates
- Error handling with graceful fallbacks
- Offline mode with cached data

#### Accessibility
- Full VoiceOver support
- Dynamic Type text sizing
- High contrast mode compatible
- Semantic color usage
- Descriptive accessibility labels
- Keyboard navigation support (iPad)

#### Localization
- English language (default)
- Localization-ready architecture
- NSLocalizedString throughout codebase
- Spanish support prepared (pending translation)

### Technical Specifications

- **Minimum iOS Version**: 17.0
- **Swift Version**: 6.0
- **Xcode Version**: 26.1
- **Supported Devices**: iPhone, iPad
- **Orientation**: Portrait primary, landscape supported
- **Dependencies**: None (native only)

### Known Issues

- Web scraping may fail if source websites change structure (fallback data provided)
- Stream metadata availability depends on server configuration
- Calendar integration requires user permission grant

---

## [Unreleased] - Future Enhancements

### Planned Features

#### Short-term (v1.1)
- [ ] Improved HTML parsing for more reliable web scraping
- [ ] Enhanced error messages with user-friendly language
- [ ] Podcast archive access
- [ ] Show schedule notifications with custom times
- [ ] Recently played tracks history

#### Medium-term (v1.2)
- [ ] Core Data migration for better offline support
- [ ] iCloud sync for favorites and settings
- [ ] Custom radio show alerts
- [ ] Event RSVP tracking
- [ ] Restaurant reservation links
- [ ] Map view for restaurant locations
- [ ] Directions to venues via Apple Maps

#### Long-term (v2.0)
- [ ] JSON API integration (replace web scraping)
- [ ] User accounts and profiles
- [ ] Social features (reviews, ratings, check-ins)
- [ ] CarPlay support
- [ ] Apple Watch companion app
- [ ] Home screen and lock screen widgets
- [ ] Siri shortcuts integration
- [ ] Apple Music integration (save tracks)
- [ ] App clips for quick access
- [ ] Live activities for now playing

### Under Consideration
- [ ] Message board/community features
- [ ] Photo sharing for events and restaurants
- [ ] Loyalty program integration
- [ ] Ticket purchasing for events
- [ ] Restaurant table reservations
- [ ] Delivery integration
- [ ] Island guide/tourism information
- [ ] Weather widget for Roatan
- [ ] Beach cam integration

---

## Version History

### Version Numbering

- **Major (X.0.0)**: Breaking changes, major redesigns
- **Minor (1.X.0)**: New features, significant updates
- **Patch (1.0.X)**: Bug fixes, minor improvements

### Release Schedule

- **v1.0.0**: Initial release (pending App Store approval)
- **v1.1.0**: Planned for 2 months after launch
- **v1.2.0**: Planned for 4 months after launch
- **v2.0.0**: Planned for 8-12 months after launch

---

## Migration Guide

### From Beta to v1.0.0

This is the initial release. No migration needed.

### Future Migrations

Migration guides will be added here when upgrading between major versions.

---

## Credits

### Development
- App architecture and development: Blue Wave Radio Development Team
- UI/UX design: Island-inspired theme
- Testing: Internal beta testers

### Special Thanks
- 101.1 Blue Wave Radio station team
- Roatan Music Scene contributors
- Dine Out Roatan partners
- Local business sponsors
- Beta testers and early users

---

**Questions or feedback?**
Contact: info@bluewaveradio.live
Website: https://www.bluewaveradio.live
