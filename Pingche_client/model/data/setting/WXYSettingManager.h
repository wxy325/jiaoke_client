//
//  WXYSettingManager.h
//  yimo_ios
//
//  Created by wxy325 on 12/26/13.
//  Copyright (c) 2013 Tongji Univ. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UserInfo;

#define SHARE_SETTING_MANAGER [WXYSettingManager shareSettingManager]

@interface WXYSettingManager : NSObject

+ (WXYSettingManager*)shareSettingManager;

@property (strong, nonatomic) UserInfo* currentUserInfo;
@property (assign, nonatomic) BOOL isLogin;
@end
