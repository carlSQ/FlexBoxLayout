//
//  UIView+CSJSLayout.h
//  CSJSView
//
//  Created by 沈强 on 16/8/31.
//  Copyright © 2016年 沈强. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FBLayout.h"
#import "FBLayoutProtocol.h"

@interface UIView (FBLayout)<FBLayoutProtocol>

@property(nonatomic) BOOL fb_drawsAsynchronously;


/**
  fit view size to content size
 */
- (void)fb_wrapContent;



/**
 set view layout properties

 @param direction
 @param justifyContent
 @param alignItems
 @param children
 */
- (void)fb_setFlexDirection:(FBFlexDirection)direction
             justifyContent:(FBJustify)justifyContent
                 alignItems:(FBAlign)alignItems
                   children:(NSArray<id<FBLayoutProtocol>>*)children;

@end
