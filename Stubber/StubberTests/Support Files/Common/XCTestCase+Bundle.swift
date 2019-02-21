//
//  XCTestCase+Bundle.swift
//  StubberTests
//
//  Created by Aleksey Zgurskiy on 06.06.2018.
//  Copyright © 2018 Graviti Mobail, TOV. All rights reserved.
//

import XCTest

extension XCTestCase {
  var bundle: Bundle {
    return Bundle(for: type(of: self))
  }
}
