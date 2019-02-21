//
//  UTConfig.swift
//  StubberTests
//
//  Created by Aleksey Zgurskiy on 22.08.2018.
//  Copyright © 2018 Graviti Mobail, TOV. All rights reserved.
//

import Foundation
@testable import HTTPStubber

final class UTConfig: ConfigProtocol {
  typealias StubConfig = UTStubConfig
  typealias URLProtocol = UTURLProtocol<StubConfig>

  static var isConfigured: Bool = false
  
  static func configure() {}
}
