# Assets Guide

This guide explains how to set up app assets in Xcode.

## Asset Catalog Structure

In Xcode, create an `Assets.xcassets` folder with the following structure:

```
Assets.xcassets/
├── AppIcon.appiconset/
│   ├── Contents.json
│   └── [App icons at various sizes]
├── AccentColor.colorset/
│   └── Contents.json
├── LaunchImage.imageset/
│   └── [Launch screen image]
└── Colors/
    ├── PrimaryBlue.colorset/
    ├── AccentTurquoise.colorset/
    └── NeutralSand.colorset/
```

## Creating the Asset Catalog

### 1. Add Asset Catalog

1. Right-click on the `BlueWaveRadio` folder in Xcode
2. New File → Resource → Asset Catalog
3. Name it `Assets`
4. Click Create

### 2. Configure App Icon

1. Select `AppIcon` in Assets.xcassets
2. Drag and drop icon files for each size:
   - iPhone: 60x60@2x, 60x60@3x, 1024x1024
   - iPad: 76x76, 83.5x83.5@2x, 1024x1024
   - Marketing: 1024x1024

**Icon Design Recommendations**:
- Use island/wave/radio theme
- Primary color: Blue (#003366)
- Accent: Turquoise (#00BFFF)
- Simple, recognizable at small sizes
- No text (app name appears below icon)

### 3. Set Accent Color

1. Select `AccentColor` in Assets.xcassets
2. In Attributes Inspector, set:
   - Any Appearance: RGB (0, 191, 255) - Turquoise
   - Dark Appearance: Same or adjust for contrast

### 4. Add Custom Colors (Optional)

For better organization, add named colors:

1. Click + at bottom of asset list
2. Choose "Color Set"
3. Name it "PrimaryBlue"
4. Set color values:
   - Any: RGB (0, 51, 102)
   - Dark: Same

Repeat for:
- `AccentTurquoise`: RGB (0, 191, 255)
- `NeutralSand`: RGB (245, 245, 220)

### 5. Launch Screen (Optional)

For a custom launch image:

1. Click + → New Image Set
2. Name it "LaunchImage"
3. Add splash screen image (centered logo with gradient background)

Alternatively, use SwiftUI for launch screen:
- The `Info.plist` already references `UILaunchScreen`
- Xcode will show app icon centered on background color

## App Icon Design Template

### Concept Ideas

**Option 1: Wave Icon**
- Stylized radio waves emanating from center
- Gradient from blue to turquoise
- Circular design

**Option 2: Radio Badge**
- "101.1" text prominent
- "BLUE WAVE" subtitle
- Radio antenna or wave graphic

**Option 3: Island Theme**
- Palm tree silhouette
- Radio waves in background
- Ocean gradient

### Using SF Symbols (Quick Prototype)

For rapid testing, use SF Symbol icons:

1. Open SF Symbols app on Mac
2. Search for "radiowaves.left.and.right"
3. Export at various sizes
4. Apply blue/turquoise tint
5. Use temporarily until custom icon ready

## Asset Specifications

### App Icon Sizes

| Size | Usage | Resolution |
|------|-------|------------|
| 20pt | iPhone Notification | 40x40, 60x60 |
| 29pt | iPhone Settings | 58x58, 87x87 |
| 40pt | iPhone Spotlight | 80x80, 120x120 |
| 60pt | iPhone App | 120x120, 180x180 |
| 76pt | iPad App | 76x76, 152x152 |
| 83.5pt | iPad Pro | 167x167 |
| 1024pt | App Store | 1024x1024 |

### Launch Screen

- Dimensions: 1170x2532 (iPhone 13 Pro Max)
- Safe Area: Center 1024x1024 region
- Format: PNG with no transparency
- Avoid: Text (except logo), UI elements, branding beyond app name

## Color Palette

All app colors are defined in code (`Color+Theme.swift`), but can also be added to Assets:

```swift
Primary Blue:    #003366  (RGB: 0, 51, 102)
Accent Turquoise: #00BFFF  (RGB: 0, 191, 255)
Neutral Sand:    #F5F5DC  (RGB: 245, 245, 220)
```

### Dark Mode Considerations

- Primary Blue: Lighten to #004488 for dark mode
- Turquoise: Keep same or slightly lighter
- Sand: Darken to #E5E5CA for readability

## Testing Assets

### Preview in Xcode
1. Select Assets.xcassets
2. Select an asset
3. Right panel shows preview in light/dark mode

### Preview on Device
1. Build and install on iPhone/iPad
2. Check Home Screen icon appearance
3. Test in both light and dark mode (Settings → Display → Dark Mode)

### App Store Screenshots (Future)

Required sizes for App Store:
- iPhone 6.7": 1290x2796
- iPhone 6.5": 1242x2688
- iPhone 5.5": 1242x2208
- iPad Pro 12.9": 2048x2732

Screenshot content ideas:
1. Radio player with "Now Playing"
2. Music Scene events list
3. Event detail with calendar integration
4. Dine Out restaurants by area
5. Restaurant detail with contact options

## Resources

- **Apple Design Resources**: https://developer.apple.com/design/resources/
- **SF Symbols**: https://developer.apple.com/sf-symbols/
- **Human Interface Guidelines**: https://developer.apple.com/design/human-interface-guidelines/
- **Icon Design Tools**:
  - Sketch
  - Figma
  - Adobe Illustrator
  - Affinity Designer

## Quick Asset Generation

### Using Online Tools

1. **AppIcon.co** - Upload 1024x1024, generates all sizes
2. **MakeAppIcon.com** - Similar service
3. **Icon Slate** (Mac app) - Professional icon creation

### DIY Approach

1. Create 1024x1024 PNG in your design tool
2. Use Xcode's Asset Catalog to auto-generate sizes:
   - Select AppIcon
   - Drag 1024x1024 to any slot
   - Right-click → "Generate All Sizes" (if available in your Xcode version)

## Checklist

Before App Store submission:

- [ ] All app icon sizes included
- [ ] App icon follows Apple guidelines (no transparency, no alpha)
- [ ] Accent color set
- [ ] Launch screen configured
- [ ] Assets optimized (compressed)
- [ ] Tested in light and dark mode
- [ ] Tested on multiple device sizes
- [ ] Screenshots prepared
- [ ] Preview video ready (optional but recommended)

---

**Note**: This repository includes code-based colors. Asset colors are optional but recommended for easier design iteration and Dark Mode support.
