//
//  UIView+CellStyle.m
//  Pods
//
//  Created by 沈强 on 2017/1/12.
//
//

#import "UIView+CellStyle.h"
#import <objc/runtime.h>

@implementation UIView (CellStyle)

- (void)setCss_selectionStyle:(UITableViewCellSelectionStyle)css_selectionStyle {
  objc_setAssociatedObject(self, _cmd, @(css_selectionStyle), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UITableViewCellSelectionStyle)css_selectionStyle {
  return [objc_getAssociatedObject(self, @selector(setCss_selectionStyle)) integerValue];;
}

@end
