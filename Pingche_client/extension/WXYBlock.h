//
//  block.h
//  yimo_ios
//
//  Created by wxy325 on 12/26/13.
//  Copyright (c) 2013 Tongji Univ. All rights reserved.
//

#ifndef yimo_ios_block_h
#define yimo_ios_block_h

@class NSError;
@class MKNetworkOperation;
@class ActivityShopEntity;

typedef void (^VoidBlock)(void);
typedef void (^ErrorBlock) (NSError* error);
typedef void (^OperationSucceedBlock)(MKNetworkOperation *completedOperation);
typedef void (^OperationErrorBlock)(MKNetworkOperation *completedOperation, NSError *error);
typedef void (^ArrayBlock)(NSArray *resultArray);
typedef void (^ActivityShopBlock)(ActivityShopEntity *result);
#endif
