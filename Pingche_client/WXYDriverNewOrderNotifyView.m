//
//  WXYDriverNewOrderNotifyView.m
//  Pingche_client
//
//  Created by wxy325 on 3/31/14.
//  Copyright (c) 2014 wxy. All rights reserved.
//

#import "WXYDriverNewOrderNotifyView.h"
#import "OrderEntity.h"
#import "CustomerInfo.h"

@implementation WXYDriverNewOrderNotifyView

- (void)bind:(OrderEntity*)o
{
    self.nameLabel.text = o.customer.realName;
    self.telLabel.text = o.customer.tel;
    self.locationFromLabel.text = o.fromDesc;
    self.locationToLabel.text = o.toDesc;
}


@end
