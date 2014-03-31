//
//  WXYNetworoEngine.h
//  yimo_ios
//
//  Created by wxy325 on 12/26/13.
//  Copyright (c) 2013 Tongji Univ. All rights reserved.
//

#import "MKNetworkEngine.h"
#import "WXYBlock.h"
#import "WXYDataModel.h"
#import <CoreLocation/CoreLocation.h>

#define SHARE_NW_ENGINE [WXYNetworkEngine shareNetworkEngine]
typedef NS_ENUM(NSInteger, GetOrderType)
{
    GetOrderTypeNew = 0,
    GetOrderTypeAll = 1,
    GetOrderTypeHistory = 2
};


@interface WXYNetworkEngine : MKNetworkEngine

+ (WXYNetworkEngine*)shareNetworkEngine;

#pragma mark - User
- (MKNetworkOperation*)userLogin:(NSString* )userName
                        password:(NSString*)passwd
                       onSucceed:(VoidBlock)succeedBlock
                         onError:(ErrorBlock)errorBlock;

#pragma mark - Customer
- (MKNetworkOperation*)customerSearchDriver:(CLLocationCoordinate2D)from
                                         to:(CLLocationCoordinate2D)to
                                       type:(OrderType)type
                                     reject:(NSArray*)rejectedDriverIdArray
                                  onSucceed:(void(^)(DriverInfo* driver))succeedBlock
                                    onError:(ErrorBlock)errorBlock;

- (MKNetworkOperation*)customerCreateOrder:(NSNumber*)driverId
                                      type:(OrderType)type
                                maleNumber:(NSNumber*)maleNumber
                              femaleNumber:(NSNumber*)femaleNumber
                                      from:(CLLocationCoordinate2D)from
                                        to:(CLLocationCoordinate2D)to
                                 onSucceed:(void(^)(OrderEntity* order))succeedBlock
                                   onError:(ErrorBlock)errorBlock;

- (MKNetworkOperation*)customerGetOrderOnSucceed:(void(^)(OrderEntity* order))succeedBlock
                                         onError:(ErrorBlock)errorBlock;

- (MKNetworkOperation*)customerGetNearDriver:(CLLocationCoordinate2D)location
                               deltaLatitude:(float)deltaLa
                              deltaLongitude:(float)deltaLo
                                   onSucceed:(ArrayBlock)succeedBlock
                                     onError:(ErrorBlock)errorBlock;


#pragma mark - Driver
- (MKNetworkOperation*)driverUpdateLocation:(CLLocationCoordinate2D)location
                                  onSucceed:(VoidBlock)succeedBlock
                                    onError:(ErrorBlock)errorBlock;

- (MKNetworkOperation*)driverGetOrderState:(GetOrderType)type
                                 onSucceed:(ArrayBlock)succeedBlock
                                   onError:(ErrorBlock)errorBlock;
- (MKNetworkOperation*)driverUpdateOrderOrderId:(NSNumber*)orderId
                                          state:(OrderState)state
                                      onSucceed:(VoidBlock)succeedBlock
                                        onError:(ErrorBlock)errorBlock;
@end
