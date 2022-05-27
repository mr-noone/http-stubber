import Foundation

extension URLSessionConfiguration {
    public func withStubURLProtocol(_ protocol: URLProtocol.Type = StubURLProtocol.self) -> URLSessionConfiguration {
        guard !(protocolClasses?.contains { $0 == `protocol` } ?? false) else { return self }
        if protocolClasses == nil {
            protocolClasses = [`protocol`]
        } else {
            protocolClasses?.insert(`protocol`, at: 0)
        }
        return self
    }
}
