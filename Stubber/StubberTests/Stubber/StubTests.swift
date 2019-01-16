//
//  StubTests.swift
//  StubberTests
//
//  Created by Aleksey Zgurskiy on 07.06.2018.
//  Copyright © 2018 Graviti Mobail, TOV. All rights reserved.
//

import XCTest
@testable import Stubber

class StubTests: XCTestCase {
  func testStubIsEqual() {
    let stub1 = Stub<UTRequest, UTResponse>()
    stub1.request.setMethod("POST", path: "/path/to", host: "127.0.0.1")
    stub1.request.setHeaders(["header1" : "value1", "header2" : "value2"])
    stub1.request.setBody("body".data(using: .utf8)!)
    
    stub1.response.setStatusCode(204)
    stub1.response.setHeaders(["header1" : "value1", "header2" : "value2"])
    stub1.response.setBody("body".data(using: .utf8)!)
    
    let stub2 = Stub<UTRequest, UTResponse>()
    stub2.request.setMethod("POST", path: "/path/to", host: "127.0.0.1")
    stub2.request.setHeaders(["header1" : "value1", "header2" : "value2"])
    stub2.request.setBody("body".data(using: .utf8)!)
    
    stub2.response.setStatusCode(204)
    stub2.response.setHeaders(["header1" : "value1", "header2" : "value2"])
    stub2.response.setBody("body".data(using: .utf8)!)
    
    XCTAssertEqual(stub1, stub2)
  }
  
  func testStubNotEqual() {
    let stub = Stub<UTRequest, UTResponse>()
    stub.request.setMethod("POST", path: "/path/to", host: "127.0.0.1")
    stub.request.setHeaders(["header1" : "value1", "header2" : "value2"])
    stub.request.setBody("body".data(using: .utf8)!)
    
    stub.response.setStatusCode(204)
    stub.response.setHeaders(["header1" : "value1", "header2" : "value2"])
    stub.response.setBody("body".data(using: .utf8)!)
    
    XCTAssertNotEqual(stub, Stub<UTRequest, UTResponse>())
  }
}
