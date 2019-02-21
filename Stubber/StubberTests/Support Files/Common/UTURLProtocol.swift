//
//  UTURLProtocol.swift
//  StubberTests
//
//  Created by Aleksey Zgurskiy on 22.08.2018.
//  Copyright © 2018 Graviti Mobail, TOV. All rights reserved.
//

import Foundation
@testable import HTTPStubber

final class UTURLProtocol<C: StubConfigProtocol>: Foundation.URLProtocol, HTTPStubber.URLProtocol {
  static var stubs: [C.Stub] {
    get { return C.stubs }
    set { C.stubs = newValue }
  }
  
  static var isTestEnvironment: Bool {
    get { return C.isTestEnvironment }
    set { C.isTestEnvironment = newValue }
  }
  
  static func addStub(_ stub: C.Stub) {
    stubs.append(stub)
  }
  
  static func removeStub(_ stub: C.Stub) {
    if let index = stubs.index(where: { $0 == stub }) {
      stubs.remove(at: index)
    }
  }
  
  static func removeAllStubs() {
    stubs = [C.Stub]()
  }
  
  static func setTestEnvironment() {
    isTestEnvironment = true
  }
}
