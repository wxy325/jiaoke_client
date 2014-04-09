//
//  WXYCDriverInfoView.m
//  Pingche_client
//
//  Created by wxy325 on 4/4/14.
//  Copyright (c) 2014 wxy. All rights reserved.
//
#import "DriverInfo.h"
#import "WXYCDriverInfoView.h"

@implementation WXYCDriverInfoView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)bind:(DriverInfo*)driverInfo
{
    self.nameLabel.text = driverInfo.realName;
    self.telLabel.text = driverInfo.tel;
    self.companyLabel.text =driverInfo.company;
    self.paiLabel.text = driverInfo.carNumber;


//    @property (strong, nonatomic) IBOutlet UIImageView* photoImageView;
}
@end
