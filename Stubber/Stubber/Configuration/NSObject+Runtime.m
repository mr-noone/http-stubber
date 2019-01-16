//
//  NSObject+Runtime.m
//  Temp
//
//  Created by Aleksey Zgurskiy on 06.07.2018.
//  Copyright © 2018 Graviti Mobail, TOV. All rights reserved.
//

#import "NSObject+Runtime.h"
#import <objc/runtime.h>

@implementation NSObject (Runtime)

#pragma mark - Swizzling

+ (void)swizzleClassMethod:(SEL)originalSelector withMethod:(SEL)swizzledSelector {
  Class class = object_getClass(self);
  Method originalMethod = class_getClassMethod(class, originalSelector);
  Method swizzledMethod = class_getClassMethod(class, swizzledSelector);
  [self swizzleMethod:originalMethod withMethod:swizzledMethod forClass:class];
}

+ (void)swizzleInstanceMethod:(SEL)originalSelector withMethod:(SEL)swizzledSelector {
  Class class = self.class;
  Method originalMethod = class_getInstanceMethod(class, originalSelector);
  Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
  [self swizzleMethod:originalMethod withMethod:swizzledMethod forClass:class];
}

+ (void)swizzleMethod:(Method)originalMethod withMethod:(Method)swizzledMethod forClass:(Class)class {
  IMP swizzledMethodImpl = method_getImplementation(swizzledMethod);
  const char *swizzledMethodEncod = method_getTypeEncoding(swizzledMethod);
  BOOL isMethodAdded = class_addMethod(class, method_getName(originalMethod), swizzledMethodImpl, swizzledMethodEncod);
  
  if (isMethodAdded) {
    IMP originalMethodImpl = method_getImplementation(originalMethod);
    const char *originalMethodEncod = method_getTypeEncoding(originalMethod);
    class_replaceMethod(class, method_getName(swizzledMethod), originalMethodImpl, originalMethodEncod);
  } else {
    method_exchangeImplementations(originalMethod, swizzledMethod);
  }
}

@end
