//
//  StubURLProtocolTests.swift
//  StubberTests
//
//  Created by Aleksey Zgurskiy on 09.07.2018.
//  Copyright © 2018 Graviti Mobail, TOV. All rights reserved.
//

import XCTest
@testable import HTTPStubber

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

class StubURLProtocolTests: XCTestCase {
  private typealias Stub = UTStubConfig.Stub
  private typealias URLProtocol = StubURLProtocol<UTStubConfig>
  
  override func tearDown() {
    UTStubConfig.stubs = [UTStubConfig.Stub]()
    UTStubConfig.isTestEnvironment = false
    super.tearDown()
  }
  
  func testAddStub() {
    let stub = Stub()
    URLProtocol.addStub(stub)
    XCTAssertTrue(UTStubConfig.stubs.contains(stub))
  }
  
  func testRemoveStub() {
    let stub = Stub()
    UTStubConfig.stubs = [stub]
    URLProtocol.removeStub(stub)
    XCTAssertFalse(UTStubConfig.stubs.contains(stub))
  }
  
  func testRemoveAllStubs() {
    UTStubConfig.stubs = [Stub(), Stub(), Stub()]
    URLProtocol.removeAllStubs()
    XCTAssertEqual(UTStubConfig.stubs.count, 0)
  }
  
  func testSetTestEnvironment() {
    URLProtocol.setTestEnvironment()
    XCTAssertTrue(UTStubConfig.isTestEnvironment)
  }
  
  func testCanInitWithTestEnvironment() {
    let request = URLRequest(url: URL(string: "http://127.0.0.1")!)
    URLProtocol.setTestEnvironment()
    XCTAssertTrue(URLProtocol.canInit(with: request), "Always true if test environment")
  }
  
  func testCanInitWithContainsStubWithHost() {
    let stub = Stub()
    stub.request.setMethod("TEST", path: "/path", host: "127.0.0.1")
    UTStubConfig.stubs = [stub]
    
    let url = URL(string: "http://127.0.0.1/path")!
    var request = URLRequest(url: url)
    request.httpMethod = "TEST"
    
    XCTAssertTrue(URLProtocol.canInit(with: request))
  }
  
  func testCanInitWithContainsStubWithoutHost() {
    let stub = Stub()
    stub.request.setMethod("TEST", path: "/path", host: nil)
    UTStubConfig.stubs = [stub]
    
    let url = URL(string: "http://127.0.0.1/path")!
    var request = URLRequest(url: url)
    request.httpMethod = "TEST"
    
    XCTAssertTrue(URLProtocol.canInit(with: request), "true if the host for the stub is not specified")
  }
  
  func testCanInitWithoutContainsStub() {
    let url = URL(string: "http://127.0.0.1/path")!
    let request = URLRequest(url: url)
    XCTAssertFalse(URLProtocol.canInit(with: request))
  }
  
  func testCanonicalRequest() {
    let request = URLRequest(url: URL(string: "http://127.0.0.1")!)
    XCTAssertEqual(URLProtocol.canonicalRequest(for: request), request, "Must be equal")
  }
  
  func testStartLoadingWithoutStub() {
    let request = URLRequest(url: URL(string: "http://127.0.0.1")!)
    let urlProtocol = URLProtocol(request: request, cachedResponse: nil, client: nil)
    XCTAssertThrowsError(try ObjC.catchException { urlProtocol.startLoading() })
  }
  
  func testStartLoadingWithErrorResponse() {
    let error = NSError(domain: "", code: 0, userInfo: nil)
    
    UTStubConfig.stubs = {
      let stub = Stub()
      stub.request.setMethod("GET", path: "", host: nil)
      stub.response.setError(error)
      return [stub]
    }()
    
    let urlClient = UTURLProtocolClient()
    let request = URLRequest(url: URL(string: "http://127.0.0.1")!)
    URLProtocol(request: request, cachedResponse: nil, client: urlClient).startLoading()
    
    XCTAssertEqual(urlClient.error! as NSError, error as NSError)
  }
  
  func testStartLoadingWithSuccessResponse() {
    let statusCode = 201
    let headers = ["key" : "value"]
    let body = "body".data(using: .utf8)!
    
    UTStubConfig.stubs = {
      let stub = Stub()
      stub.request.setMethod("GET", path: "", host: nil)
      stub.response.setStatusCode(statusCode)
      stub.response.setHeaders(headers)
      stub.response.setBody(body)
      return [stub]
    }()
    
    let urlClient = UTURLProtocolClient()
    let request = URLRequest(url: URL(string: "http://127.0.0.1")!)
    URLProtocol(request: request, cachedResponse: nil, client: urlClient).startLoading()
    
    XCTAssertEqual(urlClient.response?.statusCode, statusCode)
    XCTAssertEqual(urlClient.response?.allHeaderFields as! [String : String], headers)
    XCTAssertEqual(urlClient.data, body)
    XCTAssertTrue(urlClient.isFinishLoading)
  }
  
  func testStartLoadingWithoutResponse() {
    UTStubConfig.stubs = {
      let stub = Stub()
      stub.request.setMethod("GET", path: "", host: nil)
      return [stub]
    }()
    
    let urlClient = UTURLProtocolClient()
    let request = URLRequest(url: URL(string: "http://127.0.0.1")!)
    URLProtocol(request: request, cachedResponse: nil, client: urlClient).startLoading()
    
    XCTAssertEqual(urlClient.response?.statusCode, 200)
    XCTAssertEqual(urlClient.response?.allHeaderFields as! [String : String], [String : String]())
    XCTAssertEqual(urlClient.data, Data())
    XCTAssertTrue(urlClient.isFinishLoading)
  }
}
