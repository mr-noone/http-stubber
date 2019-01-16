//
//  StubURLProtocol.swift
//  Stubber
//
//  Created by Aleksey Zgurskiy on 06.06.2018.
//  Copyright © 2018 Graviti Mobail, TOV. All rights reserved.
//

import Foundation

private final class Store {
  static var stubs = [AnyObject]()
  static var isTestEnvironment = false
}

final class StubURLProtocol<Stub: StubProtocol>: URLProtocol {
  //MARK: - Properties
  
  private(set) static var stubs: [Stub] {
    get { return Store.stubs as! [Stub] }
    set { Store.stubs = newValue }
  }
  
  private(set) static var isTestEnvironment: Bool {
    get { return Store.isTestEnvironment }
    set { Store.isTestEnvironment = newValue }
  }
  
  //MARK: - Stubs management
  
  static func addStub(_ stub: Stub) {
    stubs.append(stub)
  }
  
  static func removeStub(_ stub: Stub) {
    if let index = stubs.index(where: { $0 == stub }) {
      stubs.remove(at: index)
    }
  }
  
  static func removeAllStubs() {
    stubs = [Stub]()
  }
  
  static func setTestEnvironment(_ isTestEnvironment: Bool) {
    self.isTestEnvironment = isTestEnvironment
  }
  
  private static func stub(for request: URLRequest) -> Stub? {
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
      fatalError("An unexpected HTTP request was fired.\n\(request)")
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
