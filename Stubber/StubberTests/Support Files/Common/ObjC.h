//
//  ObjC.h
//  StubberTests
//
//  Created by Aleksey Zgurskiy on 21.08.2018.
//  Copyright © 2018 Graviti Mobail, TOV. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ObjC : NSObject

+ (BOOL)catchException:(void(^)(void))tryBlock error:(__autoreleasing NSError **)error;

@end
