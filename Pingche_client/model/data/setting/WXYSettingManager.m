//
//  WXYSettingManager.m
//  yimo_ios
//
//  Created by wxy325 on 12/26/13.
//  Copyright (c) 2013 Tongji Univ. All rights reserved.
//

#import "WXYSettingManager.h"
#import "UserInfo.h"
#define kUserInfoKey @"USER_INFO_KEY"

@interface WXYSettingManager ()

@property (strong, nonatomic) NSUserDefaults* userDefault;

@end

@implementation WXYSettingManager

@synthesize currentUserInfo = _currentUserInfo;
@dynamic isLogin;
#pragma mark - Getter And Setter Method
/*
- (UserInfo*)currentUserInfo
{
    if (!_currentUserInfo)
    {
        
        NSDictionary* dict = [self.userDefault objectForKey:kUserInfoKey];
        if (dict)
        {
            _currentUserInfo =  [[UserInfo alloc] initWithDict:dict];
        }
    }
    return _currentUserInfo;
}
- (void)setCurrentUserInfo:(UserInfo *)currentUserInfo
{
    _currentUserInfo = currentUserInfo;
    if (_currentUserInfo)
    {
        [self.userDefault setObject:_currentUserInfo.toDict forKey:kUserInfoKey];
    }
    else
    {
        [self.userDefault removeObjectForKey:kUserInfoKey];
    }
    [self.userDefault synchronize];
}
 */

- (BOOL)isLogin
{
    return self.currentUserInfo != nil;
}

#pragma mark - Static Method
+ (WXYSettingManager*)shareSettingManager
{
    static WXYSettingManager* s_settingEngine = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        s_settingEngine = [[WXYSettingManager alloc] init];
    });
    return s_settingEngine;
}

#pragma mark - Init Method
- (id)init
{
    self = [super init];
    if (self)
    {
        self.userDefault = [NSUserDefaults standardUserDefaults];
    }
    return self;
}

@end
