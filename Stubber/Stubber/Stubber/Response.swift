//
//  Response.swift
//  Stubber
//
//  Created by Aleksey Zgurskiy on 06.06.2018.
//  Copyright © 2018 Graviti Mobail, TOV. All rights reserved.
//

import Foundation

protocol ResponseProtocol: class, Equatable {
  var statusCode: Int? { get }
  var headers: [String : String]? { get }
  var body: Data? { get }
  
  init()
  
  func setStatusCode(_ statusCode: Int)
  func setHeaders(_ headers: [String : String]?)
  func setBody(_ body: Data?)
}

class Response: ResponseProtocol {
  private(set) var statusCode: Int?
  private(set) var headers: [String : String]?
  private(set) var body: Data?
  
  required init() {}
  
  func setStatusCode(_ statusCode: Int) {
    self.statusCode = statusCode
  }
  
  func setHeaders(_ headers: [String : String]?) {
    self.headers = headers
  }
  
  func setBody(_ body: Data?) {
    self.body = body
  }
  
  static func == (left: Response, right: Response) -> Bool {
    return left.statusCode == right.statusCode &&
      left.headers == right.headers &&
      left.body == right.body
  }
}
