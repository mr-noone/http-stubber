//
//  URLSessionConfiguration+StubberTests.swift
//  StubberTests
//
//  Created by Aleksey Zgurskiy on 12/27/18.
//  Copyright © 2018 Graviti Mobail, TOV. All rights reserved.
//

import XCTest
@testable import Stubber

class URLSessionConfiguration_StubberTests: XCTestCase {
  func testDefaultSessionConfiguration() {
    let config = URLSessionConfiguration.default
    
    URLSessionConfiguration.registerClass(UTURLProtocol<UTStubConfig>.self)
    XCTAssertTrue(config.protocolClasses!.contains(where: { $0 == UTURLProtocol<UTStubConfig>.self }))
    
    URLSessionConfiguration.unregisterClass(UTURLProtocol<UTStubConfig>.self)
    XCTAssertFalse(config.protocolClasses!.contains(where: { $0 == UTURLProtocol<UTStubConfig>.self }))
  }
  
  func testEphemeralSessionConfiguration() {
    let config = URLSessionConfiguration.ephemeral
    let config2 = URLSessionConfiguration.ephemeral
    
    URLSessionConfiguration.registerClass(UTURLProtocol<UTStubConfig>.self)
    XCTAssertTrue(config.protocolClasses!.contains(where: { $0 == UTURLProtocol<UTStubConfig>.self }))
    
    URLSessionConfiguration.unregisterClass(UTURLProtocol<UTStubConfig>.self)
    XCTAssertFalse(config2.protocolClasses!.contains(where: { $0 == UTURLProtocol<UTStubConfig>.self }))
  }
}
