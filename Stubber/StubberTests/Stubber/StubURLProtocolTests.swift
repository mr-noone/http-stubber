//
//  StubURLProtocolTests.swift
//  StubberTests
//
//  Created by Aleksey Zgurskiy on 06.06.2018.
//  Copyright © 2018 Graviti Mobail, TOV. All rights reserved.
//

import XCTest
@testable import Stubber

class StubURLProtocolTests: XCTestCase {
  func testCanInitWithRequest() {
    let request = URLRequest(url: URL(string: "http://127.0.0.1")!)
    XCTAssertFalse(StubURLProtocol.canInit(with: request))
  }
  
  func testCanonicalRequestForRequest() {
    let request = URLRequest(url: URL(string: "http://127.0.0.1")!)
    XCTAssertEqual(StubURLProtocol.canonicalRequest(for: request), request)
  }
  
  func testRequestIsCacheEquivalent() {
    let request = URLRequest(url: URL(string: "http://127.0.0.1")!)
    XCTAssertFalse(StubURLProtocol.requestIsCacheEquivalent(request, to: request))
  }
}
