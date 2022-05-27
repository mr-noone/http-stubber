import XCTest
@testable import HTTPStubber

class HTTPMessageTests: XCTestCase {
    // MARK: - Response tests
    
    func testResponseHTTPMessageStatusCode() {
        let message = HTTPMessage(string: "HTTP/1.1 204\n\n", isRequest: false)
        XCTAssertEqual(message?.statusCode, 204)
    }
    
    func testResponseHTTPMessageHost() {
        let message = HTTPMessage(string: "HTTP/1.1 200\n\n", isRequest: false)
        XCTAssertNil(message?.host)
    }
    
    func testResponseHTTPMessagePath() {
        let message = HTTPMessage(string: "HTTP/1.1 200\n\n", isRequest: false)
        XCTAssertNil(message?.path)
    }
    
    func testResponseHTTPMessageMethod() {
        let message = HTTPMessage(string: "HTTP/1.1 200\n\n", isRequest: false)
        XCTAssertNil(message?.method)
    }
    
    // MARK: - Request tests
    
    func testRequestHTTPMessageStatusCode() {
        let message = HTTPMessage(string: "POST / HTTP/1.1\n\n", isRequest: true)
        XCTAssertEqual(message?.statusCode, 0)
    }
    
    func testRequestHTTPMessageHost() {
        let message = HTTPMessage(string: "POST / HTTP/1.1\nHost: 127.0.0.1\n\n", isRequest: true)
        XCTAssertEqual(message?.host, "127.0.0.1")
    }
    
    func testRequestHTTPMessagePath() {
        let message = HTTPMessage(string: "POST /path/to HTTP/1.1\n\n", isRequest: true)
        XCTAssertEqual(message?.path, "/path/to")
    }
    
    func testRequestHTTPMessageMethod() {
        let message = HTTPMessage(string: "TEST / HTTP/1.1\n\n", isRequest: true)
        XCTAssertEqual(message?.method, "TEST")
    }
    
    func testRequestSerializedMessage() {
        var request = URLRequest(url: URL(string: "http://127.0.0.1/path?id=123&key=value")!)
        request.addValue("key1", forHTTPHeaderField: "value1")
        request.addValue("key2", forHTTPHeaderField: "value2")
        request.httpBody = "{\"key\":\"value\"}".data(using: .utf8)
        
        let message = HTTPMessage(request: request)
        let messageStr = """
        GET /path?id=123&key=value HTTP/1.1\r
        Host: 127.0.0.1\r
        value2: key2\r
        value1: key1\r
        \r
        {"key":"value"}
        """
        
        XCTAssertEqual(message?.serializedMessage, messageStr)
    }
    
    // MARK: - Common tests
    
    func testHTTPMessageHTTPVersion() {
        let message = HTTPMessage(string: "POST / HTTP/0.9\n\n", isRequest: true)
        XCTAssertEqual(message?.httpVersion, "HTTP/0.9")
    }
    
    func testHTTPMessageHTTPVersionEmpty() {
        let message = HTTPMessage(string: "POST /\n\n", isRequest: true)
        XCTAssertNil(message?.httpVersion)
    }
    
    func testHTTPMessageHeadersEmpty() {
        let message = HTTPMessage(string: "HTTP/1.1 200\n\n", isRequest: false)
        XCTAssertNil(message?.headers)
    }
    
    func testHTTPMessageHeadersNotEmpty() {
        let message = HTTPMessage(string: "HTTP/1.1 200\nKeep-Alive: 5\n\n", isRequest: false)
        XCTAssertEqual(message?.headers, ["Keep-Alive" : "5"])
    }
    
    func testHTTPMessageBodyEmpty() {
        let message = HTTPMessage(string: "HTTP/1.1 200\n\n", isRequest: false)
        XCTAssertNil(message?.body)
    }
    
    func testHTTPMessageBodyNotEmpty() {
        let message = HTTPMessage(string: "HTTP/1.1 200\n\nBody", isRequest: false)
        XCTAssertEqual(message?.body, "Body".data(using: .utf8))
    }
}
