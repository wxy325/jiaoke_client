//
//  POIAnnotation.h
//  SearchV3Demo
//
//  Created by songjian on 13-8-16.
//  Copyright (c) 2013年 songjian. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapCommonObj.h>

@interface POIAnnotation : MAPointAnnotation

@property (strong, nonatomic) NSString* title;
@property (strong, nonatomic) NSString* subTitle;

- (id)init;

@end
