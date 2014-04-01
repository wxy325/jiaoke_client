//
//  WXYCustomerInfoAnnotation.h
//  Pingche_client
//
//  Created by wxy325 on 4/1/14.
//  Copyright (c) 2014 wxy. All rights reserved.
//

#import "WXYTextAnnotation.h"
@class CustomerInfo;

@interface WXYCustomerInfoAnnotation : WXYTextAnnotation

@property (strong, nonatomic) CustomerInfo* customer;
@end
