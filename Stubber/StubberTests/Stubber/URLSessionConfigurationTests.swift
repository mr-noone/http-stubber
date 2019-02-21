//
//  URLSessionConfigurationTests.swift
//  StubberTests
//
//  Created by Aleksey Zgurskiy on 07.06.2018.
//  Copyright © 2018 Graviti Mobail, TOV. All rights reserved.
//

import XCTest
@testable import Stubber

private class UTURLProtocol: URLProtocol {
  override class func canInit(with request: URLRequest) -> Bool {
    return false
  }
}

class URLSessionConfigurationTests: XCTestCase {
  override func setUp() {
    super.setUp()
    URLSessionConfiguration.registerURLProtocol(UTURLProtocol.self)
  }
  
  override func tearDown() {
    URLSessionConfiguration.unregisterURLProtocol(UTURLProtocol.self)
  }
  
  func testContainsURLProtocol() {
    XCTAssertTrue(URLSessionConfiguration.containsURLProtocol(UTURLProtocol.self))
  }
  
  func testNotContainsURLProtocol() {
    XCTAssertFalse(URLSessionConfiguration.containsURLProtocol(URLProtocol.self))
  }
  
  func testRegisterURLProtocol() {
    XCTAssertTrue(URLSessionConfiguration.default.protocolClasses!.contains() { $0 == UTURLProtocol.self })
    XCTAssertTrue(URLSessionConfiguration.ephemeral.protocolClasses!.contains() { $0 == UTURLProtocol.self })
  }
}
