//
//  UTStubConfig.swift
//  StubberTests
//
//  Created by Aleksey Zgurskiy on 22.08.2018.
//  Copyright © 2018 Graviti Mobail, TOV. All rights reserved.
//

import Foundation
@testable import HTTPStubber

final class UTStubConfig: StubConfigProtocol {
  typealias Stub = UTStub<UTRequest, UTResponse>
  
  static var stubs = [Stub]()
  static var isTestEnvironment = false
}
