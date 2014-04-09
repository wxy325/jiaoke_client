//
//  DriverInfo.h
//  Pingche_client
//
//  Created by wxy325 on 3/30/14.
//  Copyright (c) 2014 wxy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "DriverLocationInfo.h"
typedef NS_ENUM(NSInteger, DriverState) {
    DriverStateOff = 0,
    DriverStateDache = 1,
    DriverStatePingche = 2
};

@interface DriverInfo : NSObject

@property (strong, nonatomic) NSNumber* driverId;
@property (strong, nonatomic) NSString* carNumber;
@property (assign, nonatomic) DriverState state;
@property (strong, nonatomic) NSString* realName;
@property (strong, nonatomic) NSString* company;
@property (strong, nonatomic) NSString* tel;

@property (assign, nonatomic) BOOL fHaveLocaitonInfo;
@property (assign, nonatomic) CLLocationCoordinate2D location;

@property (strong, nonatomic) NSMutableArray* orderArray;

@property (strong, nonatomic) NSArray* route;

- (id)initWithDict:(NSDictionary*)dict;

@end
