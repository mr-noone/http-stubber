import Foundation

extension NSError {
    static func fileNotFound(name: String?, extension: String?, bundle: Bundle) -> NSError {
        let reason = "Could not find file."
        return NSError(domain: NSURLErrorDomain, code: -1, userInfo: [
            NSLocalizedDescriptionKey : reason,
            "File name" : name ?? "nil",
            "File extension" : `extension` ?? "nil",
            "Bundle" : bundle
        ])
    }
    
    static func unexpectedHTTP(request: URLRequest) -> NSError {
        let httpMessage = HTTPMessage(request: request)?.serializedMessage ?? ""
        let reason = "An unexpected HTTP request was fired:\n\n\(httpMessage)"
        return NSError(domain: NSURLErrorDomain, code: -1, userInfo: [
            NSLocalizedDescriptionKey : reason
        ])
    }
    
    static func requiredHTTP(headerMissing header: String, value: String) -> NSError {
        let reason = "Required http header missing."
        return NSError(domain: NSURLErrorDomain, code: -1, userInfo: [
            NSLocalizedDescriptionKey : reason,
            "Required header" : header,
            "Required value" : value
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
