# Bit2Connect iOS SDK

A comprehensive iOS SDK for handling deferred deep linking and dynamic link creation. This SDK enables you to track user attribution and handle deep links even when your app is not installed.

## Features

- **Deferred Deep Linking**: Track users who click on your links before installing your app
- **Dynamic Link Creation**: Programmatically create short links with custom parameters
- **Device Fingerprinting**: Uses device information for accurate attribution
- **Secure Storage**: Encrypted storage for sensitive data using iOS Keychain
- **Easy Integration**: Simple API with comprehensive result handling
- **Swift Package Manager**: Native SPM support
- **CocoaPods**: Full CocoaPods support

## Requirements

- iOS 13.0+
- Xcode 12.0+
- Swift 5.0+

## Installation

### Swift Package Manager

Add the following to your `Package.swift` file:

```swift
dependencies: [
    .package(url: "https://github.com/bit2connect/bit2connect-ios-sdk.git", from: "1.0.0")
]
```

Or add it through Xcode:
1. File → Add Package Dependencies
2. Enter the repository URL: `https://github.com/bit2connect/bit2connect-ios-sdk.git`
3. Select the version and add to your target

### CocoaPods

Add the following to your `Podfile`:

```ruby
pod 'Bit2ConnectSDK', '~> 1.0.0'
```

Then run:

```bash
pod install
```

## Quick Start

### 1. Initialize the SDK

```swift
import Bit2ConnectSDK

// In your AppDelegate or SceneDelegate
Bit2ConnectSDK.shared.initialize(
    baseURL: "https://api.bit2connect.com",
    apiKey: "your-api-key",
    debugMode: true // Enable debug logging
)
```

### 2. Handle Deferred Deep Links

Call this method when your app starts to check for deferred deep links:

```swift
Bit2ConnectSDK.shared.handleDeferredDeepLink { result in
    switch result {
    case .success(let linkData):
        // Handle the deferred deep link
        handleLinkData(linkData)
    case .noLink:
        // No deferred deep link found
        print("No deferred deep link found")
    case .error(let message):
        // Handle error
        print("Error: \(message)")
    }
}
```

### 3. Create Dynamic Links

```swift
let linkData = DynamicLinkData(
    deepLink: "https://yourapp.com/screen?param=value",
    campaign: "summer_sale",
    source: "email",
    medium: "newsletter",
    customParameters: [
        "user_id": "12345",
        "feature": "premium"
    ],
    socialTitle: "Check out this app!",
    socialDescription: "Amazing features await you",
    socialImageUrl: "https://yourapp.com/images/social-preview.jpg",
    iosBundleId: "com.yourapp.package",
    fallbackUrl: "https://yourapp.com/download"
)

Bit2ConnectSDK.shared.createDynamicLink(data: linkData) { result in
    switch result {
    case .success(let response):
        let shortLink = response.shortLink
        let previewLink = response.previewLink
        let qrCodeUrl = response.qrCodeUrl
        
        // Use the created links
    case .error(let message):
        // Handle error
        print("Error: \(message)")
    }
}
```

### 4. Handle Direct Deep Links

```swift
// In your AppDelegate
func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
    Bit2ConnectSDK.shared.handleDirectDeepLink(url: url) { result in
        switch result {
        case .success(let linkData):
            // Handle the direct deep link
            handleLinkData(linkData)
        case .error(let message):
            // Handle error
            print("Error: \(message)")
        }
    }
    
    return true
}

// In your SceneDelegate (iOS 13+)
func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
    guard let url = URLContexts.first?.url else { return }
    
    Bit2ConnectSDK.shared.handleDirectDeepLink(url: url) { result in
        switch result {
        case .success(let linkData):
            // Handle the direct deep link
            handleLinkData(linkData)
        case .error(let message):
            // Handle error
            print("Error: \(message)")
        }
    }
}
```

## Configuration

### URL Schemes

Add URL schemes to your `Info.plist`:

```xml
<key>CFBundleURLTypes</key>
<array>
    <dict>
        <key>CFBundleURLName</key>
        <string>com.yourapp.bit2connect</string>
        <key>CFBundleURLSchemes</key>
        <array>
            <string>yourapp</string>
        </array>
    </dict>
    <dict>
        <key>CFBundleURLName</key>
        <string>com.yourapp.bit2connect.https</string>
        <key>CFBundleURLSchemes</key>
        <array>
            <string>https</string>
        </array>
    </dict>
</array>
```

### Associated Domains

For universal links, add associated domains to your `Info.plist`:

```xml
<key>com.apple.developer.associated-domains</key>
<array>
    <string>applinks:yourdomain.com</string>
</array>
```

## Data Models

### LinkData

Represents link data with campaign information:

```swift
struct LinkData {
    let originalUrl: String
    let path: String
    let parameters: [String: String]
    let campaign: String?
    let source: String?
    let medium: String?
    let content: String?
    let term: String?
}
```

### DynamicLinkData

Data for creating dynamic links:

```swift
struct DynamicLinkData {
    let deepLink: String
    let campaign: String?
    let source: String?
    let medium: String?
    let content: String?
    let term: String?
    let customParameters: [String: String]
    let socialTitle: String?
    let socialDescription: String?
    let socialImageUrl: String?
    let androidPackageName: String?
    let iosBundleId: String?
    let fallbackUrl: String?
}
```

## Secure Storage

The SDK provides secure storage for sensitive data using iOS Keychain:

```swift
// Store data
Bit2ConnectSDK.shared.storeCustomData(key: "user_id", value: "12345")
Bit2ConnectSDK.shared.storeCustomData(key: "preference", value: "dark_mode")

// Retrieve data
let userId = Bit2ConnectSDK.shared.getCustomData(key: "user_id")
let preference = Bit2ConnectSDK.shared.getCustomData(key: "preference")

// Delete data
Bit2ConnectSDK.shared.deleteCustomData(key: "user_id")

// Clear all data
Bit2ConnectSDK.shared.clearCustomData()
```

## Error Handling

All SDK methods return result objects that handle success and error cases:

```swift
// DeferredLinkResult
switch result {
case .success(let linkData):
    // Handle success
case .noLink:
    // No link found
case .error(let message):
    // Handle error
}

// DynamicLinkResult
switch result {
case .success(let response):
    // Handle success
case .error(let message):
    // Handle error
}

// DirectLinkResult
switch result {
case .success(let linkData):
    // Handle success
case .error(let message):
    // Handle error
}
```

## Debug Mode

Enable debug mode to see detailed logs:

```swift
Bit2ConnectSDK.shared.setDebugMode(true)
```

## Example App

Check out the included example app to see the SDK in action. The example demonstrates:

- SDK initialization
- Deferred deep link handling
- Dynamic link creation
- Direct deep link handling
- Secure data storage
- Error handling

## Dependencies

- Alamofire 5.8.0+
- SwiftyJSON 5.0.0+

## License

MIT License - see LICENSE file for details.

## Support

For support and questions, please contact us at dev@bit2connect.com or visit our website at https://bit2connect.com.
