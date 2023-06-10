import Foundation

enum NewsEndpoint {
    case fetchNews(countryISO: String?, category: NewsCategory?)
    
    struct Constants {
        static let baseUrl: String = {
            guard let path = Bundle.main.path(forResource: "Info", ofType: "plist"),
            let dict = NSDictionary(contentsOfFile: path),
                  let url = dict["SERVER_URL"] as? String
            else {return ""}
            return url
        }()
        static let newsTopHeadlines = "top-headlines"
        static let apiKeyHeader = "apiKey"
        static let apiKeyValue = "0c093ffbfc264d4d8cd59f91091f5f19"
        static let countryKey = "country"
        static let categoryKey = "category"
    }
}

extension NewsEndpoint: Endpoint {
    var environmentBaseURL: String {
        return Constants.baseUrl
    }
    
    var baseURL: URL {
        guard let url = URL(string: environmentBaseURL) else { fatalError("baseURL could not be configured.")}
        return url
    }
    
    var path: String {
        switch self {
        case .fetchNews:
            return Constants.newsTopHeadlines
        }
    }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case .fetchNews(let countryISO, let category):
            var urlQueryItems = [
                URLQueryItem(name: Constants.apiKeyHeader, value: Constants.apiKeyValue)
            ]
            if let countryISO = countryISO {
                urlQueryItems.append(URLQueryItem(name: Constants.countryKey, value: countryISO))
            }
            if let category = category, category != .allNews {
                urlQueryItems.append(URLQueryItem(name: Constants.categoryKey, value: category.rawValue))
            }
            return urlQueryItems
        }
        
    }
    
    var method: HTTPRequestMethod {
        switch self {
        case .fetchNews:
            return .get
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .fetchNews:
            return nil
        }
    }
}
