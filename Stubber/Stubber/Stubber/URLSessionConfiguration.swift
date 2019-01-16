//
//  URLSessionConfiguration.swift
//  Stubber
//
//  Created by Aleksey Zgurskiy on 07.06.2018.
//  Copyright © 2018 Graviti Mobail, TOV. All rights reserved.
//

import Foundation

extension URLSessionConfiguration {
  private class Store {
    static var isSwizzle = false
    static var protocols = [AnyClass]()
  }
  
  private static var isSwizzle: Bool {
    get { return Store.isSwizzle }
    set { Store.isSwizzle = newValue}
  }
  
  private static var protocols: [AnyClass] {
    get { return Store.protocols }
    set { Store.protocols = newValue }
  }
  
  static func containsURLProtocol(_ class: AnyClass) -> Bool {
    return protocols.contains() { $0 == `class`}
  }
  
  static func registerURLProtocol(_ class: AnyClass) {
    if !containsURLProtocol(`class`) {
      protocols.append(`class`)
    }
    
    if !isSwizzle {
      swizzle()
      isSwizzle = true
    }
  }
  
  static func unregisterURLProtocol(_ class: AnyClass) {
    if let index = protocols.index(where: { $0 == `class` }) {
      protocols.remove(at: index)
    }
  }
  
  static func swizzle() {
    let defaultMethod = class_getClassMethod(self, #selector(getter: self.default))
    let st_defaultMethod = class_getClassMethod(self, #selector(self.st_default))
    method_exchangeImplementations(defaultMethod!, st_defaultMethod!)
    
    let ephemeralMethod = class_getClassMethod(self, #selector(getter: self.ephemeral))
    let st_ephemeralMethod = class_getClassMethod(self, #selector(self.st_ephemeral))
    method_exchangeImplementations(ephemeralMethod!, st_ephemeralMethod!)
  }
  
  @objc class func st_default() -> URLSessionConfiguration {
    let configuration = st_default()
    configuration.protocolClasses = protocols + (configuration.protocolClasses ?? [])
    return configuration
  }
  
  @objc class func st_ephemeral() -> URLSessionConfiguration {
    let configuration = st_ephemeral()
    configuration.protocolClasses = protocols + (configuration.protocolClasses ?? [])
    return configuration
  }
}
