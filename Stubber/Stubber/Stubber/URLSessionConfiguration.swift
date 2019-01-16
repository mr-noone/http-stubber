//
//  NSURLSessionConfiguration.swift
//  Stubber
//
//  Created by Aleksey Zgurskiy on 12/27/18.
//  Copyright © 2018 Graviti Mobail, TOV. All rights reserved.
//

import Foundation

// MARK: - Public
extension URLSessionConfiguration {
  static func registerClass<T: Foundation.URLProtocol>(_ protocolClass: T.Type) {
    if !registeredClasses.contains(where: { $0 == protocolClass }) {
      registeredClasses.append(protocolClass)
      
      let classes = protocols
      configurations.allObjects.forEach {
        ($0 as! URLSessionConfiguration).protocolClasses = classes
      }
    }
  }
  
  static func unregisterClass<T: Foundation.URLProtocol>(_ protocolClass: T.Type) {
    if let index = registeredClasses.firstIndex(where: { $0 == protocolClass }) {
      registeredClasses.remove(at: index)
      
      let classes = protocols
      configurations.allObjects.forEach {
        ($0 as! URLSessionConfiguration).protocolClasses = classes
      }
    }
  }
}

// MARK: - Properties
private extension URLSessionConfiguration {
  class Store {
    static var defaultClasses = [AnyClass]()
    static var registeredClasses = [AnyClass]()
    static var configurations = NSPointerArray.weakObjects()
  }
  
  @objc class var protocols: [AnyClass] {
    return registeredClasses + defaultClasses
  }
  
  @objc class var defaultClasses: [AnyClass] {
    get { return Store.defaultClasses }
    set { Store.defaultClasses = newValue }
  }
  
  @objc class var registeredClasses: [AnyClass] {
    get { return Store.registeredClasses }
    set { Store.registeredClasses = newValue }
  }
  
  @objc class var configurations: NSPointerArray {
    get { return Store.configurations }
  }
}

// MARK: - Private
private extension URLSessionConfiguration {
  @objc func st_copy() -> Any {
    let configuration = st_copy() as! URLSessionConfiguration
    let pointer = Unmanaged.passUnretained(configuration).toOpaque()
    type(of: self).configurations.addPointer(pointer)
    return configuration
  }
  
  @objc class func st_defaultSessionConfiguration() -> Self {
    let configuration = st_defaultSessionConfiguration()
    configuration.protocolClasses = protocols
    return configuration
  }
  
  @objc class func st_ephemeralSessionConfiguration() -> Self {
    let configuration = st_ephemeralSessionConfiguration()
    let pointer = Unmanaged.passUnretained(configuration).toOpaque()
    
    configuration.protocolClasses = protocols
    configurations.addPointer(pointer)
    
    return configuration
  }
}
