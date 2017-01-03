//
//  CSSAsyLayoutTransaction.h
//  CSJSView
//
//  Created by 沈强 on 2016/8/31.
//  Copyright © 2016年 沈强. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@interface CSSAsyLayoutTransaction : NSObject

+ (void)addCalculateTransaction:(dispatch_block_t)transaction
                       complete:(dispatch_block_t)complete;

@end
NS_ASSUME_NONNULL_END
