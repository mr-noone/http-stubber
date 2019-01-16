//
//  Stub.swift
//  Stubber
//
//  Created by Aleksey Zgurskiy on 06.06.2018.
//  Copyright © 2018 Graviti Mobail, TOV. All rights reserved.
//

import Foundation
import HTTPMessage

protocol StubProtocol: class, Equatable {
  associatedtype Request: RequestProtocol
  associatedtype Response: ResponseProtocol
  
  var request: Request { get }
  var response: Response { get }
  
  init()
  
  static func stubRequest(_ method: String, path: String, host: String?) -> Self
  static func stubRequest(contentsOf url: URL) throws -> Self
}

extension StubProtocol {
  static func stubRequest(_ method: String, path: String, host: String?) -> Self {
    let stub = self.init()
    stub.request.setMethod(method, path: path, host: host)
    return stub
  }
  
  static func stubRequest(contentsOf url: URL) throws -> Self {
    let data = try Data(contentsOf: url)
    let message = HTTPMessage(data: data, isRequest: true)
    
    let stub = self.init()
    stub.request.setMethod(message.method ?? "GET",
                           path: message.path ?? "",
                           host: message.host)
    stub.request.setHeaders(message.headers)
    stub.request.setBody(message.body)
    
    return stub
  }
}

final class Stub<Request: RequestProtocol, Response: ResponseProtocol>: StubProtocol, StubRequest, StubResponse {
  private(set) lazy var request: Request = Request()
  private(set) lazy var response: Response = Response()
  
  static func == (left: Stub<Request, Response>, right: Stub<Request, Response>) -> Bool {
    return left.request == right.request && left.response == right.response
  }
}
