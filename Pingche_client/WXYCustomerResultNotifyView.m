//
//  WXYCustomerResultNotifyView.m
//  Pingche_client
//
//  Created by wxy325 on 4/1/14.
//  Copyright (c) 2014 wxy. All rights reserved.
//

#import "WXYCustomerResultNotifyView.h"
#import "DriverInfo.h"

@implementation WXYCustomerResultNotifyView

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
- (void)bind:(DriverInfo*)d
{
    self.infoLabel.text = [NSString stringWithFormat:@"%@ %@ %@",d.realName, d.carNumber, d.company];
    self.telLabel.text = [NSString stringWithFormat:@"联系电话：%@",d.tel];
//    @property (weak, nonatomic) IBOutlet UILabel* infoLabel;
//    @property (weak, nonatomic) IBOutlet UILabel* telLabel;
//    @property (weak, nonatomic) IBOutlet UILabel* distanceLabel;
//    @property (weak, nonatomic) IBOutlet UILabel* timeLabel;
}
@end
