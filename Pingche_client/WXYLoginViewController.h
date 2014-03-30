//
//  WXYLoginViewController.h
//  Pingche_client
//
//  Created by wxy325 on 3/8/14.
//  Copyright (c) 2014 wxy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WXYLoginViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwdTextField;

- (IBAction)loginButtonPressed:(id)sender;

@end
