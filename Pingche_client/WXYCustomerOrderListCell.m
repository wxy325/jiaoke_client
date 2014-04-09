//
//  WXYCustomerOrderListCell.m
//  Pingche_client
//
//  Created by wxy325 on 4/4/14.
//  Copyright (c) 2014 wxy. All rights reserved.
//

#import "WXYCustomerOrderListCell.h"
#import "OrderEntity.h"
@implementation WXYCustomerOrderListCell

+ (WXYCustomerOrderListCell*)makeCell
{
    UINib* nib = [UINib nibWithNibName:@"WXYCustomerOrderListCell" bundle:nil];
    return [nib instantiateWithOwner:self options:nil][0];
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)bindOrderEntity:(OrderEntity *)o
{
    self.timeLabel.text = [o.createDate description];
    self.toLabel.text = o.toDesc;
    self.fromLabel.text = o.fromDesc;
    self.payButton.hidden = o.state == OrderStateArrived;
//    @property (weak, nonatomic) IBOutlet UIButton *payButton;
//    
//    @property (strong, nonatomic) IBOutlet UILabel* timeLabel;
//    @property (strong, nonatomic) IBOutlet UILabel* fromLabel;
//    @property (strong, nonatomic) IBOutlet UILabel* toLabel;
}
@end
