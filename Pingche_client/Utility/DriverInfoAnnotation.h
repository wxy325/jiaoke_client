//
//  POIAnnotation.h
//  SearchV3Demo
//
//  Created by songjian on 13-8-16.
//  Copyright (c) 2013年 songjian. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapCommonObj.h>
#import "WXYTextAnnotation.h"
@class DriverInfo;

@interface DriverInfoAnnotation : WXYTextAnnotation

- (id)init;
@property (strong, nonatomic) DriverInfo* driver;

@end
