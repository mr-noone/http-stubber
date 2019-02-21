//
//  StubResponseTests.swift
//  StubberTests
//
//  Created by Aleksey Zgurskiy on 06.06.2018.
//  Copyright © 2018 Graviti Mobail, TOV. All rights reserved.
//

import XCTest
@testable import Stubber

class StubResponseTests: XCTestCase {
  private typealias Stub = UTStub<UTRequest, UTResponse>
  private var stub: StubResponse!
  
  override func setUp() {
    super.setUp()
    stub = Stub()
  }
  
  override func tearDown() {
    stub = nil
    super.tearDown()
  }
  
  func testStubResponseWithHeaders() {
    let headers = ["key1" : "value1", "key2" : "value2"]
    stub.withHeaders(headers)
    XCTAssertEqual((stub as! Stub).response.headers, headers)
  }
  
  func testStubResponseWithBody() {
    let body = "Body".data(using: .utf8)!
    stub.withBody(body)
    XCTAssertEqual((stub as! Stub).response.body, body)
  }
  
  func testStubResponseWithBodyContentsOf() {
    let url = bundle.url(forResource: "Body", withExtension: "json")!
    let body = try! Data(contentsOf: url)
    try! stub.withBody(contentsOf: url)
    XCTAssertEqual((stub as! Stub).response.body, body)
  }
}
