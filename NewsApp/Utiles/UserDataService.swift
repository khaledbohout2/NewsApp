import Foundation

class UserDataService: NSObject {

    static let sharedInstance = UserDataService()

    private override init () { }

    var selectedFilters: (Country, NewsCategory)?

}
