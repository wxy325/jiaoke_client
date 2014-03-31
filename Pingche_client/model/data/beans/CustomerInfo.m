//
//  CustomerInfo.m
//  Pingche_client
//
//  Created by wxy325 on 3/30/14.
//  Copyright (c) 2014 wxy. All rights reserved.
//

#import "CustomerInfo.h"

@implementation CustomerInfo

- (id)initWithDict:(NSDictionary*)dict
{
    self = [super init];
    if (self)
    {
        self.customerId = dict[@"customer_id"];
        self.realName = dict[@"real_name"];
    }
    return self;
}

@end
