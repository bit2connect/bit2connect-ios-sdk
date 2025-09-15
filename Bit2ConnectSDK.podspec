Pod::Spec.new do |spec|
  spec.name         = "Bit2ConnectSDK"
  spec.version      = "1.0.1"
  spec.summary      = "iOS SDK for handling deferred deep linking and dynamic link creation"
  spec.description  = <<-DESC
                      Bit2Connect iOS SDK provides comprehensive functionality for handling deferred deep linking and dynamic link creation. 
                      Track user attribution and handle deep links even when your app is not installed.
                      Available via CocoaPods and Swift Package Manager for maximum flexibility.
                      DESC

  spec.homepage     = "https://bit2connect.com"
  spec.license      = { :type => "MIT", :file => "LICENSE" }
  spec.author       = { "Bit2Connect Team" => "dev@bit2connect.com" }
  
  spec.platform     = :ios, "13.0"
  spec.swift_version = "5.0"

  spec.source       = { :git => "https://github.com/bit2connect/bit2connect-ios-sdk.git", :tag => "#{spec.version}" }
  spec.source_files = "Bit2ConnectSDK/Sources/Bit2ConnectSDK/**/*.swift"
  
  spec.dependency "Alamofire", "~> 5.8"
  spec.dependency "SwiftyJSON", "~> 5.0"
  
  spec.requires_arc = true
end
