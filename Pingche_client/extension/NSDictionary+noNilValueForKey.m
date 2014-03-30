//
//  NSDictionary+noNilValueForKey.m
//  yimo_ios
//
//  Created by wxy325 on 12/28/13.
//  Copyright (c) 2013 Tongji Univ. All rights reserved.
//

#import "NSDictionary+noNilValueForKey.h"

@implementation NSDictionary (noNilValueForKey)


- (id)noNilValueForKey:(NSString*)key
{
    id value = self[key];
    if ([value isKindOfClass:[NSNull class]])
    {
        value = nil;
    }
    return value;
}

@end
