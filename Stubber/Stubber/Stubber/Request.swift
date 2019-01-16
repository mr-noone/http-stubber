//
//  Request.swift
//  Stubber
//
//  Created by Aleksey Zgurskiy on 05.06.2018.
//  Copyright © 2018 Graviti Mobail, TOV. All rights reserved.
//

import Foundation

protocol RequestProtocol: class {
  var host: String? { get }
  var path: String? { get }
  var method: String? { get }
  var headers: [String : String]? { get }
  var body: Data? { get }
  
  init()
  
  func setMethod(_ method: String, path: String, host: String?)
  func setHeaders(_ headers: [String : String])
  func setBody(_ body: Data)
}

class Request: RequestProtocol {
  private(set) var host: String?
  private(set) var path: String?
  private(set) var method: String?
  private(set) var headers: [String : String]?
  private(set) var body: Data?
  
  required init() {}
  
  func setMethod(_ method: String, path: String, host: String?) {
    self.method = method
    self.path = path
    self.host = host
  }
  
  func setHeaders(_ headers: [String : String]) {
    self.headers = headers
  }
  
  func setBody(_ body: Data) {
    self.body = body
  }
}
