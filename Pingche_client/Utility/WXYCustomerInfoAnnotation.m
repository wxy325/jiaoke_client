//
//  WXYCustomerInfoAnnotation.m
//  Pingche_client
//
//  Created by wxy325 on 4/1/14.
//  Copyright (c) 2014 wxy. All rights reserved.
//

#import "WXYCustomerInfoAnnotation.h"
#import "CustomerInfo.h"
@implementation WXYCustomerInfoAnnotation
- (void)setCustomer:(CustomerInfo *)customer
{
    _customer = customer;
    self.title = customer.realName;
}
@end
