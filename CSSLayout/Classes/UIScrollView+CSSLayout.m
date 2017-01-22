//
//  UIScrollView+CSSLayout.m
//  Pods
//
//  Created by 沈强 on 2017/1/20.
//
//

#import "UIScrollView+CSSLayout.h"
#import <objc/runtime.h>

@implementation UIScrollView (CSSLayout)

+ (void)load {
  SEL originalSelector = @selector(layoutSubviews);
  SEL swizzledSelector = NSSelectorFromString([@"css_" stringByAppendingString:NSStringFromSelector(originalSelector)]);
  Method originalMethod = class_getInstanceMethod(self, originalSelector);
  Method swizzledMethod = class_getInstanceMethod(self, swizzledSelector);
  method_exchangeImplementations(originalMethod, swizzledMethod);
}

- (CSSLayoutDiv *)css_contentDiv {
  return objc_getAssociatedObject(self, _cmd);
}

- (void)setCss_contentDiv:(CSSLayoutDiv *)css_contentDiv {
  CSSLayoutDiv *contentDiv = [self css_contentDiv];
  if (contentDiv != css_contentDiv) {
    objc_setAssociatedObject(self, @selector(css_contentDiv), css_contentDiv, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
  }
}
 
- (void)clearLayout {
  [self setCss_contentDiv:nil];
}

- (void)css_layoutSubviews {
  [self css_layoutSubviews];
  CSSLayoutDiv *contentDiv = [self css_contentDiv];
  if (contentDiv) {
    self.contentSize = contentDiv.frame.size;
  }
}

@end
