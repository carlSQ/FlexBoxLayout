//
//  UIScrollView+FBLayout.m
//  Pods
//
//  Created by 沈强 on 2017/1/20.
//
//

#import "UIScrollView+FBLayout.h"
#import <objc/runtime.h>

@implementation UIScrollView (FBLayout)

+ (void)load {
  SEL originalSelector = @selector(layoutSubviews);
  SEL swizzledSelector = NSSelectorFromString([@"fb_" stringByAppendingString:NSStringFromSelector(originalSelector)]);
  Method originalMethod = class_getInstanceMethod(self, originalSelector);
  Method swizzledMethod = class_getInstanceMethod(self, swizzledSelector);
  method_exchangeImplementations(originalMethod, swizzledMethod);
}

- (FBLayoutDiv *)fb_contentDiv {
  return objc_getAssociatedObject(self, _cmd);
}

- (void)setFb_contentDiv:(FBLayoutDiv *)fb_contentDiv {
  FBLayoutDiv *contentDiv = [self fb_contentDiv];
  if (contentDiv != fb_contentDiv) {
    objc_setAssociatedObject(self, @selector(fb_contentDiv), fb_contentDiv, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
  }
}
 
- (void)fb_clearLayout {
  [self setFb_contentDiv:nil];
}

- (void)fb_layoutSubviews {
  [self fb_layoutSubviews];
  FBLayoutDiv *contentDiv = [self fb_contentDiv];
  if (contentDiv) {
    self.contentSize = (CGSize){
      .width = contentDiv.frame.size.width > self.frame.size.width ? contentDiv.frame.size.width : self.frame.size.width,
      .height = contentDiv.frame.size.height > self.frame.size.height ? contentDiv.frame.size.height: self.frame.size.height,
    };
  }
}

@end
