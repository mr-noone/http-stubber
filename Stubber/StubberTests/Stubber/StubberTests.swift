//
//  StubberTests.swift
//  StubberTests
//
//  Created by Aleksey Zgurskiy on 08.06.2018.
//  Copyright © 2018 Graviti Mobail, TOV. All rights reserved.
//

import XCTest
import Stubber

class StubberTests: XCTestCase {
  var session: URLSession!
  
  override func setUp() {
    super.setUp()
    session = URLSession(configuration: .default)
  }
  
  override func tearDown() {
    session = nil
    removeAllStubs()
    super.tearDown()
  }
  
  func testStubRequest() {
    let exp = expectation(description: "")
    
    stubRequest("POST", path: "/path/to", host: nil)
      .andResponse(200)
      .withBody("body".data(using: .utf8)!)
    
    var request = URLRequest(url: URL(string: "http://127.0.0.1/path/to")!)
    request.httpMethod = "POST"
    session.dataTask(with: request) { (data, response, error) in
      XCTAssertEqual(data, "body".data(using: .utf8))
      XCTAssertEqual((response as! HTTPURLResponse).statusCode, 200)
      XCTAssertNil(error)
      exp.fulfill()
    }.resume()
    
    wait(for: [exp], timeout: 1)
  }
  
  func testStubRequestWithHost() {
    let exp = expectation(description: "")
    
    stubRequest("POST", path: "/path/to", host: "127.0.0.1")
      .andResponse(200)
      .withBody("body".data(using: .utf8)!)
    
    var request = URLRequest(url: URL(string: "http://127.0.0.1/path/to")!)
    request.httpMethod = "POST"
    session.dataTask(with: request) { (data, response, error) in
      XCTAssertEqual(data, "body".data(using: .utf8))
      XCTAssertEqual((response as! HTTPURLResponse).statusCode, 200)
      XCTAssertNil(error)
      exp.fulfill()
    }.resume()
    
    wait(for: [exp], timeout: 1)
  }
  
  func testStubRequestWithError() {
    let exp = expectation(description: "")
    let anError = NSError(domain: "Domain", code: 111, userInfo: nil)
    let url = URL(string: "http://127.0.0.1/path/to")!
    
    stubRequest("GET", path: "/path/to")
      .andFailWithError(anError)
    
    session.dataTask(with: url) { (data, response, error) in
      XCTAssertNil(data)
      XCTAssertNil(response)
      XCTAssertEqual(error! as NSError, anError)
      exp.fulfill()
    }.resume()
    
    wait(for: [exp], timeout: 1)
  }
  
  func testStubRequestWithoutResponse() {
    let exp = expectation(description: "")
    let url = URL(string: "http://127.0.0.1/path/to")!
    
    stubRequest("GET", path: "/path/to")
    
    session.dataTask(with: url) { (data, response, error) in
      XCTAssertEqual((response as! HTTPURLResponse).statusCode, 200)
      XCTAssertEqual(data?.count, 0)
      XCTAssertNil(error)
      exp.fulfill()
    }.resume()
    
    wait(for: [exp], timeout: 1000000)
  }
}
