import Foundation
import UIKit
import Alamofire
import SwiftyJSON

/// Network manager for handling API requests
internal class NetworkManager {
    static let shared = NetworkManager()
    
    private let session: Session
    private var baseURL: String = ""
    private var apiKey: String = ""
    private var debugMode: Bool = false
    
    private init() {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30
        configuration.timeoutIntervalForResource = 60
        
        self.session = Session(configuration: configuration)
    }
    
    /// Configure the network manager with base URL and API key
    func configure(baseURL: String, apiKey: String, debugMode: Bool = false) {
        self.baseURL = baseURL
        self.apiKey = apiKey
        self.debugMode = debugMode
    }
    
    /// Get deferred deep link data
    func getDeferredDeepLink(completion: @escaping (Result<LinkData?, Error>) -> Void) {
        let url = "\(baseURL)/api/v1/deferred-link"
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(apiKey)",
            "Content-Type": "application/json"
        ]
        
        let parameters: [String: Any] = [
            "device_id": getDeviceId(),
            "platform": "ios",
            "app_version": getAppVersion(),
            "os_version": getOSVersion()
        ]
        
        if debugMode {
            print("[Bit2ConnectSDK] Requesting deferred deep link from: \(url)")
        }
        
        session.request(url, method: .get, parameters: parameters, headers: headers)
            .validate()
            .responseData { [weak self] response in
                self?.handleResponse(response: response, completion: completion)
            }
    }
    
    /// Create dynamic link
    func createDynamicLink(data: DynamicLinkData, completion: @escaping (Result<DynamicLinkResponse, Error>) -> Void) {
        let url = "\(baseURL)/api/v1/dynamic-link"
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(apiKey)",
            "Content-Type": "application/json"
        ]
        
        do {
            let jsonData = try JSONEncoder().encode(data)
            let json = try JSON(data: jsonData)
            let parameters = json.dictionaryObject ?? [:]
            
            if debugMode {
                print("[Bit2ConnectSDK] Creating dynamic link: \(url)")
                print("[Bit2ConnectSDK] Parameters: \(parameters)")
            }
            
            session.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
                .validate()
                .responseData { [weak self] response in
                    self?.handleResponse(response: response, completion: completion)
                }
        } catch {
            completion(.failure(error))
        }
    }
    
    /// Handle API response
    private func handleResponse<T: Codable>(response: AFDataResponse<Data>, completion: @escaping (Result<T, Error>) -> Void) {
        if debugMode {
            print("[Bit2ConnectSDK] Response status: \(response.response?.statusCode ?? -1)")
        }
        
        switch response.result {
        case .success(let data):
            do {
                let decoder = JSONDecoder()
                let result = try decoder.decode(T.self, from: data)
                completion(.success(result))
            } catch {
                if debugMode {
                    print("[Bit2ConnectSDK] Decoding error: \(error)")
                }
                completion(.failure(error))
            }
        case .failure(let error):
            if debugMode {
                print("[Bit2ConnectSDK] Network error: \(error)")
            }
            completion(.failure(error))
        }
    }
    
    /// Get device identifier
    private func getDeviceId() -> String {
        return UIDevice.current.identifierForVendor?.uuidString ?? "unknown"
    }
    
    /// Get app version
    private func getAppVersion() -> String {
        return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "unknown"
    }
    
    /// Get OS version
    private func getOSVersion() -> String {
        return UIDevice.current.systemVersion
    }
}
