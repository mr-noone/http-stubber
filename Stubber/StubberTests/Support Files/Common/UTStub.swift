//
//  UTStub.swift
//  StubberTests
//
//  Created by Aleksey Zgurskiy on 06.06.2018.
//  Copyright © 2018 Graviti Mobail, TOV. All rights reserved.
//

import Foundation
@testable import Stubber

class UTStub<Request: RequestProtocol, Response: ResponseProtocol>: StubProtocol, StubRequest, StubResponse {
  private(set) lazy var request: Request = Request()
  private(set) lazy var response: Response = Response()
  
  static func == (left: UTStub<Request, Response>, right: UTStub<Request, Response>) -> Bool {
    return left.request == right.request && left.response == right.response
  }
}
