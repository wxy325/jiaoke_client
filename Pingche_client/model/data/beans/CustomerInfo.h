//
//  CustomerInfo.h
//  Pingche_client
//
//  Created by wxy325 on 3/30/14.
//  Copyright (c) 2014 wxy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CustomerInfo : NSObject


- (id)initWithDict:(NSDictionary*)dict;

@property (strong, nonatomic) NSNumber* customerId;
@property (strong, nonatomic) NSString* realName;
@property (strong, nonatomic) NSString* tel;
@end
