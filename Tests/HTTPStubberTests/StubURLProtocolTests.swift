import XCTest
@testable import HTTPStubber

class StubURLProtocolTests: XCTestCase {
    override func tearDown() {
        StubURLProtocol.stubs = []
        StubURLProtocol.isTestEnvironment = false
        super.tearDown()
    }
    
    func testAddStub() {
        let stub = Stub()
        StubURLProtocol.addStub(stub)
        XCTAssertTrue(StubURLProtocol.stubs.contains(stub))
    }
    
    func testRemoveStub() {
        let stub = Stub()
        StubURLProtocol.stubs = [stub]
        StubURLProtocol.removeStub(stub)
        XCTAssertFalse(StubURLProtocol.stubs.contains(stub))
    }
    
    func testRemoveAllStubs() {
        StubURLProtocol.stubs = [Stub(), Stub(), Stub()]
        StubURLProtocol.removeAllStubs()
        XCTAssertTrue(StubURLProtocol.stubs.isEmpty)
    }
    
    func testSetTestEnvironment() {
        StubURLProtocol.setTestEnvironment()
        XCTAssertTrue(StubURLProtocol.isTestEnvironment)
    }
    
    func testSetTestEnvironmentFalse() {
        StubURLProtocol.setTestEnvironment(false)
        XCTAssertFalse(StubURLProtocol.isTestEnvironment)
    }
    
    func testHTTPBody() {
        let data = "Test string".data(using: .utf8)!
        var request = URLRequest(url: URL(string: "http://127.0.0.1")!)
        request.httpBodyStream = InputStream(data: data)
        
        StubURLProtocol.setTestEnvironment()
        let urlProtocol = StubURLProtocol(request: request, cachedResponse: nil, client: nil)
        
        XCTAssertEqual(urlProtocol.httpBody, data)
    }
    
    func testCanInitWithTestEnvironment() {
        let request = URLRequest(url: URL(string: "http://127.0.0.1")!)
        StubURLProtocol.setTestEnvironment()
        XCTAssertTrue(StubURLProtocol.canInit(with: request), "Always true if test environment")
    }
    
    func testCanInitWithContainsStubWithQuery() {
        let url = URL(string: "http://127.0.0.1/path?key=[value]")!
        let queryItems = [URLQueryItem(name: "key", value: "[value]")]
        var request = URLRequest(url: url)
        request.httpMethod = "TEST"
        
        StubURLProtocol.stubs = [Stub(method: "TEST", path: "/path").setRequest(queryItems: queryItems)]
        XCTAssertTrue(StubURLProtocol.canInit(with: request))
    }
    
    func testCanInitWithContainsStubWithoutQuery() {
        let url = URL(string: "http://127.0.0.1/path?key=[value]")!
        var request = URLRequest(url: url)
        request.httpMethod = "TEST"
        
        StubURLProtocol.stubs = [Stub(method: "TEST", path: "/path")]
        XCTAssertTrue(StubURLProtocol.canInit(with: request))
    }
    
    func testCanInitWithContainsStubWithHost() {
        let url = URL(string: "http://127.0.0.1/path")!
        var request = URLRequest(url: url)
        request.httpMethod = "TEST"
        
        StubURLProtocol.stubs = [Stub(method: "TEST", path: "/path", host: "127.0.0.1")]
        XCTAssertTrue(StubURLProtocol.canInit(with: request))
    }
    
    func testCanInitWithContainsStubWithoutHost() {
        let url = URL(string: "http://127.0.0.1/path")!
        var request = URLRequest(url: url)
        request.httpMethod = "TEST"
        
        StubURLProtocol.stubs = [Stub(method: "TEST", path: "/path", host: nil)]
        XCTAssertTrue(StubURLProtocol.canInit(with: request), "true if the host for the stub is not specified")
    }
    
    func testCanInitWithoutContainsStub() {
        let url = URL(string: "http://127.0.0.1/path")!
        let request = URLRequest(url: url)
        XCTAssertFalse(StubURLProtocol.canInit(with: request))
    }
    
    func testCanonicalRequest() {
        let request = URLRequest(url: URL(string: "http://127.0.0.1")!)
        XCTAssertEqual(StubURLProtocol.canonicalRequest(for: request), request, "Must be equal")
    }
    
    func testStartLoadingWithoutStub() {
        let urlClient = UTURLProtocolClient()
        let request = URLRequest(url: URL(string: "127.0.0.1")!)
        StubURLProtocol(request: request, cachedResponse: nil, client: urlClient).startLoading()
        XCTAssertEqual(urlClient.error as NSError?, NSError.unexpectedHTTP(request: request))
    }
    
    func testStartLoadingWithErrorResponse() {
        let error = NSError(domain: "", code: 0, userInfo: nil)
        let urlClient = UTURLProtocolClient()
        let request = URLRequest(url: URL(string: "http://127.0.0.1")!)
        
        StubURLProtocol.stubs = [Stub().setResponse(failWith: error)]
        StubURLProtocol(request: request, cachedResponse: nil, client: urlClient).startLoading()
        
        XCTAssertEqual(urlClient.error as NSError?, error)
    }
    
    func testStartLoadingWithSuccessResponse() {
        let statusCode = 201
        let headers = ["key" : "value"]
        let body = "body".data(using: .utf8)!
        
        let urlClient = UTURLProtocolClient()
        let request = URLRequest(url: URL(string: "http://127.0.0.1")!)
        
        StubURLProtocol.stubs = [
            Stub().setResponse(statusCode: statusCode)
                .setResponse(headers: headers)
                .setResponse(body: body)
        ]
        StubURLProtocol(request: request, cachedResponse: nil, client: urlClient).startLoading()
        
        XCTAssertEqual(urlClient.response?.statusCode, statusCode)
        XCTAssertEqual(urlClient.response?.allHeaderFields as! [String : String], headers)
        XCTAssertEqual(urlClient.data, body)
        XCTAssertTrue(urlClient.isFinishLoading)
    }
    
    func testStartLoadingWithoutResponse() {
        let urlClient = UTURLProtocolClient()
        let request = URLRequest(url: URL(string: "http://127.0.0.1")!)
        
        StubURLProtocol.stubs = [Stub()]
        StubURLProtocol(request: request, cachedResponse: nil, client: urlClient).startLoading()
        
        XCTAssertEqual(urlClient.response?.statusCode, 201)
        XCTAssertEqual(urlClient.response?.allHeaderFields as? [String : String], [:])
        XCTAssertEqual(urlClient.data, Data())
        XCTAssertTrue(urlClient.isFinishLoading)
    }
    
    func testStartLoadingRequiredHeaderMissing() {
        let urlClient = UTURLProtocolClient()
        let headers = ["Header" : "Value"]
        var request = URLRequest(url: URL(string: "http://127.0.0.1")!)
        request.addValue("Test", forHTTPHeaderField: "Test")
        
        
        StubURLProtocol.isTestEnvironment = true
        StubURLProtocol.stubs = [Stub().setRequest(headers: headers)]
        StubURLProtocol(request: request, cachedResponse: nil, client: urlClient).startLoading()
        
        XCTAssertEqual(urlClient.error as NSError?, NSError.requiredHTTP(headerMissing: "Header", value: "Value"))
    }
    
    func testStartLoadingEmptyHeaders() {
        let urlClient = UTURLProtocolClient()
        let request = URLRequest(url: URL(string: "http://127.0.0.1")!)
        
        StubURLProtocol.isTestEnvironment = true
        StubURLProtocol.stubs = [Stub().setRequest(headers: [:])]
        StubURLProtocol(request: request, cachedResponse: nil, client: urlClient).startLoading()
        
        XCTAssertTrue(urlClient.error == nil)
    }
    
    func testStartLoadingUnexpectedBody() {
        let urlClient = UTURLProtocolClient()
        let request = URLRequest(url: URL(string: "http://127.0.0.1")!)
        let body = "body".data(using: .utf8)!
        
        StubURLProtocol.isTestEnvironment = true
        StubURLProtocol.stubs = [Stub().setRequest(body: body)]
        StubURLProtocol(request: request, cachedResponse: nil, client: urlClient).startLoading()
        
        XCTAssertEqual(urlClient.error as NSError?, NSError.unexpectedHTTP(requestBody: nil, stubBody: body))
    }
    
    func testStartLoadingEmptyBody() {
        let urlClient = UTURLProtocolClient()
        let request = URLRequest(url: URL(string: "http://127.0.0.1")!)
        
        StubURLProtocol.isTestEnvironment = true
        StubURLProtocol.stubs = [Stub().setRequest(body: Data())]
        StubURLProtocol(request: request, cachedResponse: nil, client: urlClient).startLoading()
        
        XCTAssertTrue(urlClient.error == nil)
    }
}
