//
//  HTTPMessage.m
//  Stubber
//
//  Created by Aleksey Zgurskiy on 05.06.2018.
//  Copyright © 2018 Graviti Mobail, TOV. All rights reserved.
//

#import "HTTPMessage.h"
#import <Foundation/NSDictionary.h>

@interface HTTPMessage ()

@property (assign, nonatomic) CFHTTPMessageRef message;

@end

@implementation HTTPMessage

- (instancetype)initWithData:(NSData *)data isRequest:(BOOL)isRequest {
  CFHTTPMessageRef message = CFHTTPMessageCreateEmpty(kCFAllocatorDefault, isRequest);
  if (message == nil) return nil;
  
  CFHTTPMessageAppendBytes(message, data.bytes, data.length);
  
  self = [super init];
  _message = message;
  return self;
}

- (instancetype)initWithRequest:(NSURLRequest *)request {
  CFHTTPMessageRef message = CFHTTPMessageCreateRequest(kCFAllocatorDefault,
                                                        (__bridge CFStringRef)request.HTTPMethod,
                                                        (__bridge CFURLRef)request.URL,
                                                        kCFHTTPVersion1_1);
  if (message == nil) return nil;
  
  CFHTTPMessageSetBody(message, (__bridge CFDataRef)request.HTTPBody);
  CFHTTPMessageSetHeaderFieldValue(message, (__bridge CFStringRef)@"Host", (__bridge CFStringRef)request.URL.host);
  
  [request.allHTTPHeaderFields enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *obj, BOOL *stop) {
    CFHTTPMessageSetHeaderFieldValue(message, (__bridge CFStringRef)key, (__bridge CFStringRef)obj);
  }];
  
  self = [super init];
  _message = message;
  return self;
}

- (void)dealloc {
  CFRelease(_message);
}

- (NSInteger)statusCode {
  if (CFHTTPMessageIsRequest(self.message)) {
    return 0;
  } else {
    return (NSInteger)CFHTTPMessageGetResponseStatusCode(self.message);
  }
}

- (NSString *)host {
  CFURLRef url = CFHTTPMessageCopyRequestURL(self.message);
  if (url == 0x0) {
    return nil;
  }
  
  CFStringRef host = CFURLCopyHostName(url);
  NSString *hostString = (__bridge NSString *)host;
  
  CFRelease(url);
  CFRelease(host);
  
  return hostString;
}

- (NSString *)path {
  CFURLRef url = CFHTTPMessageCopyRequestURL(self.message);
  if (url == 0x0) {
    return nil;
  }
  
  CFStringRef path = CFURLCopyPath(url);
  NSString *pathString = (__bridge NSString *)path;
  
  CFRelease(url);
  CFRelease(path);
  
  return pathString;
}

- (NSString *)method {
  CFStringRef method = CFHTTPMessageCopyRequestMethod(self.message);
  if (method == 0x0) {
    return nil;
  }
  
  NSString *methodString = (__bridge NSString *)method;
  CFRelease(method);
  
  return methodString;
}

- (NSString *)httpVersion {
  CFStringRef version = CFHTTPMessageCopyVersion(self.message);
  if (version == 0x0) {
    return nil;
  }
  
  NSString *httpVersion = (__bridge NSString *)version;
  CFRelease(version);
  
  return httpVersion;
}

- (NSDictionary<NSString *,NSString *> *)headers {
  CFDictionaryRef headers = CFHTTPMessageCopyAllHeaderFields(self.message);
  if (CFDictionaryGetCount(headers) == 0) {
    CFRelease(headers);
    return nil;
  }
  
  NSDictionary *headersDict = (__bridge NSDictionary *)headers;
  CFRelease(headers);
  
  return headersDict;
}

- (NSData *)body {
  CFDataRef body = CFHTTPMessageCopyBody(self.message);
  if (body == 0x0) {
    return nil;
  }
  
  NSData *bodyData = (__bridge NSData *)body;
  CFRelease(body);
  
  return bodyData;
}

- (NSString *)serializedMessage {
  CFDataRef message = CFHTTPMessageCopySerializedMessage(self.message);
  if (message == 0x0) {
    return nil;
  }
  
  NSString *messageString = [[NSString alloc] initWithData:(__bridge NSData *)message
                                                  encoding:NSUTF8StringEncoding];
  CFRelease(message);
  
  return messageString;
}

@end
