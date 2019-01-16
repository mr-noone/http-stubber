//
//  StubConfig.swift
//  Stubber
//
//  Created by Aleksey Zgurskiy on 21.08.2018.
//  Copyright © 2018 Graviti Mobail, TOV. All rights reserved.
//

import Foundation

protocol StubConfigProtocol: class {
  associatedtype Stub: StubProtocol
  
  static var stubs: [Stub] { get set }
  static var isTestEnvironment: Bool { get set }
}

final class StubConfig: StubConfigProtocol {
  typealias Stub = Stubber.Stub<Request, Response>
  
  static var stubs = [Stub]()
  static var isTestEnvironment = false
}
