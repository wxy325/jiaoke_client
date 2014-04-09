//
//  OrderEntity.m
//  Pingche_client
//
//  Created by wxy325 on 3/31/14.
//  Copyright (c) 2014 wxy. All rights reserved.
//

#import "OrderEntity.h"
#import "DriverInfo.h"
#import "CustomerInfo.h"
#import "NSDictionary+noNilValueForKey.h"


@implementation OrderEntity

- (id)initWithDict:(NSDictionary*)dict
{
    self = [super init];
    if (self)
    {
        self.orderId = dict[@"id"];
        self.maleNumber = ((NSNumber*) dict[@"male_number"]).intValue;
        self.femaleNumber = ((NSNumber*) dict[@"female_number"]).intValue;
        self.createDate = dict[@"create_date"];
        self.state = ((NSNumber*) dict[@"state"]).intValue;
        self.type = ((NSNumber*) dict[@"type"]).intValue;
        
        float lo = ((NSNumber*) dict[@"from_longitude"]).floatValue;
        float la = ((NSNumber*) dict[@"from_latitude"]).floatValue;
        CLLocationCoordinate2D lFrom;
        lFrom.longitude = lo;
        lFrom.latitude = la;
        self.locationFrom = lFrom;
        
        CLLocationCoordinate2D lTo;
        lo = ((NSNumber*) dict[@"destination_longitude"]).floatValue;
        la = ((NSNumber*) dict[@"destination_latitude"]).floatValue;
        lTo.longitude = lo;
        lTo.latitude = la;
        self.locationTo = lTo;
        
        self.fromDesc = dict[@"from_desc"];
        self.toDesc = dict[@"to_desc"];
        
        NSDictionary* driverDict = dict[@"driver"];
        DriverInfo* dr = [[DriverInfo alloc] initWithDict:driverDict];
        self.driver = dr;
        
        NSDictionary* customerDict = dict[@"customer"];
        CustomerInfo* cu = [[CustomerInfo alloc] initWithDict:customerDict];
        self.customer = cu;
    }
    return self;
}

@end
