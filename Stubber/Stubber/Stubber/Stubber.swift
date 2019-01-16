//
//  Stubber.swift
//  Stubber
//
//  Created by Aleksey Zgurskiy on 08.06.2018.
//  Copyright © 2018 Graviti Mobail, TOV. All rights reserved.
//

import Foundation
import HTTPMessage

private typealias StubType = Stub<Request, Response>
private typealias URLProtocolType = StubURLProtocol<StubType>

public func startStubber() {
  URLProtocol.registerClass(URLProtocolType.self)
  URLSessionConfiguration.registerURLProtocol(URLProtocolType.self)
}

public func stopStubber() {
  URLProtocol.unregisterClass(URLProtocolType.self)
  URLSessionConfiguration.unregisterURLProtocol(URLProtocolType.self)
}

@discardableResult
public func stubRequest(_ method: String, path: String, host: String? = nil) -> StubRequest {
  let stub = StubType()
  stub.request.setMethod(method, path: path, host: host)
  URLProtocolType.addStub(stub)
  return stub
}

@discardableResult
public func stubRequest(contentsOf url: URL) throws -> StubRequest {
  let data = try Data(contentsOf: url)
  let message = HTTPMessage(data: data, isRequest: true)
  
  let stub = stubRequest(message.method ?? "GET",
                         path: message.path ?? "",
                         host: message.host) as! StubType
  stub.request.setHeaders(message.headers)
  stub.request.setBody(message.body)
  
  return stub
}

public func removeStub(_ stub: StubRequest) {
  if let stub = stub as? StubType {
    URLProtocolType.removeStub(stub)
  }
}

public func removeAllStubs() {
  URLProtocolType.removeAllStubs()
}

public func setTestEnvironment() {
  URLProtocolType.setTestEnvironment(true)
}
