import Foundation

public protocol URLProtocol where Self: Foundation.URLProtocol {
    static func addStub(_ stub: Stub)
    static func removeStub(_ stub: Stub)
    static func removeAllStubs()
    static func setTestEnvironment(_ value: Bool)
    static func register()
    static func unregister()
}

public final class StubURLProtocol: Foundation.URLProtocol, URLProtocol {
    // MARK: - Properties
    
    static var stubs: [Stub] = []
    static var isTestEnvironment: Bool = false
    
    // MARK: - Stubs management
    
    public static func addStub(_ stub: Stub) {
        if !stubs.contains(stub) {
            stubs.append(stub)
        }
    }
    
    public static func removeStub(_ stub: Stub) {
        stubs.removeAll { $0 == stub }
    }
    
    public static func removeAllStubs() {
        stubs.removeAll()
    }
    
    public static func setTestEnvironment(_ value: Bool = true) {
        isTestEnvironment = value
    }
    
    public static func register() {
        Foundation.URLProtocol.registerClass(Self.self)
    }
    
    public static func unregister() {
        Foundation.URLProtocol.unregisterClass(Self.self)
    }
    
    private static func stub(for request: URLRequest) -> Stub? {
        stubs.first {
            ($0.request.host == nil ? true : $0.request.host == request.url?.host) &&
            ($0.request.query == nil ? true : $0.request.query?.queryString == request.url?.query) &&
            $0.request.path == request.url?.path &&
            $0.request.method == request.httpMethod
        }
    }
    
    //MARK: - URLProtocol
    
    public override class func canInit(with request: URLRequest) -> Bool {
        return isTestEnvironment || stub(for: request) != nil
    }
    
    public override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    public override func startLoading() {
        guard let stub = Self.stub(for: request) else {
            client?.urlProtocol(self, didFailWithError: NSError.unexpectedHTTP(request: request))
            return
        }
        
        if let error = stub.response.error {
            client?.urlProtocol(self, didFailWithError: error)
        } else {
            if Self.isTestEnvironment && (stub.request.headers ?? [:]) != (request.allHTTPHeaderFields ?? [:]) {
                let error = NSError.unexpectedHTTP(
                    requestHeaders: request.allHTTPHeaderFields,
                    stubHeaders: stub.request.headers
                )
                client?.urlProtocol(self, didFailWithError: error)
                return
            }
            
            if Self.isTestEnvironment && (stub.request.body ?? Data()) != (request.httpBody ?? Data()) {
                let error = NSError.unexpectedHTTP(
                    requestBody: request.httpBody,
                    stubBody: stub.request.body
                )
                client?.urlProtocol(self, didFailWithError: error)
                return
            }
            
            let response = HTTPURLResponse(
                url: request.url!,
                statusCode: stub.response.statusCode ?? 200,
                httpVersion: nil,
                headerFields: stub.response.headers
            )!
            
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            client?.urlProtocol(self, didLoad: stub.response.body ?? Data())
            client?.urlProtocolDidFinishLoading(self)
        }
    }
    
    public override func stopLoading() {}
}