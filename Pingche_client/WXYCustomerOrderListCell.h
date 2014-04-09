//
//  WXYCustomerOrderListCell.h
//  Pingche_client
//
//  Created by wxy325 on 4/4/14.
//  Copyright (c) 2014 wxy. All rights reserved.
//

#import <UIKit/UIKit.h>
@class OrderEntity;

@interface WXYCustomerOrderListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *payButton;

@property (strong, nonatomic) IBOutlet UILabel* timeLabel;
@property (strong, nonatomic) IBOutlet UILabel* fromLabel;
@property (strong, nonatomic) IBOutlet UILabel* toLabel;

+ (WXYCustomerOrderListCell*)makeCell;

- (void)bindOrderEntity:(OrderEntity*)o;

@end
