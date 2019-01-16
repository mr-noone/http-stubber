//
//  StubURLProtocol.swift
//  Stubber
//
//  Created by Aleksey Zgurskiy on 06.06.2018.
//  Copyright © 2018 Graviti Mobail, TOV. All rights reserved.
//

import Foundation

protocol IStubURLProtocol where Self: URLProtocol {
  associatedtype C: StubConfigProtocol
  
  static var stubs: [C.Stub] { get }
  static var isTestEnvironment: Bool { get }
  
  static func addStub(_ stub: C.Stub)
  static func removeStub(_ stub: C.Stub)
  static func removeAllStubs()
  static func setTestEnvironment()
}

final class StubURLProtocol<C: StubConfigProtocol>: URLProtocol, IStubURLProtocol {
  //MARK: - Properties
  
  private(set) static var stubs: [C.Stub] {
    get { return C.stubs }
    set { C.stubs = newValue }
  }
  
  private(set) static var isTestEnvironment: Bool {
    get { return C.isTestEnvironment }
    set { C.isTestEnvironment = newValue }
  }
  
  //MARK: - Stubs management
  
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
  
  private static func stub(for request: URLRequest) -> C.Stub? {
    return stubs.first() {
      return ($0.request.host == nil ? true : $0.request.host == request.url?.host) &&
        $0.request.path == request.url?.path &&
        $0.request.method == request.httpMethod
    }
  }
  
  //MARK: - URLProtocol
  
  override class func canInit(with request: URLRequest) -> Bool {
    return isTestEnvironment || stub(for: request) != nil
  }
  
  override class func canonicalRequest(for request: URLRequest) -> URLRequest {
    return request
  }
  
  override func startLoading() {
    guard let stub = StubURLProtocol.stub(for: self.request) else {
      let reason = "An unexpected HTTP request was fired.\n\(request)"
      NSException(name: .genericException, reason: reason, userInfo: nil).raise()
      return
    }
    
    if let error = stub.response.error {
      client?.urlProtocol(self, didFailWithError: error)
    } else {
      let response = HTTPURLResponse(url: request.url!,
                                     statusCode: stub.response.statusCode ?? 200,
                                     httpVersion: nil,
                                     headerFields: stub.response.headers)!
      
      client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
      client?.urlProtocol(self, didLoad: stub.response.body ?? Data())
      client?.urlProtocolDidFinishLoading(self)
    }
  }
  
  override func stopLoading() {}
}
