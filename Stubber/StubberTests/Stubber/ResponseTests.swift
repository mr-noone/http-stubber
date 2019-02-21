//
//  ResponseTests.swift
//  StubberTests
//
//  Created by Aleksey Zgurskiy on 06.06.2018.
//  Copyright © 2018 Graviti Mobail, TOV. All rights reserved.
//

import XCTest
@testable import HTTPStubber

class ResponseTests: XCTestCase {
  func testResponseSetStatusCode() {
    let response = Response()
    response.setStatusCode(204)
    XCTAssertEqual(response.statusCode, 204)
  }
  
  func testResponseSetError() {
    let error = NSError(domain: "domain", code: 101, userInfo: nil)
    let response = Response()
    response.setError(error)
    XCTAssertEqual(response.error! as NSError, error)
  }
  
  func testResponseSetHeaders() {
    let headers = ["header1" : "value1", "header2" : "value2"]
    let response = Response()
    response.setHeaders(headers)
    XCTAssertEqual(response.headers, headers)
  }
  
  func testResponseSetBody() {
    let body = "test body".data(using: .utf8)!
    let response = Response()
    response.setBody(body)
    XCTAssertEqual(response.body, body)
  }
  
  func tetResponseIsEqual() {
    let response1 = Response()
    response1.setStatusCode(204)
    response1.setHeaders(["header1" : "value1", "header2" : "value2"])
    response1.setBody("body".data(using: .utf8)!)
    
    let response2 = Response()
    response2.setStatusCode(204)
    response2.setHeaders(["header1" : "value1", "header2" : "value2"])
    response2.setBody("body".data(using: .utf8)!)
    
    XCTAssertEqual(response1, response2)
  }
  
  func testResponseNotEqual() {
    let response = Response()
    response.setStatusCode(204)
    response.setHeaders(["header1" : "value1", "header2" : "value2"])
    response.setBody("body".data(using: .utf8)!)
    
    XCTAssertNotEqual(response, Response())
  }
}
