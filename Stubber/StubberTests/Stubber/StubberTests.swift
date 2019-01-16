//
//  StubberTests.swift
//  StubberTests
//
//  Created by Aleksey Zgurskiy on 08.06.2018.
//  Copyright © 2018 Graviti Mobail, TOV. All rights reserved.
//

import XCTest
import Stubber

class StubberTests: XCTestCase {
  var session: URLSession!
  
  override func setUp() {
    super.setUp()
    session = URLSession(configuration: .default)
  }
  
  override func tearDown() {
    session = nil
    super.tearDown()
  }
}
