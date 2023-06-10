import Foundation

protocol Endpoint {
    
    /// The target's base `URL`.
    var baseURL: URL { get }

    /// The path to be appended to `baseURL` to form the full `URL`.
    var path: String { get }

    /// The HTTP method used in the request.
    var method: HTTPRequestMethod { get }
    
    /// The headers to be used in the request.
    var headers: [String: String]? { get }
    
    var queryItems: [URLQueryItem]? { get }
}

extension Endpoint {
    var finalURL: URL {
        var components = URLComponents()
        components.scheme = baseURL.scheme
        components.host = baseURL.host
        components.path = "\(baseURL.path)/\(path)"
        components.queryItems = !(queryItems?.isEmpty ?? false) ? queryItems : nil
        return components.url!
    }
}

enum HTTPRequestMethod: String {
    case get = "GET"
    case post = "POST"
}
