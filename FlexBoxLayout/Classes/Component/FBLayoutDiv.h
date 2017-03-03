//
//  FBLayoutSpec.h
//  CSJSView
//
//  Created by 沈强 on 2016/12/23.
//  Copyright © 2016年 沈强. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FBLayoutProtocol.h"

NS_ASSUME_NONNULL_BEGIN


/**
 FBLayoutDiv is virtual view, split view to a different area, avoid too much view.
 */

@interface FBLayoutDiv : NSObject<FBLayoutProtocol>

@property(nonatomic)CGRect frame;


+ (instancetype)layoutDivWithFlexDirection:(FBFlexDirection)direction;

+ (instancetype)layoutDivWithFlexDirection:(FBFlexDirection)direction
                            justifyContent:(FBJustify)justifyContent
                                alignItems:(FBAlign)alignItems
                                  children:(NSArray<id<FBLayoutProtocol>>*)children;


@end

NS_ASSUME_NONNULL_END
