//
//  StubRequest.swift
//  Stubber
//
//  Created by Aleksey Zgurskiy on 06.06.2018.
//  Copyright © 2018 Graviti Mobail, TOV. All rights reserved.
//

import Foundation

public protocol StubRequest: class {
  @discardableResult func withHeaders(_ headers: [String : String]) -> StubRequest
  @discardableResult func withBody(_ body: Data) -> StubRequest
  @discardableResult func withBody(contentsOf url: URL) throws -> StubRequest
  
  @discardableResult func andResponse(_ statusCode: Int) -> StubResponse
  @discardableResult func andResponse(contentsOf url: URL) throws -> StubResponse
  @discardableResult func andFailWithError(_ error: Error) -> StubResponse
}

extension StubRequest where Self: StubProtocol {
  func withHeaders(_ headers: [String : String]) -> StubRequest {
    request.setHeaders(headers)
    return self
  }
  
  func withBody(_ body: Data) -> StubRequest {
    request.setBody(body)
    return self
  }
  
  func withBody(contentsOf url: URL) throws -> StubRequest {
    request.setBody(try Data(contentsOf: url))
    return self
  }
}

extension StubRequest where Self: StubProtocol & StubResponse {
  func andResponse(_ statusCode: Int) -> StubResponse {
    response.setStatusCode(statusCode)
    return self
  }
  
  func andResponse(contentsOf url: URL) throws -> StubResponse {
    let data = try Data(contentsOf: url)
    let message = HTTPMessage(data: data, isRequest: false)
    
    response.setStatusCode(message.statusCode)
    response.setHeaders(message.headers)
    response.setBody(message.body)
    
    return self
  }
  
  func andFailWithError(_ error: Error) -> StubResponse {
    response.setError(error)
    return self
  }
}
