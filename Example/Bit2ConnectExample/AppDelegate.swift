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

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
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
