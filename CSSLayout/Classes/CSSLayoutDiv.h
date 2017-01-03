//
//  CSSLayoutSpec.h
//  CSJSView
//
//  Created by 沈强 on 2016/12/23.
//  Copyright © 2016年 沈强. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CSSLayoutProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface CSSLayoutDiv : NSObject<CSSLayoutProtocol>

@property(nonatomic, assign ) CGRect frame;

+ (instancetype)layoutDivWithFlexDirection:(CSSFlexDirection)direction;

+ (instancetype)layoutDivWithFlexDirection:(CSSFlexDirection)direction
                            justifyContent:(CSSJustify)justifyContent
                                alignItems:(CSSAlign)alignItems
                                  children:(NSArray<id<CSSLayoutProtocol>>*)children;

- (void)applyLayouWithSize:(CGRect)frame;

- (void)asyApplyLayoutWithSize:(CGRect)frame;

@end

NS_ASSUME_NONNULL_END
