//
//  WXYCustomerResultNotifyView.h
//  Pingche_client
//
//  Created by wxy325 on 4/1/14.
//  Copyright (c) 2014 wxy. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DriverInfo;
@interface WXYCustomerResultNotifyView : UIView

@property (weak, nonatomic) IBOutlet UILabel* infoLabel;
@property (weak, nonatomic) IBOutlet UILabel* telLabel;
@property (weak, nonatomic) IBOutlet UILabel* distanceLabel;
@property (weak, nonatomic) IBOutlet UILabel* timeLabel;

- (void)bind:(DriverInfo*)d;

@end
