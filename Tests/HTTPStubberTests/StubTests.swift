import XCTest
@testable import HTTPStubber

class StubTests: XCTestCase {
    func testInitStubStartWithSlashPathWithSchema() {
        let stub = Stub(method: "TEST", path: "/path", host: "https://127.0.0.1")
        XCTAssertEqual(stub.request.method, "TEST")
        XCTAssertEqual(stub.request.path, "/path")
        XCTAssertEqual(stub.request.host, "127.0.0.1")
    }
    
    func testInitStubStartWithoutSlashPathWithoutSchema() {
        let stub = Stub(method: "TEST", path: "path", host: "127.0.0.1")
        XCTAssertEqual(stub.request.method, "TEST")
        XCTAssertEqual(stub.request.path, "/path")
        XCTAssertEqual(stub.request.host, "127.0.0.1")
    }
    
    func testInitStubWithEmptyPathWithEmptyHost() {
        let stub = Stub(method: "TEST", path: "", host: "")
        XCTAssertEqual(stub.request.method, "TEST")
        XCTAssertEqual(stub.request.path, "")
        XCTAssertEqual(stub.request.host, nil)
    }
    
    func testInitStubWithEmptyPathWithOnlySchemaHost() {
        let stub = Stub(method: "TEST", path: "", host: "https://")
        XCTAssertEqual(stub.request.method, "TEST")
        XCTAssertEqual(stub.request.path, "")
        XCTAssertEqual(stub.request.host, nil)
    }
    
    func testInitStub() {
        let method = "TEST"
        let path = "/path"
        let host = "127.0.0.1"
        let stub = Stub(method: method, path: path, host: host)
        
        XCTAssertEqual(stub.request.method, method)
        XCTAssertEqual(stub.request.path, path)
        XCTAssertEqual(stub.request.host, host)
        XCTAssertNil(stub.request.headers)
        XCTAssertNil(stub.request.body)
        
        XCTAssertEqual(stub.response.statusCode, 201)
        XCTAssertNil(stub.response.error)
        XCTAssertNil(stub.response.headers)
        XCTAssertNil(stub.response.body)
    }
    
    func testInitStubContentsOfURL() {
        let url = bundle.url(forResource: "Request", withExtension: nil)!
        let stub = try! Stub(contentsOf: url)
        
        XCTAssertEqual(stub?.request.method, "POST")
        XCTAssertEqual(stub?.request.path, "/path/to")
        XCTAssertEqual(stub?.request.host, "127.0.0.1")
        XCTAssertEqual(stub?.request.headers, [
            "Host" : "127.0.0.1",
            "Content-Type" : "application/json"
        ])
        XCTAssertEqual(stub?.request.body, "{\"key\":\"value\"}\n".data(using: .utf8))
        
        XCTAssertEqual(stub?.response.statusCode, 201)
        XCTAssertNil(stub?.response.error)
        XCTAssertNil(stub?.response.headers)
        XCTAssertNil(stub?.response.body)
    }
    
    func testSetRequestQueryItems() {
        let queryItems = [URLQueryItem(name: "key", value: "[value]")]
        let stub = Stub(method: "GET", path: "/путь").setRequest(queryItems: queryItems)
        XCTAssertEqual(stub.request.query, queryItems)
    }
    
    func testSetRequestHeaders() {
        let headers = ["Header 1" : "Value 1", "Header 2" : "Value 2"]
        let stub = Stub(method: "GET", path: "/path").setRequest(headers: headers)
        XCTAssertEqual(stub.request.headers, headers)
    }
    
    func testSetRequestHeader() {
        let stub = Stub(method: "GET", path: "/path")
            .setRequest(header: "Key 1", value: "Value 1")
            .setRequest(header: "Key 2", value: "Value 2")
        XCTAssertEqual(stub.request.headers, [
            "Key 1" : "Value 1",
            "Key 2" : "Value 2"
        ])
    }
    
    func testSetRequestBody() {
        let url = bundle.url(forResource: "Body", withExtension: "json")!
        let data = try! Data(contentsOf: url)
        let stub = Stub(method: "GET", path: "/path").setRequest(body: data)
        XCTAssertEqual(stub.request.body, data)
    }
    
    func testSetRequestBodyFromString() {
        let string = "Test string"
        let stub = Stub(method: "GET", path: "/path").setRequest(body: string, using: .utf8)
        XCTAssertEqual(stub.request.body, string.data(using: .utf8))
    }
    
    func testSetRequestBodyFromEncodable() throws {
        let body = ["key" : "value"]
        let stub = try Stub(method: "GET", path: "/path").setRequest(body: body, encoder: JSONEncoder())
        XCTAssertEqual(stub.request.body, try JSONEncoder().encode(body))
    }
    
    func testSetRequestBodyContentsOfURL() {
        let url = bundle.url(forResource: "Body", withExtension: "json")!
        let data = try! Data(contentsOf: url)
        let stub = try! Stub(method: "GET", path: "/path").setRequest(bodyContentsOf: url)
        XCTAssertEqual(stub.request.body, data)
    }
    
    func testSetResponseContentsOfURL() {
        let url = bundle.url(forResource: "Response", withExtension: nil)!
        let stub = try! Stub(method: "GET", path: "/path").setResponse(contentsOf: url)
        
        XCTAssertEqual(stub.response.statusCode, 200)
        XCTAssertNil(stub.response.error)
        XCTAssertEqual(stub.response.headers, [
            "Keep-Alive" : "5",
            "Content-Length" : "40",
            "Content-Type" : "application/json",
            "Proxy-Connection" : "Keep-alive"
        ])
        XCTAssertEqual(stub.response.body, "{\"message\":\"ok\",\"order_id\":\"D74876021\"}\n".data(using: .utf8))
    }
    
    func testSetResponseFailWithError() {
        let error = NSError(domain: "Test", code: -1)
        let stub = Stub(method: "GET", path: "/path").setResponse(failWith: error)
        XCTAssertEqual(stub.response.error?.localizedDescription, error.localizedDescription)
        XCTAssertNil(stub.response.statusCode)
        XCTAssertNil(stub.response.headers)
        XCTAssertNil(stub.response.body)
    }
    
    func testSetResponseStatusCode() {
        let stub = Stub(method: "GET", path: "/path").setResponse(statusCode: 100)
        XCTAssertEqual(stub.response.statusCode, 100)
    }
    
    func testSetResponseHeaders() {
        let headers = ["Header 1" : "Value 1", "Header 2" : "Value 2"]
        let stub = Stub(method: "GET", path: "/path").setResponse(headers: headers)
        XCTAssertEqual(stub.response.headers, headers)
    }
    
    func testSetResponseHeader() {
        let stub = Stub(method: "GET", path: "/path")
            .setResponse(header: "Key 1", value: "Value 1")
            .setResponse(header: "Key 2", value: "Value 2")
        XCTAssertEqual(stub.response.headers, [
            "Key 1" : "Value 1",
            "Key 2" : "Value 2"
        ])
    }
    
    func testSetResponseBody() {
        let url = bundle.url(forResource: "Body", withExtension: "json")!
        let data = try! Data(contentsOf: url)
        let stub = Stub(method: "GET", path: "/path").setResponse(body: data)
        XCTAssertEqual(stub.response.body, data)
    }
    
    func testSetResponseBodyFromString() {
        let string = "Test string"
        let stub = Stub(method: "GET", path: "/path").setResponse(body: string, using: .utf8)
        XCTAssertEqual(stub.response.body, string.data(using: .utf8))
    }
    
    func testSetResponseBodyFromEncodable() throws {
        let body = ["key" : "value"]
        let stub = try Stub(method: "GET", path: "/path").setResponse(body: body, encoder: JSONEncoder())
        XCTAssertEqual(stub.response.body, try JSONEncoder().encode(body))
    }
    
    func testSetResponseBodyContentsInBundle() throws {
        let url = bundle.url(forResource: "Body", withExtension: "json")!
        let data = try Data(contentsOf: url)
        let stub = try Stub(method: "GET", path: "/path").setResponse(bodyContentsIn: bundle, name: "Body", extension: "json")
        XCTAssertEqual(stub.response.body, data)
    }
    
    func testSetResponseBodyContentsOfURL() throws {
        let url = bundle.url(forResource: "Body", withExtension: "json")!
        let data = try Data(contentsOf: url)
        let stub = try Stub(method: "GET", path: "/path").setResponse(bodyContentsOf: url)
        XCTAssertEqual(stub.response.body, data)
    }
    
    func test() {
        let stub = Stub(method: "GET", path: "/path").inject(into: UTURLProtocol.self)
        XCTAssertTrue(UTURLProtocol.stubs.contains(stub))
    }
}
