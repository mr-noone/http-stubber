//
//  NSObject+Runtime.h
//  Temp
//
//  Created by Aleksey Zgurskiy on 06.07.2018.
//  Copyright © 2018 Graviti Mobail, TOV. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Runtime)

+ (void)swizzleClassMethod:(SEL)originalSelector withMethod:(SEL)swizzledSelector;
+ (void)swizzleInstanceMethod:(SEL)originalSelector withMethod:(SEL)swizzledSelector;

@end
