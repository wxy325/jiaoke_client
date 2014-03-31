//
//  WXYNetworoEngine.m
//  yimo_ios
//
//  Created by wxy325 on 12/26/13.
//  Copyright (c) 2013 Tongji Univ. All rights reserved.
//

#import "WXYNetworkEngine.h"
#import "WXYNetworkOperation.h"
#import "WXYSettingManager.h"
#import "GraphicName.h"
#import "NSDictionary+noNilValueForKey.h"

//#define HOST_NAME @"10.60.42.200:12357/YimoERP"
#define HOST_NAME @"192.168.1.100:8000"

//User
#define URL_USER_REGISTER @"user_register"
#define URL_USER_LOGIN @"user_login"
#define URL_USER_GET_INFO @"user_get_info"
#define URL_USER_LOGOUT @"user_logout"

//Customer

//Driver
#define URL_DRIVER_UPDATE_LOCATION @"driver/update_location"
#define URL_DRIVER_GET_ORDER @"driver/get_order"
#define URL_DRIVER_UPDATE_ORDER @"driver/update_order"


@interface WXYNetworkEngine ()
//Private Method
- (MKNetworkOperation*)startOperationWithPath:(NSString*)path
                                    needLogin:(BOOL)fLogin
                                     paramers:(NSDictionary*)paramDict
                                     dataDict:(NSDictionary*)dataDict
                                  onSucceeded:(OperationSucceedBlock)succeedBlock
                                      onError:(OperationErrorBlock)errorBlock;
- (MKNetworkOperation*)startOperationWithPath:(NSString*)path
                                    needLogin:(BOOL)fLogin
                                     paramers:(NSDictionary*)paramDict
                                  onSucceeded:(OperationSucceedBlock)succeedBlock
                                      onError:(OperationErrorBlock)errorBlock;

@end

@implementation WXYNetworkEngine
#pragma mark - Static Method
+ (WXYNetworkEngine*)shareNetworkEngine
{
    static WXYNetworkEngine* s_networkEngine = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        s_networkEngine = [[WXYNetworkEngine alloc] initWithHostName:HOST_NAME];
    });
    return s_networkEngine;
}
#pragma mark - Init Method
- (id)initWithHostName:(NSString *)hostName
{
    self = [super initWithHostName:hostName];
    if (self)
    {
        [self registerOperationSubclass:[WXYNetworkOperation class]];
        [self useCache];
    }
    return self;
}
#pragma mark - Private Method
- (MKNetworkOperation*)startOperationWithPath:(NSString*)path
                                    needLogin:(BOOL)fLogin
                                     paramers:(NSDictionary*)paramDict
                                     dataDict:(NSDictionary*)dataDict
                                  onSucceeded:(OperationSucceedBlock)succeedBlock
                                      onError:(OperationErrorBlock)errorBlock
{
    MKNetworkOperation* op = nil;
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    if (fLogin)
    {
        [params setObject:SHARE_SETTING_MANAGER.currentUserInfo.sessionId forKey:@"session_id"];
    }
//    if (userInfo)
//    {
//        [params setValue:userInfo.accessToken forKey:@"access_token"];
//    }
    [params addEntriesFromDictionary:paramDict];
    op = [self operationWithPath:path
                          params:params
                      httpMethod:@"POST"
                             ssl:NO];
    for (NSString* key in dataDict.allKeys)
    {
        [op addData:dataDict[key] forKey:key];
    }
    
    [op addCompletionHandler:succeedBlock errorHandler:errorBlock];
    [self enqueueOperation:op forceReload:YES];
    return op;
}
- (MKNetworkOperation*)startOperationWithPath:(NSString*)path
                                    needLogin:(BOOL)fLogin
                                     paramers:(NSDictionary*)paramDict
                                  onSucceeded:(OperationSucceedBlock)succeedBlock
                                      onError:(OperationErrorBlock)errorBlock
{
    return [self startOperationWithPath:path needLogin:fLogin paramers:paramDict dataDict:nil onSucceeded:succeedBlock onError:errorBlock];
}

#pragma mark - Network Service Client
#pragma mark - Test
#pragma mark - User
- (MKNetworkOperation*)userLogin:(NSString* )userName
                        password:(NSString*)passwd
                       onSucceed:(VoidBlock)succeedBlock
                         onError:(ErrorBlock)errorBlock
{
    MKNetworkOperation* op = nil;
    
    op = [self startOperationWithPath:URL_USER_LOGIN
                            needLogin:NO
                             paramers:@{@"user_name":userName, @"password":passwd}
                          onSucceeded:^(MKNetworkOperation *completedOperation)
          {
              NSDictionary* dict = completedOperation.responseJSON;
              UserInfo* userInfo = [[UserInfo alloc] init];
              userInfo.userName = dict[@"user_name"];
              userInfo.sessionId = dict[@"session_id"];
              userInfo.realName = dict[@"real_name"];
              userInfo.gender = ((NSNumber*)dict[@"gender"]).intValue;
              userInfo.typeId = ((NSNumber*)dict[@"type_id"]).intValue;
              SHARE_SETTING_MANAGER.currentUserInfo = userInfo;
              if (succeedBlock)
              {
                  succeedBlock();
              }
          }
                              onError:^(MKNetworkOperation *completedOperation, NSError *error)
          {
              if (errorBlock) {
                  errorBlock(error);
              }
          }];
    
    return op;
}


#pragma mark - Driver
- (MKNetworkOperation*)driverUpdateLocation:(CLLocationCoordinate2D)location
                                  onSucceed:(VoidBlock)succeedBlock
                                    onError:(ErrorBlock)errorBlock
{
    MKNetworkOperation* op = nil;
    op = [self startOperationWithPath:URL_DRIVER_UPDATE_LOCATION
                            needLogin:YES
                             paramers:@{
                                        @"latitude":@(location.latitude),
                                        @"longitude":@(location.longitude)
                                        }
                          onSucceeded:^(MKNetworkOperation *completedOperation) {
                              if (succeedBlock)
                              {
                                  succeedBlock();
                              }
                             }
                              onError:^(MKNetworkOperation *completedOperation, NSError *error)
    {
        if (errorBlock)
        {
            errorBlock(error);
        }
        
    }];
    return op;
}



- (MKNetworkOperation*)driverGetOrderState:(GetOrderType)type
                                 onSucceed:(ArrayBlock)succeedBlock
                                   onError:(ErrorBlock)errorBlock
{
    MKNetworkOperation* op = nil;
    
    op = [self startOperationWithPath:URL_DRIVER_GET_ORDER
                            needLogin:YES
                             paramers:@{@"type":@(type)}
                          onSucceeded:^(MKNetworkOperation *completedOperation)
    {
        if (succeedBlock)
        {
            NSArray* responseArray = completedOperation.responseJSON;
            NSMutableArray* array = [@[] mutableCopy];
            for (NSDictionary* dict in responseArray)
            {
                OrderEntity* o = [[OrderEntity alloc] initWithDict:dict];
                [array addObject:o];
            }
            succeedBlock(array);
        }
    }
                              onError:^(MKNetworkOperation *completedOperation, NSError *error)
    {
        if (errorBlock)
        {
            errorBlock(error);
        }
    }];
    
    return op;
}

- (MKNetworkOperation*)driverUpdateOrderOrderId:(NSNumber*)orderId
                                          state:(OrderState)state
                                    onSucceed:(VoidBlock)succeedBlock
                                      onError:(ErrorBlock)errorBlock
{
    MKNetworkOperation* op = nil;
    
    op = [self startOperationWithPath:URL_DRIVER_UPDATE_ORDER
                            needLogin:YES
                             paramers:@{@"order_id":orderId,
                                        @"order_state":@(state)}
                          onSucceeded:^(MKNetworkOperation *completedOperation)
          {
              if (succeedBlock)
              {
                  succeedBlock();
              }
          }
                              onError:^(MKNetworkOperation *completedOperation, NSError *error)
          {
              if (errorBlock)
              {
                  errorBlock(error);
              }
          }];
    
    return op;
}

@end
