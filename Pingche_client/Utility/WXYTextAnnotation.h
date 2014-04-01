//
//  WXYTextAnnotation.h
//  Pingche_client
//
//  Created by wxy325 on 4/1/14.
//  Copyright (c) 2014 wxy. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>

@interface WXYTextAnnotation : MAPointAnnotation

@property (strong, nonatomic) NSString* title;
@property (strong, nonatomic) NSString* subtitle;

@end
