import Foundation

public struct Request: Equatable {
    public let method: String
    public let path: String
    public let host: String?
    public var query: [URLQueryItem]?
    public var headers: [String : String]?
    public var body: Data?
    
    // MARK: - Inits
    
    init(method: String, path: String, host: String?) {
        self.method = method
        self.path = Self.format(path: path)
        self.host = Self.format(host: host)
    }
    
    // MARK: - Private
    
    private static func format(path: String) -> String {
        path.first == "/" || path.isEmpty ? path : path.inserted("/", at: path.startIndex)
    }
    
    private static func format(host: String?) -> String? {
        let host = try? host?
            .replacingCharacters(matche: "^[a-zA-Z]*(?=:\\/\\/):\\/\\/", with: "")
            .trimmingCharacters(in: CharacterSet(charactersIn: "/"))
        return host?.isEmpty ?? true ? nil : host
    }
}
