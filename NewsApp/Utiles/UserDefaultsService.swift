import Foundation

class UserDefaultsService: NSObject {

    static let sharedInstance = UserDefaultsService()

    private override init () { }

    private let userDefault = UserDefaults.standard

    var firstLaunch: Bool? {
        get {
            return userDefault.value(forKey: "com.NewsApp.firstLaunch") as? Bool
        }
        set {
            userDefault.set(newValue, forKey: "com.NewsApp.firstLaunch")
        }
    }
    
    var lastfetch: Date? {
        get {
            return userDefault.value(forKey: "com.NewsApp.lastfetch") as? Date
        }
        set {
            userDefault.set(newValue, forKey: "com.NewsApp.lastfetch")
        }
    }

}
