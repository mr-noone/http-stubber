import Foundation
import CoreFoundation

struct HTTPMessage {
    // MARK: - Properties
    
    private let message: CFHTTPMessage
    
    var statusCode: Int {
        CFHTTPMessageIsRequest(message) ? 0 : CFHTTPMessageGetResponseStatusCode(message) as Int
    }
    
    var host: String? {
        let url = CFHTTPMessageCopyRequestURL(message)?.takeRetainedValue()
        return CFURLCopyHostName(url) as String?
    }
    
    var path: String? {
        let url = CFHTTPMessageCopyRequestURL(message)?.takeRetainedValue()
        return CFURLCopyPath(url) as String?
    }
    
    var method: String? {
        CFHTTPMessageCopyRequestMethod(message)?.takeRetainedValue() as String?
    }
    
    var httpVersion: String? {
        let version = CFHTTPMessageCopyVersion(message).takeRetainedValue() as String
        return version.isEmpty ? nil : version
    }
    
    var headers: [String : String]? {
        let headers = CFHTTPMessageCopyAllHeaderFields(message)?.takeRetainedValue() as? [String : String]
        return headers?.isEmpty ?? true ? nil : headers
    }
    
    var body: Data? {
        CFHTTPMessageCopyBody(message)?.takeRetainedValue() as Data?
    }
    
    var serializedMessage: String? {
        guard let data  = CFHTTPMessageCopySerializedMessage(message)?.takeRetainedValue() as Data? else { return nil }
        return String(data: data, encoding: .utf8)
    }
    
    // MARK: - Inits
    
    init(data: Data, isRequest: Bool) {
        message = CFHTTPMessageCreateEmpty(kCFAllocatorDefault, isRequest).takeRetainedValue()
        CFHTTPMessageAppendBytes(message, Array<UInt8>(data), data.count)
    }
    
    init?(string: String, isRequest: Bool) {
        guard let data = string.data(using: .utf8) else { return nil }
        self.init(data: data, isRequest: isRequest)
    }
    
    init?(request: URLRequest) {
        guard let method = request.httpMethod as CFString?,
              let url = request.url as CFURL?
        else { return nil }
        
        message = CFHTTPMessageCreateRequest(kCFAllocatorDefault, method, url, kCFHTTPVersion1_1).takeRetainedValue()
        
        if let body = request.httpBody as CFData? {
            CFHTTPMessageSetBody(message, body)
        }
        
        if let host = request.url?.host as CFString? {
            CFHTTPMessageSetHeaderFieldValue(message, "Host" as CFString, host)
        }
        
        request.allHTTPHeaderFields?.forEach {
            CFHTTPMessageSetHeaderFieldValue(message, $0.key as CFString, $0.value as CFString)
        }
    }
}

// MARK: - CoreFoundation

private func CFURLCopyHostName(_ anURL: CFURL?) -> CFString? {
    guard let anURL = anURL else { return nil }
    return CoreFoundation.CFURLCopyHostName(anURL)
}

private func CFURLCopyPath(_ anURL: CFURL?) -> CFString? {
    guard let anURL = anURL else { return nil }
    return CoreFoundation.CFURLCopyPath(anURL)
}
