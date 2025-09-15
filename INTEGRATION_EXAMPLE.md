# Integration Example - Bit2Connect iOS SDK

This document provides a complete example of how to integrate the Bit2Connect iOS SDK into your iOS application.

## Installation

### CocoaPods

Add to your `Podfile`:

```ruby
platform :ios, '13.0'

target 'YourApp' do
  use_frameworks!
  pod 'Bit2ConnectSDK', '~> 1.0.0'
end
```

Run `pod install` and open the `.xcworkspace` file.

### Swift Package Manager

Add the package dependency in Xcode:
1. File → Add Package Dependencies
2. Enter: `https://github.com/bit2connect/bit2connect-ios-sdk.git`
3. Select version 1.0.0

## Complete Integration Example

### 1. AppDelegate.swift

```swift
import UIKit
import Bit2ConnectSDK

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // Initialize Bit2Connect SDK
        Bit2ConnectSDK.shared.initialize(
            baseURL: "https://api.bit2connect.com",
            apiKey: "your-api-key-here",
            debugMode: true
        )
        
        // Handle deferred deep link on app launch
        Bit2ConnectSDK.shared.handleDeferredDeepLink { result in
            switch result {
            case .success(let linkData):
                print("Deferred deep link found: \(linkData.originalUrl)")
                // Handle the deferred deep link
                self.handleLinkData(linkData)
            case .noLink:
                print("No deferred deep link found")
            case .error(let message):
                print("Error getting deferred deep link: \(message)")
            }
        }
        
        return true
    }

    // MARK: - Deep Link Handling
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        // Handle direct deep link
        Bit2ConnectSDK.shared.handleDirectDeepLink(url: url) { result in
            switch result {
            case .success(let linkData):
                print("Direct deep link handled: \(linkData.originalUrl)")
                self.handleLinkData(linkData)
            case .error(let message):
                print("Error handling direct deep link: \(message)")
            }
        }
        
        return true
    }
    
    private func handleLinkData(_ linkData: LinkData) {
        // Process the link data
        print("Processing link data:")
        print("- Original URL: \(linkData.originalUrl)")
        print("- Path: \(linkData.path)")
        print("- Campaign: \(linkData.campaign ?? "None")")
        print("- Source: \(linkData.source ?? "None")")
        print("- Medium: \(linkData.medium ?? "None")")
        print("- Parameters: \(linkData.parameters)")
        
        // Store custom data
        Bit2ConnectSDK.shared.storeCustomData(key: "last_link_url", value: linkData.originalUrl)
        if let campaign = linkData.campaign {
            Bit2ConnectSDK.shared.storeCustomData(key: "last_campaign", value: campaign)
        }
    }
}
```

### 2. SceneDelegate.swift (iOS 13+)

```swift
import UIKit
import Bit2ConnectSDK

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: windowScene)
        let viewController = ViewController()
        let navigationController = UINavigationController(rootViewController: viewController)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
        // Handle deep link from scene connection options
        if let urlContext = connectionOptions.urlContexts.first {
            handleDeepLink(url: urlContext.url)
        }
    }
    
    // MARK: - Deep Link Handling
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard let url = URLContexts.first?.url else { return }
        handleDeepLink(url: url)
    }
    
    private func handleDeepLink(url: URL) {
        Bit2ConnectSDK.shared.handleDirectDeepLink(url: url) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let linkData):
                    print("Scene deep link handled: \(linkData.originalUrl)")
                    // Navigate to appropriate screen based on link data
                    self.navigateToScreen(for: linkData)
                case .error(let message):
                    print("Error handling scene deep link: \(message)")
                }
            }
        }
    }
    
    private func navigateToScreen(for linkData: LinkData) {
        // Example navigation logic
        if let campaign = linkData.campaign {
            print("Navigating to campaign: \(campaign)")
            // Add your navigation logic here
        }
    }
}
```

### 3. Creating Dynamic Links

```swift
import UIKit
import Bit2ConnectSDK

class ViewController: UIViewController {
    
    @IBAction func createDynamicLinkTapped(_ sender: UIButton) {
        let linkData = DynamicLinkData(
            deepLink: "https://yourapp.com/product/123",
            campaign: "summer_sale",
            source: "email",
            medium: "newsletter",
            content: "banner_ad",
            term: "discount",
            customParameters: [
                "user_id": "12345",
                "feature": "premium"
            ],
            socialTitle: "Check out this amazing product!",
            socialDescription: "Get 50% off on all items",
            socialImageUrl: "https://yourapp.com/images/product.jpg",
            androidPackageName: "com.yourapp.app",
            iosBundleId: "com.yourapp.app",
            fallbackUrl: "https://yourapp.com/download"
        )
        
        Bit2ConnectSDK.shared.createDynamicLink(data: linkData) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    print("Dynamic Link Created:")
                    print("Short Link: \(response.shortLink)")
                    print("Preview: \(response.previewLink)")
                    print("QR Code: \(response.qrCodeUrl)")
                    
                    // Share the link or use it as needed
                    self.shareLink(response.shortLink)
                    
                case .error(let message):
                    print("Error creating dynamic link: \(message)")
                    self.showAlert(title: "Error", message: message)
                }
            }
        }
    }
    
    private func shareLink(_ link: String) {
        let activityViewController = UIActivityViewController(
            activityItems: [link],
            applicationActivities: nil
        )
        present(activityViewController, animated: true)
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
```

### 4. Custom Data Storage

```swift
// Store custom data
Bit2ConnectSDK.shared.storeCustomData(key: "user_preference", value: "dark_mode")

// Retrieve custom data
if let preference = Bit2ConnectSDK.shared.getCustomData(key: "user_preference") {
    print("User preference: \(preference)")
}

// Clear all custom data
Bit2ConnectSDK.shared.clearCustomData()
```

### 5. Info.plist Configuration

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
        <string>com.yourapp.https</string>
        <key>CFBundleURLSchemes</key>
        <array>
            <string>https</string>
        </array>
    </dict>
</array>
```

## Testing

### Test Deferred Deep Links

1. Create a dynamic link using the SDK
2. Open the link on a device without your app installed
3. Install your app
4. Launch the app - the deferred deep link should be processed

### Test Direct Deep Links

1. Create a dynamic link using the SDK
2. Open the link on a device with your app installed
3. The app should open and process the deep link immediately

## Troubleshooting

### Common Issues

1. **SDK not initializing**: Check your API key and base URL
2. **Deep links not working**: Verify URL schemes in Info.plist
3. **Deferred links not found**: Ensure the link was clicked before app installation

### Debug Mode

Enable debug mode during development:

```swift
Bit2ConnectSDK.shared.initialize(
    baseURL: "https://api.bit2connect.com",
    apiKey: "your-api-key",
    debugMode: true // Enable detailed logging
)
```

## Support

For issues or questions:
- Check the [main documentation](README.md)
- Review the [example app](../bit2connect-ios-example)
- Contact support at dev@bit2connect.com
