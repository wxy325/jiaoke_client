//
//  UIViewController+ShowHud.h
//  yimo_ios
//
//  Created by wxy325 on 12/26/13.
//  Copyright (c) 2013 Tongji Univ. All rights reserved.
//

#import <UIKit/UIKit.h>
#define HUD_DELAY_DEFAULT 1.f
#import "MBProgressHUD.h"


@interface UIViewController (ShowHud)

- (void)showTextHud:(NSString*)text;
- (void)showErrorHudWithText:(NSString*)text;
- (void)showErrorHudWithError:(NSError*)error;
- (void)showSuccessHudWithText:(NSString*)text;
- (MBProgressHUD*)showNetworkWaitingHud;
- (MBProgressHUD*)showNetworkWaitingHudInView:(UIView*)view;

@end
