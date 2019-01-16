//
//  StubberTests.swift
//  StubberTests
//
//  Created by Aleksey Zgurskiy on 08.06.2018.
//  Copyright © 2018 Graviti Mobail, TOV. All rights reserved.
//

import XCTest
@testable import Stubber

class StubberTests: XCTestCase {
  override func setUp() {
    super.setUp()
    
  }
  
  override func tearDown() {
    UTConfig.StubConfig.stubs = [UTConfig.StubConfig.Stub]()
    UTConfig.StubConfig.isTestEnvironment = false
    super.tearDown()
  }
  
  func testStubRequest() {
    let method = "TEST"
    let path = "/path"
    let host = "127.0.0.1"
    
    let stub = stubRequest(method, path: path, host: host, config: UTConfig.self)
    XCTAssertTrue(UTConfig.StubConfig.stubs.contains(stub))
    XCTAssertEqual(stub.request.method, method)
    XCTAssertEqual(stub.request.path, path)
    XCTAssertEqual(stub.request.host, host)
  }
  
  func testStubRequestContentsOfUrl() {
    let url = bundle.url(forResource: "Request", withExtension: nil)!
    let data = try! Data(contentsOf: url)
    let message = HTTPMessage(data: data, isRequest: true)
    
    let stub = try! stubRequest(contentsOf: url, config: UTConfig.self)
    XCTAssertTrue(UTConfig.StubConfig.stubs.contains(stub))
    XCTAssertEqual(stub.request.method, message.method)
    XCTAssertEqual(stub.request.path, message.path)
    XCTAssertEqual(stub.request.host, message.host)
    XCTAssertEqual(stub.request.headers, message.headers)
    XCTAssertEqual(stub.request.body, message.body)
  }
  
  func testRemoveStub() {
    let stub = UTConfig.StubConfig.Stub()
    UTConfig.StubConfig.stubs = [stub]
    removeStub(stub, config: UTConfig.self)
    XCTAssertFalse(UTConfig.StubConfig.stubs.contains(stub))
  }
  
  func testRemoveAllStubs() {
    let stub = UTConfig.StubConfig.Stub()
    UTConfig.StubConfig.stubs = [stub]
    removeAllStubs(config: UTConfig.self)
    XCTAssertEqual(UTConfig.StubConfig.stubs.count, 0)
  }
  
  func testSetTestEnvironment() {
    setTestEnvironment(config: UTConfig.self)
    XCTAssertTrue(UTConfig.StubConfig.isTestEnvironment)
  }
}
