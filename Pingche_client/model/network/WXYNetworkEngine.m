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

#define HOST_NAME @"192.168.2.1:8000"

//User
#define URL_USER_REGISTER @"user_register"
#define URL_USER_LOGIN @"user_login"
#define URL_USER_GET_INFO @"user_get_info"
#define URL_USER_LOGOUT @"user_logout"

//Customer
#define URL_CUSTOMER_SEARCH_DRIVER @"customer/search_driver"
#define URL_CUSTOMER_CREATE_ORDER @"customer/create_order"
#define URL_CUSTOMER_GET_ORDER @"customer/get_order"
#define URL_CUSTOMER_GET_ALL_ORDER @"customer/get_all_order"
#define URL_CUSTOMER_GET_NEAR_DRIVER @"customer/get_near_driver"

//Driver
#define URL_DRIVER_UPDATE_LOCATION @"driver/update_location"
#define URL_DRIVER_GET_ORDER @"driver/get_order"
#define URL_DRIVER_UPDATE_ORDER @"driver/update_order"
#define URL_DRIVER_GET_INFO @"driver/get_info"




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
#pragma mark - Customer
- (MKNetworkOperation*)customerSearchDriver:(CLLocationCoordinate2D)from
                                         to:(CLLocationCoordinate2D)to
                                       type:(OrderType)type
                                     reject:(NSArray*)rejectedDriverIdArray
                                  onSucceed:(void(^)(DriverInfo* driver))succeedBlock
                                    onError:(ErrorBlock)errorBlock
{
    
    
    MKNetworkOperation* op = nil;
    NSMutableString* str = [@"" mutableCopy];
    BOOL f = NO;
    for (NSNumber* driverId in rejectedDriverIdArray)
    {
        if (f)
        {
            [str appendString:@"|"];
        }
        [str appendFormat:@"%@",driverId];
        f = YES;
    }
    
    op = [self startOperationWithPath:URL_CUSTOMER_SEARCH_DRIVER
                            needLogin:YES
                             paramers:@{@"order_type":@(type),
                                        @"latitude":@(from.latitude),
                                        @"longitude":@(from.longitude),
                                        @"des_latitude":@(to.latitude),
                                        @"des_longitude":@(to.longitude),
                                        @"reject_driver_ids":str}
                          onSucceeded:^(MKNetworkOperation *completedOperation)
    {
        if (succeedBlock)
        {
            NSDictionary* dict = completedOperation.responseJSON;
            DriverInfo* d = [[DriverInfo alloc] initWithDict:dict];
            succeedBlock(d);
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

- (MKNetworkOperation*)customerCreateOrder:(NSNumber*)driverId
                                      type:(OrderType)type
                                maleNumber:(NSNumber*)maleNumber
                              femaleNumber:(NSNumber*)femaleNumber
                                      from:(CLLocationCoordinate2D)from
                                        to:(CLLocationCoordinate2D)to
                                    toDesc:(NSString*)toDesc
                                 onSucceed:(void(^)(OrderEntity* order))succeedBlock
                                   onError:(ErrorBlock)errorBlock
{
    MKNetworkOperation* op = nil;
    
    op = [self startOperationWithPath:URL_CUSTOMER_CREATE_ORDER
                            needLogin:YES
                             paramers:@{
                                        @"driver_id":driverId,
                                        @"order_type":@(type),
                                        @"male_number":maleNumber,
                                        @"female_number":femaleNumber,
                                        @"from_latitude":@(from.latitude),
                                        @"from_longitude":@(from.longitude),
                                        @"des_latitude":@(to.latitude),
                                        @"des_longitude":@(to.longitude),
                                        @"to_desc":toDesc,
                                        }
                          onSucceeded:^(MKNetworkOperation *completedOperation)
          {
              if (succeedBlock)
              {
                  NSDictionary* dict = completedOperation.responseJSON;
                  OrderEntity* o = [[OrderEntity alloc] initWithDict:dict];
                  succeedBlock(o);
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

- (MKNetworkOperation*)customerGetOrderOnSucceed:(void(^)(OrderEntity* order))succeedBlock
                                         onError:(ErrorBlock)errorBlock
{
    MKNetworkOperation* op = nil;
    
    op = [self startOperationWithPath:URL_CUSTOMER_GET_ORDER needLogin:YES paramers:@{} onSucceeded:^(MKNetworkOperation *completedOperation) {
        if (succeedBlock)
        {
            NSDictionary* dict = completedOperation.responseJSON;
            OrderEntity* o = [[OrderEntity alloc] initWithDict:dict];
            succeedBlock(o);
        }
    } onError:^(MKNetworkOperation *completedOperation, NSError *error) {
        if (errorBlock)
        {
            errorBlock(error);
        }
    }];
    return op;
}
- (MKNetworkOperation*)customerGetAllOrder:(void(^)(NSArray* nArray, NSArray* hArray))succeedBlock onError:(ErrorBlock)errorBLock
{
    MKNetworkOperation* op = nil;
    op = [self startOperationWithPath:URL_CUSTOMER_GET_ALL_ORDER needLogin:YES paramers:@{} onSucceeded:^(MKNetworkOperation *completedOperation) {
        if (succeedBlock)
        {
            NSDictionary* d = completedOperation.responseJSON;
            NSArray* nDictArray = [d noNilValueForKey:@"new"];
            NSArray* hDictArray = [d noNilValueForKey:@"history"];
            NSMutableArray* nrArray = [@[] mutableCopy];
            NSMutableArray* hrArray = [@[] mutableCopy];
            for (NSDictionary* dict in nDictArray)
            {
                OrderEntity* o = [[OrderEntity alloc] initWithDict:dict];
                [nrArray addObject:o];
            }
            for (NSDictionary* dict in hDictArray)
            {
                OrderEntity* o = [[OrderEntity alloc] initWithDict:dict];
                [hrArray addObject:o];
            }
            succeedBlock(nrArray, hrArray);
        }
    } onError:^(MKNetworkOperation *completedOperation, NSError *error) {
        if (errorBLock)
        {
            errorBLock(error);
        }
    }];
    return op;
}


- (MKNetworkOperation*)customerGetNearDriver:(CLLocationCoordinate2D)location
                               deltaLatitude:(float)deltaLa
                              deltaLongitude:(float)deltaLo
                                   onSucceed:(ArrayBlock)succeedBlock
                                     onError:(ErrorBlock)errorBlock
{
    MKNetworkOperation* op = nil;
    
    op = [self startOperationWithPath:URL_CUSTOMER_GET_NEAR_DRIVER
                            needLogin:YES
                             paramers:@{
                                        @"latitude":@(location.latitude),
                                        @"longitude":@(location.longitude),
                                        @"delta_latitude":@(deltaLa),
                                        @"delta_longitude":@(deltaLo),
                                        }
                          onSucceeded:^(MKNetworkOperation *completedOperation)
          {
              if (succeedBlock)
              {
                  NSArray* responseArray = completedOperation.responseJSON;
                  NSMutableArray* r = [@[] mutableCopy];
                  for (NSDictionary* dict in responseArray)
                  {
                      DriverInfo* d = [[DriverInfo alloc] initWithDict:dict];
                      [r addObject:d];
                  }
                  succeedBlock(r);
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

- (MKNetworkOperation*)driverGetInfoOnSucceed:(void(^)(DriverInfo* driver))succeedBlock
                                      onError:(ErrorBlock)errorBlock
{
    MKNetworkOperation* op = nil;
    
    op = [self startOperationWithPath:URL_DRIVER_GET_INFO needLogin:YES paramers:@{} onSucceeded:^(MKNetworkOperation *completedOperation) {
        NSDictionary* dict = completedOperation.responseJSON;
        DriverInfo* driverInfo = [[DriverInfo alloc] initWithDict:dict];
        if (succeedBlock)
        {
            succeedBlock(driverInfo);
        }
    } onError:^(MKNetworkOperation *completedOperation, NSError *error) {
        if (errorBlock)
        {
            errorBlock(error);
        }
    }];
    
    return op;
}

@end
