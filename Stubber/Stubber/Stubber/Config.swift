//
//  Config.swift
//  Stubber
//
//  Created by Aleksey Zgurskiy on 09.07.2018.
//  Copyright © 2018 Graviti Mobail, TOV. All rights reserved.
//

import Foundation

protocol ConfigProtocol: class {
  associatedtype Stub: StubProtocol
  
  static var stubs: [Stub] { get set }
  static var isTestEnvironment: Bool { get set }
}

final class Config: ConfigProtocol {
  typealias Stub = Stubber.Stub<Request, Response>
  
  static var stubs = [Stub]()
  static var isTestEnvironment = false
}
