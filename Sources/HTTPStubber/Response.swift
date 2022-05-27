import Foundation

public struct Response: Equatable {
    public var statusCode: Int?
    public var error: Error?
    public var headers: [String : String]?
    public var body: Data?
    
    public static func == (lhs: Response, rhs: Response) -> Bool {
        return lhs.statusCode == rhs.statusCode &&
            lhs.error?.localizedDescription == rhs.error?.localizedDescription &&
            lhs.headers == rhs.headers &&
            lhs.body == rhs.body
    }
}
