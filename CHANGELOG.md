# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.1] - 2025-09-15

### Added
- Enhanced CocoaPods podspec description with Swift Package Manager support
- Updated documentation to highlight dual distribution support
- Improved package manager compatibility information
- Swift Package Manager v1.0.1 availability

### Changed
- Updated podspec description to mention SPM availability
- Enhanced README with latest version information
- Both CocoaPods and Swift Package Manager now at version 1.0.1

## [1.0.0] - 2025-09-15

### Added
- Initial release of Bit2Connect iOS SDK
- Deferred deep linking support for iOS
- Dynamic link creation with custom parameters
- Device fingerprinting for attribution
- Secure storage using iOS Keychain
- Comprehensive result handling with enums
- Debug logging support
- Separate example app demonstrating all features
- Complete documentation and API reference
- Swift Package Manager support and publication
- CocoaPods support and publication
- Published to CocoaPods Trunk (https://cocoapods.org/pods/Bit2ConnectSDK)
- Published to Swift Package Manager (https://github.com/bit2connect/bit2connect-ios-sdk)
- Cross-platform compatibility for SPM distribution

### Features
- **Deferred Deep Linking**: Track users who click links before app installation
- **Dynamic Link Creation**: Programmatically create short links with campaign data
- **Direct Link Handling**: Parse and handle deep links when app is installed
- **Device Attribution**: Accurate user attribution using device fingerprinting
- **Custom Data Support**: Store and retrieve custom data securely using Keychain
- **Campaign Tracking**: Built-in support for UTM parameters and campaign data
- **Social Media Integration**: Support for social media link previews
- **QR Code Generation**: Automatic QR code generation for created links

### Technical Details
- Built for iOS 13.0+
- Uses Alamofire for network communication
- Uses SwiftyJSON for JSON parsing
- Uses iOS Keychain for secure storage
- Singleton pattern for easy global access
- Comprehensive error handling and logging
- Type-safe result classes with enums

### Dependencies
- `Alamofire: 5.8.0+`
- `SwiftyJSON: 5.0.0+`

### Platform Support
- ✅ iOS (13.0+)
- ❌ Android (not supported - use Android SDK)
- ❌ Web (not supported)
- ❌ Desktop (not supported)

### Breaking Changes
- None (initial release)

### Migration Guide
- N/A (initial release)

## [Unreleased]

### Planned Features
- Enhanced analytics and reporting
- A/B testing support
- Custom attribution models
- Batch link creation
- Link analytics dashboard
- Advanced campaign management
- Integration with popular analytics platforms
- Support for more deep link schemes
- Enhanced device fingerprinting
- Offline link caching
