//
//  FBSentinel.h
//  Pods
//
//  Created by 沈强 on 2017/3/1.
//
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FBSentinel : NSObject

@property (readonly) int32_t value;

- (int32_t)increase;

@end

NS_ASSUME_NONNULL_END
