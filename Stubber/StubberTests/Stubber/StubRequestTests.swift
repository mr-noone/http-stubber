//
//  StubRequestTests.swift
//  StubberTests
//
//  Created by Aleksey Zgurskiy on 06.06.2018.
//  Copyright © 2018 Graviti Mobail, TOV. All rights reserved.
//

import XCTest
import HTTPMessage
@testable import Stubber

class StubRequestTests: XCTestCase {
  private typealias Stub = UTStub<UTRequest, UTResponse>
  private var stub: StubRequest!
  
  override func setUp() {
    super.setUp()
    stub = Stub()
  }
  
  override func tearDown() {
    stub = nil
    super.tearDown()
  }
  
  func testStubRequestWithHeaders() {
    let headers = ["key1" : "value1", "key2" : "value2"]
    stub.withHeaders(headers)
    XCTAssertEqual((stub as! Stub).request.headers, headers)
  }
  
  func testStubRequestWithBody() {
    let body = "Body".data(using: .utf8)!
    stub.withBody(body)
    XCTAssertEqual((stub as! Stub).request.body, body)
  }
  
  func testStubRequestWithBodyContentsOf() {
    let url = bundle.url(forResource: "Body", withExtension: "json")!
    let body = try! Data(contentsOf: url)
    try! stub.withBody(contentsOf: url)
    XCTAssertEqual((stub as! Stub).request.body, body)
  }
  
  func testStubRequestAndResponse() {
    stub.andResponse(204)
    XCTAssertEqual((stub as! Stub).response.statusCode, 204)
  }
  
  func testStubRequestAndResponseContentsOf() {
    let url = bundle.url(forResource: "Response", withExtension: nil)!
    let data = try! Data(contentsOf: url)
    let message = HTTPMessage(data: data, isRequest: false)
    try! self.stub.andResponse(contentsOf: url)
    let stub = self.stub as! Stub
    
    XCTAssertEqual(stub.response.statusCode, message.statusCode)
    XCTAssertEqual(stub.response.headers, message.headers)
    XCTAssertEqual(stub.response.body, message.body)
  }
  
  func testStubRequestAndResponseWithError() {
    let error = NSError(domain: "domain", code: 101, userInfo: nil)
    self.stub.andFailWithError(error)
    let stub = self.stub as! Stub
    XCTAssertEqual(stub.response.error! as NSError, error)
  }
}
