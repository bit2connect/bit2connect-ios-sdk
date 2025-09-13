import Foundation

/// Data structure for creating dynamic links
public struct DynamicLinkData {
    /// The deep link URL that will be opened when the dynamic link is clicked
    public let deepLink: String
    
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
    
    /// Custom parameters to be included in the link
    public let customParameters: [String: String]
    
    /// Social media title for link previews
    public let socialTitle: String?
    
    /// Social media description for link previews
    public let socialDescription: String?
    
    /// Social media image URL for link previews
    public let socialImageUrl: String?
    
    /// Android package name for app store fallback
    public let androidPackageName: String?
    
    /// iOS bundle identifier for app store fallback
    public let iosBundleId: String?
    
    /// Fallback URL when app is not installed
    public let fallbackUrl: String?
    
    public init(
        deepLink: String,
        campaign: String? = nil,
        source: String? = nil,
        medium: String? = nil,
        content: String? = nil,
        term: String? = nil,
        customParameters: [String: String] = [:],
        socialTitle: String? = nil,
        socialDescription: String? = nil,
        socialImageUrl: String? = nil,
        androidPackageName: String? = nil,
        iosBundleId: String? = nil,
        fallbackUrl: String? = nil
    ) {
        self.deepLink = deepLink
        self.campaign = campaign
        self.source = source
        self.medium = medium
        self.content = content
        self.term = term
        self.customParameters = customParameters
        self.socialTitle = socialTitle
        self.socialDescription = socialDescription
        self.socialImageUrl = socialImageUrl
        self.androidPackageName = androidPackageName
        self.iosBundleId = iosBundleId
        self.fallbackUrl = fallbackUrl
    }
}

// MARK: - Codable
extension DynamicLinkData: Codable {}

// MARK: - Equatable
extension DynamicLinkData: Equatable {}

// MARK: - Hashable
extension DynamicLinkData: Hashable {}
