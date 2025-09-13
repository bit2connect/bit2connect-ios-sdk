import Foundation

/// Result of deferred deep link handling operation
public enum DeferredLinkResult {
    /// Successfully retrieved deferred deep link data
    case success(LinkData)
    
    /// No deferred deep link found
    case noLink
    
    /// Error occurred during the operation
    case error(String)
}

// MARK: - Equatable
extension DeferredLinkResult: Equatable {
    public static func == (lhs: DeferredLinkResult, rhs: DeferredLinkResult) -> Bool {
        switch (lhs, rhs) {
        case (.success(let lhsData), .success(let rhsData)):
            return lhsData == rhsData
        case (.noLink, .noLink):
            return true
        case (.error(let lhsMessage), .error(let rhsMessage)):
            return lhsMessage == rhsMessage
        default:
            return false
        }
    }
}

// MARK: - Hashable
extension DeferredLinkResult: Hashable {
    public func hash(into hasher: inout Hasher) {
        switch self {
        case .success(let data):
            hasher.combine("success")
            hasher.combine(data)
        case .noLink:
            hasher.combine("noLink")
        case .error(let message):
            hasher.combine("error")
            hasher.combine(message)
        }
    }
}
