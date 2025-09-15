import Foundation
#if canImport(UIKit)
import UIKit
#endif

/// Main SDK class for Bit2Connect functionality
public class Bit2ConnectSDK {
    
    // MARK: - Singleton
    public static let shared = Bit2ConnectSDK()
    
    // MARK: - Properties
    private let networkManager = NetworkManager.shared
    private let storageManager = SecureStorageManager.shared
    private var isInitialized = false
    private var debugMode = false
    
    // MARK: - Initialization
    private init() {}
    
    /// Initialize the SDK with configuration
    /// - Parameters:
    ///   - baseURL: Base URL for the Bit2Connect API
    ///   - apiKey: API key for authentication
    ///   - debugMode: Enable debug logging (default: false)
    public func initialize(baseURL: String, apiKey: String, debugMode: Bool = false) {
        self.debugMode = debugMode
        self.isInitialized = true
        
        networkManager.configure(baseURL: baseURL, apiKey: apiKey, debugMode: debugMode)
        storageManager.configure(debugMode: debugMode)
        
        if debugMode {
            print("[Bit2ConnectSDK] Initialized with baseURL: \(baseURL)")
        }
    }
    
    /// Check if SDK is initialized
    public var isSDKInitialized: Bool {
        return isInitialized
    }
    
    /// Set debug mode
    public func setDebugMode(_ enabled: Bool) {
        self.debugMode = enabled
        if debugMode {
            print("[Bit2ConnectSDK] Debug mode enabled")
        }
    }
    
    // MARK: - Deferred Deep Link Handling
    
    /// Handle deferred deep link when app starts
    /// - Parameter completion: Completion handler with result
    public func handleDeferredDeepLink(completion: @escaping (DeferredLinkResult) -> Void) {
        guard isInitialized else {
            completion(.error("SDK not initialized. Call initialize() first."))
            return
        }
        
        if debugMode {
            print("[Bit2ConnectSDK] Handling deferred deep link...")
        }
        
        networkManager.getDeferredDeepLink { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let linkData):
                    if let linkData = linkData {
                        if self.debugMode {
                            print("[Bit2ConnectSDK] Deferred deep link found: \(linkData.originalUrl)")
                        }
                        completion(.success(linkData))
                    } else {
                        if self.debugMode {
                            print("[Bit2ConnectSDK] No deferred deep link found")
                        }
                        completion(.noLink)
                    }
                case .failure(let error):
                    if self.debugMode {
                        print("[Bit2ConnectSDK] Error getting deferred deep link: \(error)")
                    }
                    completion(.error(error.localizedDescription))
                }
            }
        }
    }
    
    // MARK: - Dynamic Link Creation
    
    /// Create a dynamic link
    /// - Parameters:
    ///   - data: Dynamic link data
    ///   - completion: Completion handler with result
    public func createDynamicLink(data: DynamicLinkData, completion: @escaping (DynamicLinkResult) -> Void) {
        guard isInitialized else {
            completion(.error("SDK not initialized. Call initialize() first."))
            return
        }
        
        if debugMode {
            print("[Bit2ConnectSDK] Creating dynamic link for: \(data.deepLink)")
        }
        
        networkManager.createDynamicLink(data: data) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    if self.debugMode {
                        print("[Bit2ConnectSDK] Dynamic link created: \(response.shortLink)")
                    }
                    completion(.success(response))
                case .failure(let error):
                    if self.debugMode {
                        print("[Bit2ConnectSDK] Error creating dynamic link: \(error)")
                    }
                    completion(.error(error.localizedDescription))
                }
            }
        }
    }
    
    // MARK: - Direct Deep Link Handling
    
    /// Handle direct deep link from URL
    /// - Parameters:
    ///   - url: The URL to parse
    ///   - completion: Completion handler with result
    public func handleDirectDeepLink(url: URL, completion: @escaping (DirectLinkResult) -> Void) {
        guard isInitialized else {
            completion(.error("SDK not initialized. Call initialize() first."))
            return
        }
        
        if debugMode {
            print("[Bit2ConnectSDK] Handling direct deep link: \(url.absoluteString)")
        }
        
        do {
            let linkData = try parseURL(url)
            if debugMode {
                print("[Bit2ConnectSDK] Successfully parsed direct deep link")
            }
            completion(.success(linkData))
        } catch {
            if debugMode {
                print("[Bit2ConnectSDK] Error parsing direct deep link: \(error)")
            }
            completion(.error(error.localizedDescription))
        }
    }
    
    /// Parse URL into LinkData
    private func parseURL(_ url: URL) throws -> LinkData {
        let components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        
        guard let components = components else {
            throw NSError(domain: "Bit2ConnectSDK", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])
        }
        
        var parameters: [String: String] = [:]
        if let queryItems = components.queryItems {
            for item in queryItems {
                if let value = item.value {
                    parameters[item.name] = value
                }
            }
        }
        
        let path = components.path
        let campaign = parameters["utm_campaign"]
        let source = parameters["utm_source"]
        let medium = parameters["utm_medium"]
        let content = parameters["utm_content"]
        let term = parameters["utm_term"]
        
        return LinkData(
            originalUrl: url.absoluteString,
            path: path,
            parameters: parameters,
            campaign: campaign,
            source: source,
            medium: medium,
            content: content,
            term: term
        )
    }
    
    // MARK: - Secure Storage
    
    /// Store custom data securely
    /// - Parameters:
    ///   - key: Storage key
    ///   - value: Value to store
    /// - Returns: Success status
    @discardableResult
    public func storeCustomData(key: String, value: String) -> Bool {
        guard isInitialized else {
            if debugMode {
                print("[Bit2ConnectSDK] SDK not initialized. Call initialize() first.")
            }
            return false
        }
        
        let success = storageManager.store(key: key, value: value)
        if debugMode {
            print("[Bit2ConnectSDK] Stored custom data '\(key)': \(success)")
        }
        return success
    }
    
    /// Retrieve custom data
    /// - Parameter key: Storage key
    /// - Returns: Stored value or nil
    public func getCustomData(key: String) -> String? {
        guard isInitialized else {
            if debugMode {
                print("[Bit2ConnectSDK] SDK not initialized. Call initialize() first.")
            }
            return nil
        }
        
        let value = storageManager.retrieve(key: key)
        if debugMode {
            print("[Bit2ConnectSDK] Retrieved custom data '\(key)': \(value != nil)")
        }
        return value
    }
    
    /// Delete custom data
    /// - Parameter key: Storage key
    /// - Returns: Success status
    @discardableResult
    public func deleteCustomData(key: String) -> Bool {
        guard isInitialized else {
            if debugMode {
                print("[Bit2ConnectSDK] SDK not initialized. Call initialize() first.")
            }
            return false
        }
        
        let success = storageManager.delete(key: key)
        if debugMode {
            print("[Bit2ConnectSDK] Deleted custom data '\(key)': \(success)")
        }
        return success
    }
    
    /// Clear all custom data
    /// - Returns: Success status
    @discardableResult
    public func clearCustomData() -> Bool {
        guard isInitialized else {
            if debugMode {
                print("[Bit2ConnectSDK] SDK not initialized. Call initialize() first.")
            }
            return false
        }
        
        let success = storageManager.clearAll()
        if debugMode {
            print("[Bit2ConnectSDK] Cleared all custom data: \(success)")
        }
        return success
    }
}
