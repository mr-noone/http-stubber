//
//  NSURLSessionConfiguration+Stubber.m
//  Temp
//
//  Created by Aleksey Zgurskiy on 06.07.2018.
//  Copyright © 2018 Graviti Mobail, TOV. All rights reserved.
//

#import "NSURLSessionConfiguration+Stubber.h"
#import "NSObject+Runtime.h"
#import <objc/runtime.h>

static const void *kDefaultClassesKey = &kDefaultClassesKey;
static const void *kRegisteredClassesKey = &kRegisteredClassesKey;
static const void *kConfigurationsKey = &kConfigurationsKey;

@interface NSURLSessionConfiguration ()

@property (class, nonatomic, readonly) NSArray<Class> *protocolClasses;
@property (class, nonatomic, readonly) NSArray<Class> *defaultClasses;
@property (class, nonatomic, readonly) NSMutableArray<Class> *registeredClasses;
@property (class, nonatomic, readonly) NSPointerArray *configurations;

@end

@implementation NSURLSessionConfiguration (Stubber)

+ (void)load {
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    NSArray *classes = self.defaultSessionConfiguration.protocolClasses;
    objc_setAssociatedObject(self, kDefaultClassesKey, classes, OBJC_ASSOCIATION_RETAIN);
    
    [self swizzleInstanceMethod:@selector(copy)
                     withMethod:@selector(st_copy)];
    [self swizzleClassMethod:@selector(defaultSessionConfiguration)
                  withMethod:@selector(st_defaultSessionConfiguration)];
    [self swizzleClassMethod:@selector(ephemeralSessionConfiguration)
                  withMethod:@selector(st_ephemeralSessionConfiguration)];
  });
}

#pragma mark - Getters

+ (NSArray<Class> *)protocolClasses {
  NSMutableArray<Class> *classes = NSMutableArray.new;
  [classes addObjectsFromArray:self.registeredClasses];
  [classes addObjectsFromArray:self.defaultClasses];
  return [NSArray arrayWithArray:classes];
}

+ (NSArray<Class> *)defaultClasses {
  return objc_getAssociatedObject(self, kDefaultClassesKey);
}

+ (NSMutableArray<Class> *)registeredClasses {
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    objc_setAssociatedObject(self,
                             kRegisteredClassesKey,
                             NSMutableArray.new,
                             OBJC_ASSOCIATION_RETAIN);
  });
  return objc_getAssociatedObject(self, kRegisteredClassesKey);
}

+ (NSPointerArray *)configurations {
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    objc_setAssociatedObject(self,
                             kConfigurationsKey,
                             NSPointerArray.weakObjectsPointerArray,
                             OBJC_ASSOCIATION_RETAIN);
  });
  return objc_getAssociatedObject(self, kConfigurationsKey);
}

#pragma mark - Public

+ (void)registerURLProtocol:(Class)protocolClass {
  if (![self.registeredClasses containsObject:protocolClass]) {
    [self.registeredClasses addObject:protocolClass];
    
    NSArray<Class> *classes = self.protocolClasses;
    for (NSURLSessionConfiguration *configuration in self.configurations) {
      configuration.protocolClasses = classes;
    }
  }
}

+ (void)unregisterURLProtocol:(Class)protocolClass {
  if ([self.registeredClasses containsObject:protocolClass]) {
    [self.registeredClasses removeObject:protocolClass];
    
    NSArray<Class> *classes = self.protocolClasses;
    for (NSURLSessionConfiguration *configuration in self.configurations) {
      configuration.protocolClasses = classes;
    }
  }
}

#pragma mark - Private

- (id)st_copy {
  NSURLSessionConfiguration *configuration = [self st_copy];
  [NSURLSessionConfiguration.configurations addPointer:(__bridge void *)configuration];
  return configuration;
}

+ (NSURLSessionConfiguration *)st_defaultSessionConfiguration {
  NSURLSessionConfiguration *configuration = self.st_defaultSessionConfiguration;
  configuration.protocolClasses = self.protocolClasses;
  [self.configurations addPointer:(__bridge void *)configuration];
  return configuration;
}

+ (NSURLSessionConfiguration *)st_ephemeralSessionConfiguration {
  NSURLSessionConfiguration *configuration = self.st_ephemeralSessionConfiguration;
  configuration.protocolClasses = self.protocolClasses;
  [self.configurations addPointer:(__bridge void *)configuration];
  return configuration;
}

@end
