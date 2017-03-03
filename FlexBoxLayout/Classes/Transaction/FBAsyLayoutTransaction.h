//
//  FBAsyLayoutTransaction.h
//  CSJSView
//
//  Created by 沈强 on 2016/8/31.
//  Copyright © 2016年 沈强. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@interface FBAsyLayoutTransaction : NSObject

/**
 asy calculate transaction
 @param transaction transaction task
 @param complete task complete
 */
+ (void)addCalculateTransaction:(dispatch_block_t)transaction
                       complete:(nullable dispatch_block_t)complete;

+ (void)addDisplayTransaction:(dispatch_block_t)transaction
                     complete:(dispatch_block_t)complete;

@end
NS_ASSUME_NONNULL_END
