//
//  WXYDriverRootViewController.h
//  Pingche_client
//
//  Created by wxy325 on 3/9/14.
//  Copyright (c) 2014 wxy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchAPI.h>
#import "WXYDriverNewOrderNotifyView.h"

@interface WXYDriverRootViewController : UIViewController<MAMapViewDelegate, AMapSearchDelegate>
@property (weak, nonatomic) IBOutlet UIView *contentView;
- (IBAction)currentButtonPressed:(id)sender;
- (IBAction)rbt:(id)sender ;

- (IBAction)newOrderSubmitButtonPressed:(id)sender;
@property (weak, nonatomic) IBOutlet WXYDriverNewOrderNotifyView *getNewOrderNotifyView;
@property (weak, nonatomic) IBOutlet UIView *menuView;


- (IBAction)stateChangeButtonPressed:(id)sender;
- (IBAction)settingButtonPressed:(id)sender;


@end
