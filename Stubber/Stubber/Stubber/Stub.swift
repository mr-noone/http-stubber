//
//  Stub.swift
//  Stubber
//
//  Created by Aleksey Zgurskiy on 06.06.2018.
//  Copyright © 2018 Graviti Mobail, TOV. All rights reserved.
//

import Foundation

protocol StubProtocol: class {
  associatedtype Request: RequestProtocol
  associatedtype Response: ResponseProtocol
  
  var request: Request { get }
  var response: Response { get }
}

class Stub<Request: RequestProtocol, Response: ResponseProtocol>: StubProtocol, StubRequest, StubResponse {
  private(set) lazy var request: Request = Request()
  private(set) lazy var response: Response = Response()
}
