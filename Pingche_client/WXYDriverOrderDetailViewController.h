//
//  WXYDriverOrderDetailViewController.h
//  Pingche_client
//
//  Created by wxy325 on 4/4/14.
//  Copyright (c) 2014 wxy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OrderEntity;

@interface WXYDriverOrderDetailViewController : UIViewController
@property (strong, nonatomic) OrderEntity* order;


@property (weak, nonatomic) IBOutlet UILabel *customerLocationLabel;
@property (weak, nonatomic) IBOutlet UILabel *customerNameLabel;
- (IBAction)btnPressed:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *desLabel;
@property (weak, nonatomic) IBOutlet UIButton *btn;

@property (weak, nonatomic) IBOutlet UILabel *stateLabel;
@end
