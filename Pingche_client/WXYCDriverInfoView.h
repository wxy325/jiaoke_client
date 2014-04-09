//
//  WXYCDriverInfoView.h
//  Pingche_client
//
//  Created by wxy325 on 4/4/14.
//  Copyright (c) 2014 wxy. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DriverInfo;
@interface WXYCDriverInfoView : UIView

- (void)bind:(DriverInfo*)driverInfo;


@property (strong, nonatomic) IBOutlet UILabel* nameLabel;
@property (strong, nonatomic) IBOutlet UILabel* telLabel;
@property (strong, nonatomic) IBOutlet UILabel* companyLabel;
@property (strong, nonatomic) IBOutlet UILabel* paiLabel;
@property (strong, nonatomic) IBOutlet UILabel* timeLabel;
@property (strong, nonatomic) IBOutlet UIImageView* photoImageView;
@end
