//
//  UserInfo.m
//  yimo_ios
//
//  Created by wxy325 on 12/26/13.
//  Copyright (c) 2013 Tongji Univ. All rights reserved.
//

#import "UserInfo.h"

@implementation UserInfo

#pragma mark -
#pragma mark NSCoding
- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.userName forKey:@"userName"];
    [encoder encodeObject:self.sessionId forKey:@"sessionId"];

}
- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super init];
    if (self)
    {
        //必须与上面的encode顺序相同
        self.userName = [decoder decodeObjectForKey:@"userName"];
        self.sessionId = [decoder decodeObjectForKey:@"sessionid"];
        
    }
    return self;
}
#pragma mark -
#pragma mark NSCopy
- (id)copyWithZone:(NSZone *)zone
{
    UserInfo* copy = [[[self class] allocWithZone:zone] init];
    copy.userName = [self.userName copyWithZone:zone];
    copy.sessionId = [self.sessionId copyWithZone:zone];
    
    return copy;
}

/*
#pragma mark - Dict
- (NSDictionary*)toDict
{
    NSDictionary* dict = @{@"userName":self.userName, @"sessionId":self.sessionId};
    return dict;
}
- (id)initWithDict:(NSDictionary*)dict
{
    self = [super init];
    if (self)
    {
        self.userName = dict[@"userName"];
        self.sessionId = dict[@"sessionId"];
    }
    return self;
}
 */
@end
