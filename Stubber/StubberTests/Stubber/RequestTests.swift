//
//  StubRequestTests.swift
//  StubberTests
//
//  Created by Aleksey Zgurskiy on 05.06.2018.
//  Copyright © 2018 Graviti Mobail, TOV. All rights reserved.
//

import XCTest
@testable import Stubber

class RequestTests: XCTestCase {
  func testRequestInit() {
    let request = Request()
    request.setMethod("POST", path: "/path", host: "127.0.0.1")
    XCTAssertNotNil(request)
    XCTAssertEqual(request.host, "127.0.0.1")
    XCTAssertEqual(request.path, "/path")
    XCTAssertEqual(request.method, "POST")
  }
  
  func testRequestSetHeaders() {
    let headers = ["header1" : "value1", "header2" : "value2"]
    let request = Request()
    request.setHeaders(headers)
    XCTAssertEqual(request.headers, headers)
  }
  
  func testRequestSetBody() {
    let body = "test body".data(using: .utf8)!
    let request = Request()
    request.setBody(body)
    XCTAssertEqual(request.body, body)
  }
  
  func testRequestIsEqual() {
    let request1 = Request()
    request1.setMethod("POST", path: "/path/to", host: "127.0.0.1")
    request1.setHeaders(["header1" : "value1", "header2" : "value2"])
    request1.setBody("body".data(using: .utf8)!)
    
    let request2 = Request()
    request2.setMethod("POST", path: "/path/to", host: "127.0.0.1")
    request2.setHeaders(["header1" : "value1", "header2" : "value2"])
    request2.setBody("body".data(using: .utf8)!)
    
    XCTAssertEqual(request1, request2)
  }
  
  func testRequestNotEqual() {
    let request = Request()
    request.setMethod("POST", path: "/path/to", host: "127.0.0.1")
    request.setHeaders(["header1" : "value1", "header2" : "value2"])
    request.setBody("body".data(using: .utf8)!)
    XCTAssertNotEqual(request, Request())
  }
}
