import Foundation

/// Represents link data with campaign information
public struct LinkData {
    /// The original URL that was clicked
    public let originalUrl: String
    
    /// The path component of the URL
    public let path: String
    
    /// Query parameters from the URL
    public let parameters: [String: String]
    
    /// Campaign name (utm_campaign)
    public let campaign: String?
    
    /// Traffic source (utm_source)
    public let source: String?
    
    /// Traffic medium (utm_medium)
    public let medium: String?
    
    /// Content identifier (utm_content)
    public let content: String?
    
    /// Search term (utm_term)
    public let term: String?
    
    public init(
        originalUrl: String,
        path: String,
        parameters: [String: String],
        campaign: String? = nil,
        source: String? = nil,
        medium: String? = nil,
        content: String? = nil,
        term: String? = nil
    ) {
        self.originalUrl = originalUrl
        self.path = path
        self.parameters = parameters
        self.campaign = campaign
        self.source = source
        self.medium = medium
        self.content = content
        self.term = term
    }
}

// MARK: - Codable
extension LinkData: Codable {}

// MARK: - Equatable
extension LinkData: Equatable {}

// MARK: - Hashable
extension LinkData: Hashable {}
