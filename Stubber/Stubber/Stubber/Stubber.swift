//
//  Stubber.swift
//  Stubber
//
//  Created by Aleksey Zgurskiy on 08.06.2018.
//  Copyright © 2018 Graviti Mobail, TOV. All rights reserved.
//

import Foundation

//MARK: - Private

func stubRequest<C: ConfigProtocol>(_ method: String, path: String, host: String?, config: C.Type) -> C.StubConfig.Stub {
  C.configure()
  let stub = C.StubConfig.Stub.stubRequest(method, path: path, host: host)
  C.URLProtocol.addStub(stub as! C.URLProtocol.C.Stub)
  return stub
}

func stubRequest<C: ConfigProtocol>(contentsOf url: URL, config: C.Type) throws -> C.StubConfig.Stub {
  C.configure()
  let stub = try C.StubConfig.Stub.stubRequest(contentsOf: url)
  C.URLProtocol.addStub(stub as! C.URLProtocol.C.Stub)
  return stub
}

func removeStub<C: ConfigProtocol>(_ stub: C.StubConfig.Stub, config: C.Type) {
  C.URLProtocol.removeStub(stub as! C.URLProtocol.C.Stub)
}

func removeAllStubs<C: ConfigProtocol>(config: C.Type) {
  C.URLProtocol.removeAllStubs()
}

func setTestEnvironment<C: ConfigProtocol>(config: C.Type) {
  C.URLProtocol.setTestEnvironment()
}

//MARK: - Public

@discardableResult
public func stubRequest(_ method: String, path: String, host: String? = nil) -> StubRequest {
  return stubRequest(method, path: path, host: host, config: Config.self)
}

@discardableResult
public func stubRequest(contentsOf url: URL) throws -> StubRequest {
  return try stubRequest(contentsOf: url, config: Config.self)
}

public func removeStub(_ stub: StubRequest) {
  removeStub(stub as! Config.StubConfig.Stub, config: Config.self)
}

public func removeAllStubs() {
  removeAllStubs(config: Config.self)
}

public func setTestEnvironment() {
  setTestEnvironment(config: Config.self)
}
