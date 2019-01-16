//
//  NSURLSessionConfiguration+Stubber.h
//  Temp
//
//  Created by Aleksey Zgurskiy on 06.07.2018.
//  Copyright © 2018 Graviti Mobail, TOV. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURLSessionConfiguration (Stubber)

+ (void)registerURLProtocol:(nonnull Class)protocolClass;
+ (void)unregisterURLProtocol:(nonnull Class)protocolClass;

@end
