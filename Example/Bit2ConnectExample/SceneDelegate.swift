import UIKit
import Bit2ConnectSDK

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: windowScene)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateInitialViewController()
        window?.rootViewController = viewController
        window?.makeKeyAndVisible()
        
        // Handle deep link from scene connection options
        if let urlContext = connectionOptions.urlContexts.first {
            handleDeepLink(url: urlContext.url)
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
    }

    func sceneWillResignActive(_ scene: UIScene) {
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
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
