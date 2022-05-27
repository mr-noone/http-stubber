import Foundation

extension NSError {
    static func unexpectedHTTP(request: URLRequest) -> NSError {
        let httpMessage = HTTPMessage(request: request)?.serializedMessage ?? ""
        let reason = "An unexpected HTTP request was fired:\n\n\(httpMessage)"
        return NSError(domain: NSURLErrorDomain, code: -1, userInfo: [
            NSLocalizedDescriptionKey : reason
        ])
    }
    
    static func unexpectedHTTP(requestHeaders: [String : String]?, stubHeaders: [String : String]?) -> NSError {
        let reason = "An unexpected HTTP request headers."
        return NSError(domain: NSURLErrorDomain, code: -1, userInfo: [
            NSLocalizedDescriptionKey : reason,
            "HeadersInRequest" : requestHeaders ?? [:],
            "HeadersInStub" : stubHeaders ?? [:]
        ])
    }
    
    static func unexpectedHTTP(requestBody: Data?, stubBody: Data?) -> NSError {
        let reason = "An unexpected HTTP request body."
        return NSError(domain: NSURLErrorDomain, code: -1, userInfo: [
            NSLocalizedDescriptionKey : reason,
            "HTTPBodyInRequest" : requestBody ?? Data(),
            "HTTPBodyInStub" : stubBody ?? Data()
        ])
    }
}
