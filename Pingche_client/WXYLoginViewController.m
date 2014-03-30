//
//  WXYLoginViewController.m
//  Pingche_client
//
//  Created by wxy325 on 3/8/14.
//  Copyright (c) 2014 wxy. All rights reserved.
//

#import "WXYLoginViewController.h"
#import "WXYNetworkEngine.h"
#import "UIViewController+ShowHud.h"
#import "WXYSettingManager.h"


@interface WXYLoginViewController ()

@end

@implementation WXYLoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Gesture
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self hideKeyboard];
}
- (void)hideKeyboard
{
    [self.userNameTextField resignFirstResponder];
    [self.passwdTextField resignFirstResponder];
}
#pragma mark - IBAction
- (IBAction)loginButtonPressed:(id)sender
{
    [self hideKeyboard];
    if (!self.userNameTextField.text.length
        ||!self.passwdTextField.text.length)
    {
        [self showErrorHudWithText:@"请输入用户名密码"];
    }
    else
    {
        MBProgressHUD* hud = [self showNetworkWaitingHud];
        [SHARE_NW_ENGINE userLogin:self.userNameTextField.text password:self.passwdTextField.text onSucceed:^
        {
            [hud hide:YES];
            if (SHARE_SETTING_MANAGER.currentUserInfo.typeId == UserTypeDriver)
            {
                [self performSegueWithIdentifier:@"driverRoot" sender:nil];
            }
            else
            {
                [self performSegueWithIdentifier:@"customerRoot" sender:nil];
            }
        } onError:^(NSError *error)
        {
            [hud hide:YES];
            [self showErrorHudWithError:error];
        }];
    }
}
@end
