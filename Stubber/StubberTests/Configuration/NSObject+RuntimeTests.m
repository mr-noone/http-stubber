//
//  NSObject+RuntimeTests.m
//  TempTests
//
//  Created by Aleksey Zgurskiy on 06.07.2018.
//  Copyright © 2018 Graviti Mobail, TOV. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "NSObject+Runtime.h"

@interface NSObject (UnitTests)

@end

@implementation NSObject (UnitTests)

+ (BOOL)isSwizzleClassMethod {
  return NO;
}

+ (BOOL)ut_isSwizzleClassMethod {
  return YES;
}

- (BOOL)isSwizzleInstanceMethod {
  return NO;
}

- (BOOL)ut_isSwizzleInstanceMethod {
  return YES;
}

@end

@interface NSObject_RuntimeTests : XCTestCase

@end

@implementation NSObject_RuntimeTests

- (void)setUp {
  [super setUp];
  
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    [NSObject swizzleClassMethod:@selector(isSwizzleClassMethod) withMethod:@selector(ut_isSwizzleClassMethod)];
    [NSObject swizzleInstanceMethod:@selector(isSwizzleInstanceMethod) withMethod:@selector(ut_isSwizzleInstanceMethod)];
  });
}

- (void)testSwizzleClassMethod {
  XCTAssertTrue(NSObject.isSwizzleClassMethod, @"Must be call swizzled method");
}

- (void)testSwizzleInstanceMethod {
  XCTAssertTrue(NSObject.new.isSwizzleInstanceMethod, @"Must be call swizzled method");
}

@end
