import Foundation

class SettingsBundleHelper {
    struct SettingsKeys {
        static let LaunchURL = "launch_url"
        static let Version = "version"
        static let Reset = "reset"
    }
    
    class func getLaunchURL() -> String? {
        return UserDefaults.standard.string(forKey: SettingsKeys.LaunchURL)
    }
    
    class func setLaunchURL(url: String) {
        UserDefaults.standard.set(url, forKey: SettingsKeys.LaunchURL)
    }
    
    class func setVersionNumber() {
        let version: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
        UserDefaults.standard.set(version, forKey: SettingsKeys.Version)
    }
    
    class func setDefaults() {
        if let settingsURL = Bundle.main.url(forResource: "Root", withExtension: "plist", subdirectory: "Settings.bundle"),
            let settingsPlist = NSDictionary(contentsOf: settingsURL),
            let preferences = settingsPlist["PreferenceSpecifiers"] as? [NSDictionary] {

            for prefSpecification in preferences {

                if let key = prefSpecification["Key"] as? String, let value = prefSpecification["DefaultValue"] {

                    // set default preference value if not set by user
                    if UserDefaults.standard.value(forKey: key) == nil {
                        UserDefaults.standard.set(value, forKey: key)
                        print("Set \(key) to default value: \(value)")
                    }
                }
            }
        }
    }
}
