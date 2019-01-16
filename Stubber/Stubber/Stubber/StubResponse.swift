//
//  StubResponse.swift
//  Stubber
//
//  Created by Aleksey Zgurskiy on 06.06.2018.
//  Copyright © 2018 Graviti Mobail, TOV. All rights reserved.
//

import Foundation

public protocol StubResponse: class {
  @discardableResult func withHeaders(_ headers: [String : String]) -> StubResponse
  @discardableResult func withBody(_ body: Data) -> StubResponse
  @discardableResult func withBody(contentsOf url: URL) throws -> StubResponse
}

extension StubResponse where Self: StubProtocol {
  func withHeaders(_ headers: [String : String]) -> StubResponse {
    response.setHeaders(headers)
    return self
  }
  
  func withBody(_ body: Data) -> StubResponse {
    response.setBody(body)
    return self
  }
  
  func withBody(contentsOf url: URL) throws -> StubResponse {
    response.setBody(try Data(contentsOf: url))
    return self
  }
}
