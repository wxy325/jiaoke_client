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
