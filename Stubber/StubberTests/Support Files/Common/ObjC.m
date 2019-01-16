//
//  ObjC.m
//  StubberTests
//
//  Created by Aleksey Zgurskiy on 21.08.2018.
//  Copyright © 2018 Graviti Mobail, TOV. All rights reserved.
//

#import "ObjC.h"

@implementation ObjC

+ (BOOL)catchException:(void (^)(void))tryBlock error:(NSError *__autoreleasing *)error {
  @try {
    tryBlock();
    return YES;
  }
  @catch (NSException *ex) {
    *error = [NSError errorWithDomain:ex.name code:0 userInfo:ex.userInfo];
    return NO;
  }
}

@end
