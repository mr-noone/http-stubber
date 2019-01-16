//
//  StubURLProtocol.swift
//  Stubber
//
//  Created by Aleksey Zgurskiy on 06.06.2018.
//  Copyright © 2018 Graviti Mobail, TOV. All rights reserved.
//

import Foundation

class StubURLProtocol: URLProtocol {
  override class func canInit(with request: URLRequest) -> Bool {
    return false
  }
  
  override class func canonicalRequest(for request: URLRequest) -> URLRequest {
    return request
  }
  
  override class func requestIsCacheEquivalent(_ a: URLRequest, to b: URLRequest) -> Bool {
    return false
  }
}
