//
//  POIAnnotation.m
//  SearchV3Demo
//
//  Created by songjian on 13-8-16.
//  Copyright (c) 2013年 songjian. All rights reserved.
//

#import "DriverInfoAnnotation.h"
#import "DriverInfo.h"
@interface DriverInfoAnnotation ()


@end

@implementation DriverInfoAnnotation
- (void)setDriver:(DriverInfo *)driver
{
    _driver = driver;
    self.coordinate = driver.location;
    self.title = driver.realName;
    self.subtitle = [NSString stringWithFormat:@"车牌号:%@",driver.carNumber];
}

- (id)init
{
    return [super init];
}

@end
