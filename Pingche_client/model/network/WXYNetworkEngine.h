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
@end
