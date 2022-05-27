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
        self.path = path
        self.host = host
    }
}
