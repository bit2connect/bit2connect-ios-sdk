import Foundation

/// Constants used throughout the Bit2Connect SDK
internal struct Constants {
    
    // MARK: - API Endpoints
    struct API {
        static let deferredLink = "/api/v1/deferred-link"
        static let dynamicLink = "/api/v1/dynamic-link"
    }
    
    // MARK: - Storage Keys
    struct StorageKeys {
        static let deviceId = "device_id"
        static let userId = "user_id"
        static let sessionId = "session_id"
        static let lastLinkData = "last_link_data"
        static let customDataPrefix = "custom_"
    }
    
    // MARK: - UTM Parameters
    struct UTMParameters {
        static let source = "utm_source"
        static let medium = "utm_medium"
        static let campaign = "utm_campaign"
        static let content = "utm_content"
        static let term = "utm_term"
    }
    
    // MARK: - Default Values
    struct Defaults {
        static let timeout: TimeInterval = 30
        static let maxRetries = 3
        static let debugPrefix = "[Bit2ConnectSDK]"
    }
    
    // MARK: - Error Messages
    struct ErrorMessages {
        static let notInitialized = "SDK not initialized. Call initialize() first."
        static let invalidURL = "Invalid URL provided"
        static let networkError = "Network error occurred"
        static let parsingError = "Error parsing response data"
        static let storageError = "Error accessing secure storage"
    }
}
