import Foundation

extension Array where Element == URLQueryItem {
    var queryString: String? {
        var components = URLComponents()
        components.queryItems = self
        return components.percentEncodedQuery
    }
}
