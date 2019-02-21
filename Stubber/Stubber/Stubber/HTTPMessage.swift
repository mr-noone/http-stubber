//
//  HTTPMessage.swift
//  Stubber
//
//  Created by Aleksey Zgurskiy on 12/27/18.
//  Copyright © 2018 Graviti Mobail, TOV. All rights reserved.
//

import Foundation
import CoreFoundation

struct HTTPMessage {
  private let message: CFHTTPMessage
  
  init(data: Data, isRequest: Bool) {
    self.message = CFHTTPMessageCreateEmpty(kCFAllocatorDefault, isRequest).takeRetainedValue()
    
    let bytes = data.withUnsafeBytes { (bytes: UnsafePointer<UInt8>) in
      Array(UnsafeBufferPointer(start: bytes, count: data.count / MemoryLayout<UInt8>.stride))
    }
    
    CFHTTPMessageAppendBytes(self.message, bytes, data.count)
  }
  
  init?(request: URLRequest) {
    guard
      let method = request.httpMethod as CFString?,
      let url = request.url as CFURL?
    else {
      return nil
    }
    
    self.message = CFHTTPMessageCreateRequest(kCFAllocatorDefault, method, url, kCFHTTPVersion1_1).takeRetainedValue()
    
    if let body = request.httpBody as CFData? {
      CFHTTPMessageSetBody(self.message, body)
    }
    
    if let host = request.url?.host as CFString? {
      CFHTTPMessageSetHeaderFieldValue(self.message, "Host" as CFString, host)
    }
    
    request.allHTTPHeaderFields?.forEach {
      CFHTTPMessageSetHeaderFieldValue(self.message, $0.key as CFString, $0.value as CFString)
    }
  }
}

extension HTTPMessage {
  var statusCode: Int {
    return CFHTTPMessageIsRequest(self.message) ? 0 : CFHTTPMessageGetResponseStatusCode(self.message) as Int
  }
  
  var host: String? {
    guard
      let url = CFHTTPMessageCopyRequestURL(self.message)?.takeRetainedValue(),
      let host = CFURLCopyHostName(url) as String?
    else {
      return nil
    }
    
    return host
  }
  
  var path: String? {
    guard
      let url = CFHTTPMessageCopyRequestURL(self.message)?.takeRetainedValue(),
      let path = CFURLCopyPath(url) as String?
    else {
      return nil
    }
    
    return path
  }
  
  var method: String? {
    return CFHTTPMessageCopyRequestMethod(self.message)?.takeRetainedValue() as String?
  }
  
  var httpVersion: String? {
    let version = CFHTTPMessageCopyVersion(self.message).takeRetainedValue() as String
    if version.count == 0 {
      return nil
    }
    
    return version
  }
  
  var headers: [String : String]? {
    guard
      let headers = CFHTTPMessageCopyAllHeaderFields(self.message)?.takeRetainedValue(),
      CFDictionaryGetCount(headers) > 0
    else {
      return nil
    }
    
    return headers as? [String : String]
  }
  
  var body: Data? {
    return CFHTTPMessageCopyBody(self.message)?.takeRetainedValue() as Data?
  }
  
  var serializedMessage: String? {
    guard
      let data = CFHTTPMessageCopySerializedMessage(self.message)?.takeRetainedValue() as Data?,
      let message = String(data: data, encoding: .utf8)
    else {
      return nil
    }
    
    return message
  }
}
