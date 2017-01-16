//
//  UIView+CSJSLayout.h
//  CSJSView
//
//  Created by 沈强 on 16/8/31.
//  Copyright © 2016年 沈强. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSSLayout.h"
#import "CSSLayoutProtocol.h"

@interface UIView (CSSLayout)<CSSLayoutProtocol>

- (void)css_wrapContent;

- (void)css_setFlexDirection:(CSSFlexDirection)direction
              justifyContent:(CSSJustify)justifyContent
                  alignItems:(CSSAlign)alignItems
                    children:(NSArray<id<CSSLayoutProtocol>>*)children;

@end
