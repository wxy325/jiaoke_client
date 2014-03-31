//
//  OrderEntity.h
//  Pingche_client
//
//  Created by wxy325 on 3/31/14.
//  Copyright (c) 2014 wxy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
@class DriverInfo;
@class CustomerInfo;

typedef NS_ENUM(NSInteger, OrderState)
{
    OrderStateNew = 0,
    OrderStateUnreceived = 1,
    OrderStateReceived = 2,
    OrderStateArrived = 3
};
typedef NS_ENUM(NSInteger, OrderType)
{
    OrderTypeDache = 1,
    OrderTypePingche = 2
    
};

@interface OrderEntity : NSObject

@property (strong, nonatomic) NSNumber* orderId;
@property (strong, nonatomic) DriverInfo* driver;
@property (strong, nonatomic) CustomerInfo* customer;
@property (assign, nonatomic) int maleNumber;
@property (assign, nonatomic) int femaleNumber;
@property (strong, nonatomic) NSDate* createDate;
@property (assign, nonatomic) OrderType type;
@property (assign, nonatomic) OrderState state;
@property (assign, nonatomic) CLLocationCoordinate2D locationFrom;
@property (assign, nonatomic) CLLocationCoordinate2D locationTo;

- (id)initWithDict:(NSDictionary*)dict;

@end
