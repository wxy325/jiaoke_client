//
//  UserInfo.h
//  yimo_ios
//
//  Created by wxy325 on 12/26/13.
//  Copyright (c) 2013 Tongji Univ. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DriverInfo;
@class CustomerInfo;

typedef NS_ENUM(NSInteger, UserGender)
{
    UserGenderMale=0,
    UserGenderFemale=1
};
typedef NS_ENUM(NSInteger, UserType)
{
    UserTypeDriver = 0,
    UserTypeCustomer = 1
};

@interface UserInfo : NSObject<NSCoding, NSCopying>

@property (strong, nonatomic) NSString* userName;
@property (strong, nonatomic) NSString* sessionId;
@property (strong, nonatomic) NSString* realName;
@property (assign, nonatomic) UserGender gender;
@property (assign, nonatomic) UserType typeId;

#pragma mark - Info
@property (strong, nonatomic) DriverInfo* driverInfo;
@property (strong, nonatomic) CustomerInfo* customerInfo;

//- (NSDictionary*)toDict;
//- (id)initWithDict:(NSDictionary*)dict;

@end
