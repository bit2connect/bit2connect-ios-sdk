import Foundation

/// Result of dynamic link creation operation
public enum DynamicLinkResult {
    /// Successfully created dynamic link
    case success(DynamicLinkResponse)
    
    /// Error occurred during the operation
    case error(String)
}

/// Response data for successful dynamic link creation
public struct DynamicLinkResponse {
    /// The short link URL
    public let shortLink: String
    
    /// Preview link for testing
    public let previewLink: String
    
    /// QR code image URL
    public let qrCodeUrl: String
    
    public init(shortLink: String, previewLink: String, qrCodeUrl: String) {
        self.shortLink = shortLink
        self.previewLink = previewLink
        self.qrCodeUrl = qrCodeUrl
    }
}

// MARK: - Codable
extension DynamicLinkResponse: Codable {}

// MARK: - Equatable
extension DynamicLinkResponse: Equatable {}

// MARK: - Hashable
extension DynamicLinkResponse: Hashable {}

// MARK: - Equatable
extension DynamicLinkResult: Equatable {
    public static func == (lhs: DynamicLinkResult, rhs: DynamicLinkResult) -> Bool {
        switch (lhs, rhs) {
        case (.success(let lhsResponse), .success(let rhsResponse)):
            return lhsResponse == rhsResponse
        case (.error(let lhsMessage), .error(let rhsMessage)):
            return lhsMessage == rhsMessage
        default:
            return false
        }
    }
}

// MARK: - Hashable
extension DynamicLinkResult: Hashable {
    public func hash(into hasher: inout Hasher) {
        switch self {
        case .success(let response):
            hasher.combine("success")
            hasher.combine(response)
        case .error(let message):
            hasher.combine("error")
            hasher.combine(message)
        }
    }
}
