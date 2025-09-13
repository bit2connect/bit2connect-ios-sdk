import Foundation

/// Result of direct deep link handling operation
public enum DirectLinkResult {
    /// Successfully parsed direct deep link data
    case success(LinkData)
    
    /// Error occurred during the operation
    case error(String)
}

// MARK: - Equatable
extension DirectLinkResult: Equatable {
    public static func == (lhs: DirectLinkResult, rhs: DirectLinkResult) -> Bool {
        switch (lhs, rhs) {
        case (.success(let lhsData), .success(let rhsData)):
            return lhsData == rhsData
        case (.error(let lhsMessage), .error(let rhsMessage)):
            return lhsMessage == rhsMessage
        default:
            return false
        }
    }
}

// MARK: - Hashable
extension DirectLinkResult: Hashable {
    public func hash(into hasher: inout Hasher) {
        switch self {
        case .success(let data):
            hasher.combine("success")
            hasher.combine(data)
        case .error(let message):
            hasher.combine("error")
            hasher.combine(message)
        }
    }
}
