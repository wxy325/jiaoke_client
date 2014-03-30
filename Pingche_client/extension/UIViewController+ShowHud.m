//
//  UIViewController+ShowHud.m
//  yimo_ios
//
//  Created by wxy325 on 12/26/13.
//  Copyright (c) 2013 Tongji Univ. All rights reserved.
//

#import "UIViewController+ShowHud.h"
#import "GraphicName.h"

@implementation UIViewController (ShowHud)

- (void)showTextHud:(NSString*)text
{
    MBProgressHUD* hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:hud];
    hud.mode = MBProgressHUDModeText;
    hud.removeFromSuperViewOnHide = YES;
    hud.labelText = text;
    [hud show:YES];
    [hud hide:YES afterDelay:HUD_DELAY_DEFAULT];
}

- (void)showErrorHudWithText:(NSString*)text
{
    MBProgressHUD *HUD;
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    HUD.labelText = text;
    HUD.mode = MBProgressHUDModeCustomView;
    HUD.removeFromSuperViewOnHide = YES;
    HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:HUD_EXCLAMATION_MARK]];
    [HUD show:YES];
    [HUD hide:YES afterDelay:HUD_DELAY_DEFAULT];
}

- (void)showErrorHudWithError:(NSError*)error
{
    [self showErrorHudWithText:@"系统错误"];
}

- (void)showSuccessHudWithText:(NSString*)text
{
    MBProgressHUD *HUD;
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    HUD.labelText = text;
    HUD.mode = MBProgressHUDModeCustomView;
    HUD.removeFromSuperViewOnHide = YES;
    HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:HUD_CHECK_MARK]];
    [HUD show:YES];
    [HUD hide:YES afterDelay:HUD_DELAY_DEFAULT];
}

- (MBProgressHUD*)showNetworkWaitingHud
{
    return [self showNetworkWaitingHudInView:self.view];
}
- (MBProgressHUD*)showNetworkWaitingHudInView:(UIView*)view
{
    MBProgressHUD* hud = [[MBProgressHUD alloc] initWithView:view];
    [self.view addSubview:hud];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.removeFromSuperViewOnHide = YES;
    [hud show:YES];
    return hud;
}

@end
