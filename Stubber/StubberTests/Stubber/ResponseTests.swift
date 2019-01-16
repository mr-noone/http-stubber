//
//  ResponseTests.swift
//  StubberTests
//
//  Created by Aleksey Zgurskiy on 06.06.2018.
//  Copyright © 2018 Graviti Mobail, TOV. All rights reserved.
//

import XCTest
@testable import Stubber

class ResponseTests: XCTestCase {
  func testResponseInit() {
    let response = Response()
    response.setStatusCode(204)
    XCTAssertEqual(response.statusCode, 204)
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
}
