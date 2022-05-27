import Foundation
@testable import HTTPStubber

final class UTURLProtocol: Foundation.URLProtocol, HTTPStubber.URLProtocol {
    private(set) static var stubs: [Stub] = []
    private(set) static var isTestEnvironment: Bool = false
    
    static func addStub(_ stub: Stub) {
        stubs.append(stub)
    }
    
    static func removeStub(_ stub: Stub) {
    }
    
    static func removeAllStubs() {
    }
    
    static func stub(for request: URLRequest) -> Stub? {
        return nil
    }
    
    static func setTestEnvironment(_ value: Bool = true) {
    }
    
    static func register() {
        Foundation.URLProtocol.registerClass(Self.self)
    }
    
    static func unregister() {
        Foundation.URLProtocol.unregisterClass(Self.self)
    }
}
