import Foundation
import Security

/// Secure storage manager for handling sensitive data
internal class SecureStorageManager {
    static let shared = SecureStorageManager()
    
    private let service = "com.bit2connect.sdk"
    private let debugMode: Bool = false
    
    private init() {}
    
    /// Configure debug mode
    func configure(debugMode: Bool) {
        // Note: debugMode is immutable after initialization for security
    }
    
    /// Store data securely in Keychain
    func store(key: String, value: String) -> Bool {
        let data = value.data(using: .utf8)!
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: key,
            kSecValueData as String: data
        ]
        
        // Delete existing item first
        SecItemDelete(query as CFDictionary)
        
        // Add new item
        let status = SecItemAdd(query as CFDictionary, nil)
        
        if debugMode {
            print("[Bit2ConnectSDK] Stored key '\(key)' with status: \(status)")
        }
        
        return status == errSecSuccess
    }
    
    /// Retrieve data from Keychain
    func retrieve(key: String) -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: key,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        if status == errSecSuccess,
           let data = result as? Data,
           let value = String(data: data, encoding: .utf8) {
            if debugMode {
                print("[Bit2ConnectSDK] Retrieved key '\(key)' successfully")
            }
            return value
        }
        
        if debugMode {
            print("[Bit2ConnectSDK] Failed to retrieve key '\(key)' with status: \(status)")
        }
        
        return nil
    }
    
    /// Delete data from Keychain
    func delete(key: String) -> Bool {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: key
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        
        if debugMode {
            print("[Bit2ConnectSDK] Deleted key '\(key)' with status: \(status)")
        }
        
        return status == errSecSuccess
    }
    
    /// Clear all stored data
    func clearAll() -> Bool {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        
        if debugMode {
            print("[Bit2ConnectSDK] Cleared all data with status: \(status)")
        }
        
        return status == errSecSuccess
    }
    
    /// Check if key exists
    func exists(key: String) -> Bool {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: key,
            kSecReturnData as String: false,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        let status = SecItemCopyMatching(query as CFDictionary, nil)
        return status == errSecSuccess
    }
}
