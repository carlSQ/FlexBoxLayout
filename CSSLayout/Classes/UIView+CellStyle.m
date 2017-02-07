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

- (void)setFb_selectionStyle:(UITableViewCellSelectionStyle)fb_selectionStyle {
  objc_setAssociatedObject(self, _cmd, @(fb_selectionStyle), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UITableViewCellSelectionStyle)fb_selectionStyle {
  return [objc_getAssociatedObject(self, @selector(setFb_selectionStyle:)) integerValue];;
}

@end
