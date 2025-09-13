import XCTest
@testable import Bit2ConnectSDK

final class Bit2ConnectSDKTests: XCTestCase {
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testSDKInitialization() throws {
        let sdk = Bit2ConnectSDK.shared
        XCTAssertFalse(sdk.isSDKInitialized)
        
        sdk.initialize(baseURL: "https://api.test.com", apiKey: "test-key", debugMode: true)
        XCTAssertTrue(sdk.isSDKInitialized)
    }
    
    func testLinkDataCreation() throws {
        let linkData = LinkData(
            originalUrl: "https://example.com/product/123?utm_campaign=summer_sale",
            path: "/product/123",
            parameters: ["utm_campaign": "summer_sale"],
            campaign: "summer_sale",
            source: "email",
            medium: "newsletter"
        )
        
        XCTAssertEqual(linkData.originalUrl, "https://example.com/product/123?utm_campaign=summer_sale")
        XCTAssertEqual(linkData.path, "/product/123")
        XCTAssertEqual(linkData.campaign, "summer_sale")
        XCTAssertEqual(linkData.source, "email")
        XCTAssertEqual(linkData.medium, "newsletter")
    }
    
    func testDynamicLinkDataCreation() throws {
        let dynamicLinkData = DynamicLinkData(
            deepLink: "https://example.com/product/123",
            campaign: "summer_sale",
            source: "email",
            medium: "newsletter",
            customParameters: ["user_id": "12345"],
            socialTitle: "Amazing Product",
            socialDescription: "Check this out!",
            iosBundleId: "com.example.app"
        )
        
        XCTAssertEqual(dynamicLinkData.deepLink, "https://example.com/product/123")
        XCTAssertEqual(dynamicLinkData.campaign, "summer_sale")
        XCTAssertEqual(dynamicLinkData.customParameters["user_id"], "12345")
        XCTAssertEqual(dynamicLinkData.iosBundleId, "com.example.app")
    }
    
    func testSecureStorage() throws {
        let sdk = Bit2ConnectSDK.shared
        sdk.initialize(baseURL: "https://api.test.com", apiKey: "test-key", debugMode: true)
        
        // Test storing data
        let success = sdk.storeCustomData(key: "test_key", value: "test_value")
        XCTAssertTrue(success)
        
        // Test retrieving data
        let retrievedValue = sdk.getCustomData(key: "test_key")
        XCTAssertEqual(retrievedValue, "test_value")
        
        // Test deleting data
        let deleteSuccess = sdk.deleteCustomData(key: "test_key")
        XCTAssertTrue(deleteSuccess)
        
        // Test that data is deleted
        let deletedValue = sdk.getCustomData(key: "test_key")
        XCTAssertNil(deletedValue)
    }
    
    func testURLParsing() throws {
        let url = URL(string: "https://example.com/product/123?utm_campaign=summer_sale&utm_source=email")!
        
        let components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        XCTAssertNotNil(components)
        
        let parameters = url.queryParameters
        XCTAssertEqual(parameters["utm_campaign"], "summer_sale")
        XCTAssertEqual(parameters["utm_source"], "email")
        
        XCTAssertTrue(url.hasUTMParameters)
        
        let utmParams = url.utmParameters
        XCTAssertEqual(utmParams["utm_campaign"], "summer_sale")
        XCTAssertEqual(utmParams["utm_source"], "email")
    }
    
    func testResultTypes() throws {
        // Test DeferredLinkResult
        let linkData = LinkData(originalUrl: "https://example.com", path: "/", parameters: [:])
        let successResult = DeferredLinkResult.success(linkData)
        let noLinkResult = DeferredLinkResult.noLink
        let errorResult = DeferredLinkResult.error("Test error")
        
        XCTAssertNotEqual(successResult, noLinkResult)
        XCTAssertNotEqual(successResult, errorResult)
        XCTAssertNotEqual(noLinkResult, errorResult)
        
        // Test DynamicLinkResult
        let response = DynamicLinkResponse(shortLink: "https://short.ly/abc", previewLink: "https://preview.ly/abc", qrCodeUrl: "https://qr.ly/abc")
        let dynamicSuccessResult = DynamicLinkResult.success(response)
        let dynamicErrorResult = DynamicLinkResult.error("Test error")
        
        XCTAssertNotEqual(dynamicSuccessResult, dynamicErrorResult)
        
        // Test DirectLinkResult
        let directSuccessResult = DirectLinkResult.success(linkData)
        let directErrorResult = DirectLinkResult.error("Test error")
        
        XCTAssertNotEqual(directSuccessResult, directErrorResult)
    }
}
