//
//  UTRequest.swift
//  StubberTests
//
//  Created by Aleksey Zgurskiy on 06.06.2018.
//  Copyright © 2018 Graviti Mobail, TOV. All rights reserved.
//

import Foundation
@testable import Stubber

class UTRequest: RequestProtocol {
  var host: String?
  var path: String? = ""
  var method: String? = "GET"
  var headers: [String : String]?
  var body: Data?
  
  required init() {}
  
  func setMethod(_ method: String, path: String, host: String?) {
    self.method = method
    self.path = path
    self.host = host
  }
  
  func setHeaders(_ headers: [String : String]?) {
    self.headers = headers
  }
  
  func setBody(_ body: Data?) {
    self.body = body
  }
  
  static func == (left: UTRequest, right: UTRequest) -> Bool {
    return left.host == right.host &&
      left.path == right.path &&
      left.method == right.method &&
      left.headers == right.headers &&
      left.body == right.body
  }
}
