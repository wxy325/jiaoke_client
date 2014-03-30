//
//  NSDictionary+noNilValueForKey.h
//  yimo_ios
//
//  Created by wxy325 on 12/28/13.
//  Copyright (c) 2013 Tongji Univ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (noNilValueForKey)
- (id)noNilValueForKey:(NSString*)key;
@end
