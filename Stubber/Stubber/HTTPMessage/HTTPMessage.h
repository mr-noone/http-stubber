//
//  HTTPMessage.h
//  Stubber
//
//  Created by Aleksey Zgurskiy on 05.06.2018.
//  Copyright © 2018 Graviti Mobail, TOV. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreFoundation/CoreFoundation.h>

@interface HTTPMessage : NSObject

+ (nonnull instancetype)new __attribute__((unavailable("use '-initWithMessage:' instead")));
- (nonnull instancetype)init __attribute__((unavailable("use '-initWithMessage:' instead")));
- (nonnull instancetype)initWithData:(nonnull NSData *)data isRequest:(BOOL)isRequest;

@property (assign, nonatomic, readonly) NSInteger statusCode;
@property (copy, nonatomic, readonly, nullable) NSString *host;
@property (copy, nonatomic, readonly, nullable) NSString *path;
@property (copy, nonatomic, readonly, nullable) NSString *method;
@property (copy, nonatomic, readonly, nullable) NSString *httpVersion;
@property (copy, nonatomic, readonly, nullable) NSDictionary<NSString *, NSString *> *headers;
@property (copy, nonatomic, readonly, nullable) NSData *body;

@end
