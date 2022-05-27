import Foundation

final class UTURLProtocolClient: NSObject, URLProtocolClient {
    var error: Error?
    var response: HTTPURLResponse?
    var data: Data?
    var isFinishLoading = false
    
    func urlProtocol(_ protocol: Foundation.URLProtocol, didFailWithError error: Error) {
        self.error = error
    }
    
    func urlProtocol(_ protocol: Foundation.URLProtocol, didReceive response: URLResponse, cacheStoragePolicy policy: URLCache.StoragePolicy) {
        self.response = response as? HTTPURLResponse
    }
    
    func urlProtocol(_ protocol: Foundation.URLProtocol, didLoad data: Data) {
        self.data = data
    }
    
    func urlProtocolDidFinishLoading(_ protocol: Foundation.URLProtocol) {
        isFinishLoading = true
    }
    
    func urlProtocol(_ protocol: Foundation.URLProtocol, wasRedirectedTo request: URLRequest, redirectResponse: URLResponse) {}
    func urlProtocol(_ protocol: Foundation.URLProtocol, cachedResponseIsValid cachedResponse: CachedURLResponse) {}
    func urlProtocol(_ protocol: Foundation.URLProtocol, didReceive challenge: URLAuthenticationChallenge) {}
    func urlProtocol(_ protocol: Foundation.URLProtocol, didCancel challenge: URLAuthenticationChallenge) {}
}
