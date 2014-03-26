//
//  WXYViewController.h
//  Pingche_client
//
//  Created by wxy325 on 3/8/14.
//  Copyright (c) 2014 wxy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchAPI.h>

@interface WXYMapViewController : UIViewController<MAMapViewDelegate, AMapSearchDelegate>
@property (weak, nonatomic) IBOutlet UIView *contentView;
- (IBAction)currentButtonPressed:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *loadButtonPressed;
- (IBAction)rbt:(id)sender;

- (IBAction)menuButtonPressed:(id)sender;



@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIView *menuView;

@property (weak, nonatomic) IBOutlet UITextField *maleNumberTextField;
@property (weak, nonatomic) IBOutlet UITextField *femaleNumberTextField;

- (IBAction)hideKeyboard;
- (IBAction)showSearchView:(id)sender;
@end