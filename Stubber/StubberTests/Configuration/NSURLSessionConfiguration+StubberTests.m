//
//  NSURLSessionConfiguration+StubberTests.m
//  TempTests
//
//  Created by Aleksey Zgurskiy on 06.07.2018.
//  Copyright © 2018 Graviti Mobail, TOV. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "NSURLSessionConfiguration+Stubber.h"

@interface UTURLProtocol: NSURLProtocol
@end

@implementation UTURLProtocol
@end

@interface NSURLSessionConfiguration_StubberTests : XCTestCase
@end

@implementation NSURLSessionConfiguration_StubberTests

- (void)testDefaultSessionConfiguration {
  NSURLSessionConfiguration *config = NSURLSessionConfiguration.defaultSessionConfiguration;
  
  [NSURLSessionConfiguration registerURLProtocol:UTURLProtocol.class];
  XCTAssertTrue([config.protocolClasses containsObject:UTURLProtocol.class]);
  
  [NSURLSessionConfiguration unregisterURLProtocol:UTURLProtocol.class];
  XCTAssertFalse([config.protocolClasses containsObject:UTURLProtocol.class]);
}

- (void)testEphemeralSessionConfiguration {
  NSURLSessionConfiguration *config = NSURLSessionConfiguration.ephemeralSessionConfiguration;
  
  [NSURLSessionConfiguration registerURLProtocol:UTURLProtocol.class];
  XCTAssertTrue([config.protocolClasses containsObject:UTURLProtocol.class]);
  
  [NSURLSessionConfiguration unregisterURLProtocol:UTURLProtocol.class];
  XCTAssertFalse([config.protocolClasses containsObject:UTURLProtocol.class]);
}

@end
