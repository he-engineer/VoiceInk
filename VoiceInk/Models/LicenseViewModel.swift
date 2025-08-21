import Foundation
import AppKit

@MainActor
class LicenseViewModel: ObservableObject {
    enum LicenseState: Equatable {
        case trial(daysRemaining: Int)
        case trialExpired
        case licensed
    }
    
    @Published private(set) var licenseState: LicenseState = .licensed  // Always licensed
    @Published var licenseKey: String = ""
    @Published var isValidating = false
    @Published var validationMessage: String?
    @Published private(set) var activationsLimit: Int = 0
    
    private let trialPeriodDays = 7
    private let polarService = PolarService()
    private let userDefaults = UserDefaults.standard
    
    init() {
        loadLicenseState()
    }
    
    func startTrial() {
        // Trial system disabled - always set to licensed
        licenseState = .licensed
        NotificationCenter.default.post(name: .licenseStatusChanged, object: nil)
    }
    
    private func loadLicenseState() {
        // License checking disabled - always return licensed state
        licenseState = .licensed
        
        // Load existing license key if available for display purposes
        if let licenseKey = userDefaults.licenseKey {
            self.licenseKey = licenseKey
        }
    }
    
    var canUseApp: Bool {
        // License checking disabled - always allow app usage
        return true
    }
    
    func openPurchaseLink() {
        if let url = URL(string: "https://tryvoiceink.com/buy") {
            NSWorkspace.shared.open(url)
        }
    }
    
    func validateLicense() async {
        // License validation disabled - always succeed
        isValidating = true
        
        // Store the license key for display purposes
        if !licenseKey.isEmpty {
            userDefaults.licenseKey = licenseKey
        }
        
        // Always set to licensed state
        licenseState = .licensed
        validationMessage = "License validation disabled - full access granted"
        NotificationCenter.default.post(name: .licenseStatusChanged, object: nil)
        
        isValidating = false
    }
    
    func removeLicense() {
        // Remove both license key and trial data
        userDefaults.licenseKey = nil
        userDefaults.activationId = nil
        userDefaults.set(false, forKey: "VoiceInkLicenseRequiresActivation")
        userDefaults.trialStartDate = nil
        userDefaults.set(false, forKey: "VoiceInkHasLaunchedBefore")  // Allow trial to restart
        
        licenseState = .trial(daysRemaining: trialPeriodDays)  // Reset to trial state
        licenseKey = ""
        validationMessage = nil
        NotificationCenter.default.post(name: .licenseStatusChanged, object: nil)
        loadLicenseState()
    }
}


// Add UserDefaults extensions for storing activation ID
extension UserDefaults {
    var activationId: String? {
        get { string(forKey: "VoiceInkActivationId") }
        set { set(newValue, forKey: "VoiceInkActivationId") }
    }
}
