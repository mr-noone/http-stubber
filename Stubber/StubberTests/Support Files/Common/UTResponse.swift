//
//  UTResponse.swift
//  StubberTests
//
//  Created by Aleksey Zgurskiy on 06.06.2018.
//  Copyright © 2018 Graviti Mobail, TOV. All rights reserved.
//

import Foundation
@testable import Stubber

class UTResponse: ResponseProtocol {
  var statusCode: Int?
  var headers: [String : String]?
  var body: Data?
  
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
  
  static func == (left: UTResponse, right: UTResponse) -> Bool {
    return left.statusCode == right.statusCode &&
      left.headers == right.headers &&
      left.body == right.body
  }
}
