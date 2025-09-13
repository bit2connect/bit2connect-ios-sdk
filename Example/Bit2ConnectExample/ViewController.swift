import UIKit
import Bit2ConnectSDK

class ViewController: UIViewController {
    
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var createLinkButton: UIButton!
    @IBOutlet weak var testStorageButton: UIButton!
    @IBOutlet weak var clearDataButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        updateStatus()
    }
    
    private func setupUI() {
        title = "Bit2Connect SDK Example"
        
        createLinkButton.setTitle("Create Dynamic Link", for: .normal)
        testStorageButton.setTitle("Test Storage", for: .normal)
        clearDataButton.setTitle("Clear All Data", for: .normal)
        
        createLinkButton.addTarget(self, action: #selector(createDynamicLinkTapped), for: .touchUpInside)
        testStorageButton.addTarget(self, action: #selector(testStorageTapped), for: .touchUpInside)
        clearDataButton.addTarget(self, action: #selector(clearDataTapped), for: .touchUpInside)
    }
    
    private func updateStatus() {
        let isInitialized = Bit2ConnectSDK.shared.isSDKInitialized
        statusLabel.text = "SDK Status: \(isInitialized ? "Initialized" : "Not Initialized")"
        statusLabel.textColor = isInitialized ? .systemGreen : .systemRed
    }
    
    // MARK: - Actions
    
    @objc private func createDynamicLinkTapped() {
        let linkData = DynamicLinkData(
            deepLink: "https://example.com/product/123",
            campaign: "summer_sale",
            source: "email",
            medium: "newsletter",
            content: "banner_ad",
            term: "discount",
            customParameters: [
                "user_id": "12345",
                "feature": "premium"
            ],
            socialTitle: "Check out this amazing product!",
            socialDescription: "Get 50% off on all items",
            socialImageUrl: "https://example.com/images/product.jpg",
            androidPackageName: "com.example.app",
            iosBundleId: "com.example.app",
            fallbackUrl: "https://example.com/download"
        )
        
        Bit2ConnectSDK.shared.createDynamicLink(data: linkData) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    self.showAlert(
                        title: "Dynamic Link Created",
                        message: "Short Link: \(response.shortLink)\nPreview: \(response.previewLink)\nQR Code: \(response.qrCodeUrl)"
                    )
                case .error(let message):
                    self.showAlert(title: "Error", message: message)
                }
            }
        }
    }
    
    @objc private func testStorageTapped() {
        // Test storing data
        let success = Bit2ConnectSDK.shared.storeCustomData(key: "test_key", value: "test_value_\(Date().timeIntervalSince1970)")
        
        if success {
            // Test retrieving data
            if let retrievedValue = Bit2ConnectSDK.shared.getCustomData(key: "test_key") {
                showAlert(title: "Storage Test", message: "Successfully stored and retrieved: \(retrievedValue)")
            } else {
                showAlert(title: "Storage Test", message: "Failed to retrieve stored data")
            }
        } else {
            showAlert(title: "Storage Test", message: "Failed to store data")
        }
    }
    
    @objc private func clearDataTapped() {
        let success = Bit2ConnectSDK.shared.clearCustomData()
        showAlert(
            title: "Clear Data",
            message: success ? "All data cleared successfully" : "Failed to clear data"
        )
    }
    
    // MARK: - Helper Methods
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
