//
//  WXYNetworkOperation.m
//  yimo_ios
//
//  Created by wxy325 on 12/26/13.
//  Copyright (c) 2013 Tongji Univ. All rights reserved.
//

#import "WXYNetworkOperation.h"

@implementation WXYNetworkOperation


- (void)operationSucceeded
{
    if ([self.responseJSON isKindOfClass:[NSDictionary class]])
    {
        NSNumber* code = self.responseJSON[@"error_code"];
        //    NSString* error = self.responseJSON[@"error"];
        if (code)
        {
            self.wxyError = [[WXYError alloc] initWithDomain:kCustomeErrorDomain code:code.intValue userInfo:self.responseJSON];
            [super operationFailedWithError:self.wxyError];
        }
        else
        {
            [super operationSucceeded];
        }
    }
    else
    {
        [super operationSucceeded];
    }
}

- (void)operationFailedWithError:(NSError *)error
{
    if ([self.responseJSON isKindOfClass:[NSDictionary class]])
    {
        NSNumber* errorCode = self.responseJSON[@"error_code"];
        if (errorCode)
        {
            self.wxyError = [[WXYError alloc] initWithDomain:kCustomeErrorDomain code:[errorCode intValue] userInfo:self.responseJSON];
        }
    }
    [super operationFailedWithError:error];
}

@end
