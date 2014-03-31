//
//  WXYDriverNewOrderNotifyView.h
//  Pingche_client
//
//  Created by wxy325 on 3/31/14.
//  Copyright (c) 2014 wxy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OrderEntity;

@interface WXYDriverNewOrderNotifyView : UIView

- (void)bind:(OrderEntity*)o;

@property (weak, nonatomic) IBOutlet UILabel* nameLabel;
@property (weak, nonatomic) IBOutlet UILabel* telLabel;
@property (weak, nonatomic) IBOutlet UILabel* locationFromLabel;
@property (weak, nonatomic) IBOutlet UILabel* locationToLabel;

@end
