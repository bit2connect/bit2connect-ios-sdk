import Foundation

/// URL extensions for Bit2Connect SDK
extension URL {
    
    /// Check if URL is a deep link
    var isDeepLink: Bool {
        return scheme != nil && host != nil
    }
    
    /// Extract query parameters as dictionary
    var queryParameters: [String: String] {
        guard let components = URLComponents(url: self, resolvingAgainstBaseURL: false),
              let queryItems = components.queryItems else {
            return [:]
        }
        
        var parameters: [String: String] = [:]
        for item in queryItems {
            if let value = item.value {
                parameters[item.name] = value
            }
        }
        return parameters
    }
    
    /// Check if URL contains UTM parameters
    var hasUTMParameters: Bool {
        let utmParams = ["utm_source", "utm_medium", "utm_campaign", "utm_content", "utm_term"]
        return utmParams.contains { queryParameters.keys.contains($0) }
    }
    
    /// Get UTM parameters
    var utmParameters: [String: String] {
        let utmParams = ["utm_source", "utm_medium", "utm_campaign", "utm_content", "utm_term"]
        var utmDict: [String: String] = [:]
        
        for param in utmParams {
            if let value = queryParameters[param] {
                utmDict[param] = value
            }
        }
        
        return utmDict
    }
}
