//
//  WXYNetworkOperation.h
//  yimo_ios
//
//  Created by wxy325 on 12/26/13.
//  Copyright (c) 2013 Tongji Univ. All rights reserved.
//

#import "MKNetworkEngine.h"
#import "WXYError.h"


@interface WXYNetworkOperation : MKNetworkOperation

@property (strong, nonatomic) WXYError* wxyError;

@end
