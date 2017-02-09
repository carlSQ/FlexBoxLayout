//
//  UIScrollView+FBLayout.h
//  Pods
//
//  Created by 沈强 on 2017/1/20.
//
//

#import <UIKit/UIKit.h>
#import "FBLayoutDiv.h"

@interface UIScrollView (FBLayout)


/**
 ScrollView layout div make contentSize  auto size
 */
@property(nonatomic, strong) FBLayoutDiv *fb_contentDiv;


/**
 remove layout
 */
- (void)fb_clearLayout;

@end
