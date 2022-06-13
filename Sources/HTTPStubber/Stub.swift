import Foundation
import Combine

public final class Stub: Equatable {
    // MARK: - Inits
    
    public private(set) var request: Request
    public private(set) var response: Response
    
    // MARK: - Inits
    
    public init(method: String = "GET", path: String = "", host: String? = nil) {
        request = Request(method: method, path: path, host: host)
        response = Response(statusCode: 201)
    }
    
    /// Initialize a `Stub` with the contents of a `URL`.
    ///
    /// The file must contain raw HTTP request data:
    /// ```
    /// POST /path/to HTTP/1.1
    /// Host: 127.0.0.1
    /// Content-Type: application/json
    ///
    /// {"key":"value"}
    /// ```
    ///
    /// - Parameter url: The `URL` to read.
    /// - Throws: An error in the Cocoa domain, if `url` cannot be read.
    public convenience init?(contentsOf url: URL) throws {
        self.init(data: try Data(contentsOf: url))
    }
    
    /// Initialize a `Stub` with the contents of string.
    ///
    /// The string must contain raw HTTP request data:
    /// ```
    /// POST /path/to HTTP/1.1
    /// Host: 127.0.0.1
    /// Content-Type: application/json
    ///
    /// {"key":"value"}
    /// ```
    ///
    /// - Parameter string: The string contains of raw HTTP request data.
    public convenience init?(string: String) {
        guard let data = string.data(using: .utf8) else {
            return nil
        }
        self.init(data: data)
    }
    
    
    /// Initialize a `Stub` with the contents of data.
    /// - Parameter data: The data contains of raw HTTP request data.
    public init?(data: Data) {
        let message = HTTPMessage(data: data, isRequest: true)
        guard let method = message.method,
              let path = message.path
        else { return nil }
        
        request = Request(method: method, path: path, host: message.host)
        request.headers = message.headers
        request.body = message.body
        
        response = Response(statusCode: 201)
    }
    
    // MARK: - Equatable
    
    public static func == (lhs: Stub, rhs: Stub) -> Bool {
        return lhs.request == rhs.request && lhs.response == rhs.response
    }
    
    // MARK: - Request methods
    
    public func setRequest(queryItems: [URLQueryItem]) -> Stub {
        request.query = queryItems
        return self
    }
    
    public func setRequest(headers: [String : String]) -> Stub {
        request.headers = headers
        return self
    }
    
    public func setRequest(header key: String, value: String) -> Stub {
        if request.headers == nil {
            request.headers = [key : value]
        } else {
            request.headers?[key] = value
        }
        return self
    }
    
    public func setRequest(body string: String, using encoding: String.Encoding = .utf8) -> Stub {
        request.body = string.data(using: encoding)
        return self
    }
    
    @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    public func setRequest<T: Encodable, E: TopLevelEncoder>(body value: T, encoder: E) throws -> Stub where E.Output == Data {
        request.body = try encoder.encode(value)
        return self
    }
    
    public func setRequest(body data: Data) -> Stub {
        request.body = data
        return self
    }
    
    public func setRequest(bodyContentsOf url: URL) throws -> Stub {
        request.body = try Data(contentsOf: url)
        return self
    }
    
    // MARK: - Response methods
    
    /// Returns new stub made by setting response with the contents of a `URL`.
    ///
    /// The file must contain raw HTTP response data:
    /// ```
    /// HTTP/1.1 200 OK
    /// Keep-Alive: 5
    /// Content-Length: 40
    /// Content-Type: application/json
    /// Proxy-Connection: Keep-alive
    ///
    /// {"message":"ok","order_id":"D74876021"}
    /// ```
    /// 
    /// - Parameter url: The `URL` to read.
    /// - Returns: A new stub made by setting response with the contents of a `URL`.
    /// - Throws: An error in the Cocoa domain, if `url` cannot be read.
    public func setResponse(contentsOf url: URL) throws -> Stub {
        return setResponse(from: try Data(contentsOf: url))
    }
    
    /// Returns new stub made by setting response with the contents of a `string`.
    ///
    /// The string must contain raw HTTP response data:
    /// ```
    /// HTTP/1.1 200 OK
    /// Keep-Alive: 5
    /// Content-Length: 40
    /// Content-Type: application/json
    /// Proxy-Connection: Keep-alive
    ///
    /// {"message":"ok","order_id":"D74876021"}
    /// ```
    ///
    /// - Parameter string: The string contains of raw HTTP request data.
    /// - Returns: A new stub made by setting response with the contents of a `string`.
    public func setResponse(from string: String) -> Stub? {
        guard let data = string.data(using: .utf8) else { return nil }
        return setResponse(from: data)
    }
    
    /// Returns new stub made by setting response with the contents of a `data`.
    /// - Parameter data: The data contains of raw HTTP response data.
    /// - Returns: A new stub made by setting response with the contents of a `data`.
    public func setResponse(from data: Data) -> Stub {
        let message = HTTPMessage(data: data, isRequest: false)
        response.statusCode = message.statusCode
        response.headers = message.headers
        response.body = message.body
        return self
    }
    
    /// Returns new stub made by setting response with an `error`.
    /// - Parameter error: An error for response.
    /// - Returns: A new stub made by setting response with an `error`.
    public func setResponse(failWith error: Error) -> Stub {
        response = Response(error: error)
        return self
    }
    
    public func setResponse(statusCode: Int) -> Stub {
        response.statusCode = statusCode
        return self
    }
    
    public func setResponse(headers: [String : String]) -> Stub {
        response.headers = headers
        return self
    }
    
    public func setResponse(header key: String, value: String) -> Stub {
        if response.headers == nil {
            response.headers = [key : value]
        } else {
            response.headers?[key] = value
        }
        return self
    }
    
    public func setResponse(body string: String, using encoding: String.Encoding = .utf8) -> Stub {
        response.body = string.data(using: encoding)
        return self
    }
    
    @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    public func setResponse<T: Encodable, E: TopLevelEncoder>(body value: T, encoder: E) throws -> Stub where E.Output == Data {
        response.body = try encoder.encode(value)
        return self
    }
    
    
    public func setResponse(body data: Data) -> Stub {
        response.body = data
        return self
    }
    
    public func setResponse(bodyContentsOf url: URL) throws -> Stub {
        response.body = try Data(contentsOf: url)
        return self
    }
    
    @discardableResult
    public func inject(into protocol: URLProtocol.Type = StubURLProtocol.self) -> Stub {
        `protocol`.addStub(self)
        return self
    }
}
