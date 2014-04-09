//
//  DriverInfo.m
//  Pingche_client
//
//  Created by wxy325 on 3/30/14.
//  Copyright (c) 2014 wxy. All rights reserved.
//

#import "DriverInfo.h"
#import "NSDictionary+noNilValueForKey.h"

@implementation DriverInfo
- (NSMutableArray*)orderArray
{
    if (!_orderArray)
    {
        _orderArray = [@[] mutableCopy];
    }
    return _orderArray;
}

- (id)initWithDict:(NSDictionary*)dict
{
    self = [super init];
    if (self)
    {
        self.driverId = dict[@"driver_id"];
        self.carNumber = dict[@"car_number"];
        self.state = ((NSNumber*)dict[@"state"]).intValue;
        self.realName = dict[@"real_name"];
        self.company = [dict noNilValueForKey:@"company"];
        self.tel = dict[@"tel"];
        
        NSDictionary* locationDict = [dict noNilValueForKey:@"location_info"];
        if (locationDict)
        {
            self.fHaveLocaitonInfo = YES;
            CLLocationCoordinate2D l;
            l.latitude = ((NSNumber*)locationDict[@"latitude"]).floatValue;
            l.longitude = ((NSNumber*)locationDict[@"longitude"]).floatValue;
            self.location = l;
        }
        else
        {
            self.fHaveLocaitonInfo = NO;
        }
        
        NSString* route = [dict noNilValueForKey:@"route_info"];
        if (route && route.length)
        {
            NSMutableArray* rArray = [@[] mutableCopy];
            NSArray* locationStrArray = [route componentsSeparatedByString:@"|"];
            for (NSString* lStr in locationStrArray)
            {
                NSArray* com = [lStr componentsSeparatedByString:@","];
                //latitude lo
                CLLocationCoordinate2D l;
                l.latitude = ((NSString*)com[0]).floatValue;
                l.longitude = ((NSString*)com[1]).floatValue;
                DriverLocationInfo* lo = [[DriverLocationInfo alloc] init];
                lo.location = l;
                [rArray addObject:lo];
            }
            self.route = rArray;
        }
    }
    return self;
}


@end
