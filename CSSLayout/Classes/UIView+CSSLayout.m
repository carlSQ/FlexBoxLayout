//
//  UIView+CSJSLayout.m
//  CSJSView
//
//  Created by 沈强 on 16/8/31.
//  Copyright © 2016年 沈强. All rights reserved.
//

#import "UIView+CSSLayout.h"
#import <objc/runtime.h>
#import "CSSAsyLayoutTransaction.h"

extern void YGSetMesure(CSSLayout *layout);

const CGSize css_undefinedSize = {
  .width = YGUndefined,
  .height = YGUndefined,
};

const CGFloat css_undefined = YGUndefined;

@implementation UIView (CSSLayout)

- (void)setCSSStyles:(NSDictionary *)CSSStyles {
  [self css_layout].CSSStyles = CSSStyles;
}

- (NSDictionary *)CSSStyles {
  return [self css_layout].CSSStyles;
}

- (void)setCss_children:(NSArray<id<CSSLayoutProtocol>> *)children {
  
  if ([self css_children] == children) {
    return;
  }
  
  objc_setAssociatedObject(self, @selector(css_children), children, OBJC_ASSOCIATION_COPY_NONATOMIC);
  
  [[self css_layout] removeAllChildren];
  
  for (id<CSSLayoutProtocol> layoutElement in children) {
    NSAssert([layoutElement conformsToProtocol:NSProtocolFromString(@"CSSLayoutProtocol")], @"child %@ has no conformsToProtocol CSSLayoutProtocol", self);
    [[self css_layout] addChild:layoutElement.css_layout];
  }

}

- (void)css_addChild:(id<CSSLayoutProtocol>)layout {
  NSAssert([layout conformsToProtocol:NSProtocolFromString(@"CSSLayoutProtocol")], @"child %@ has no conformsToProtocol CSSLayoutProtocol", self);
  NSMutableArray *newChildren = [[self css_children] mutableCopy];
  [newChildren addObject:layout];
  self.css_children = newChildren;
}

- (void)css_addChildren:(NSArray<id<CSSLayoutProtocol>> *)children {
  NSAssert([children conformsToProtocol:NSProtocolFromString(@"CSSLayoutProtocol")], @"child %@ has no conformsToProtocol CSSLayoutProtocol", self);
  NSMutableArray *newChildren = [[self css_children] mutableCopy];
  [newChildren addObjectsFromArray:children];
  self.css_children = newChildren;
}

- (void)css_insertChild:(id<CSSLayoutProtocol>)layout atIndex:(NSInteger)index {
  NSAssert([layout conformsToProtocol:NSProtocolFromString(@"CSSLayoutProtocol")], @"child %@ has no conformsToProtocol CSSLayoutProtocol", self);
  NSMutableArray *newChildren = [[self css_children] mutableCopy];
  [newChildren insertObject:layout atIndex:index];
  self.css_children = newChildren;
}

- (id<CSSLayoutProtocol>)css_childLayoutAtIndex:(NSUInteger)index {
  return [self.css_children objectAtIndex:index];
}

- (void)css_removeChild:(id<CSSLayoutProtocol>)layout {
  NSMutableArray *newChildren = [[self css_children] mutableCopy];
  [newChildren removeObject:layout];
  self.css_children = newChildren;
}

- (void)css_removeAllChildren {
  self.css_children = nil;
}

- (NSArray *)css_children {
  return objc_getAssociatedObject(self, _cmd);
}

- (void)css_setDirection:(CSSDirection)direction {
  [[self css_layout] setDirection:direction];
}

- (void)css_setFlexDirection:(CSSFlexDirection)flexDirection {
  [[self css_layout] setFlexDirection:flexDirection];
}

- (void)css_setJustifyContent:(CSSJustify)justifyContent {
  [[self css_layout] setJustifyContent:justifyContent];
}

- (void)css_setAlignContent:(CSSAlign)alignContent {
  [[self css_layout] setAlignContent:alignContent];
}

- (void)css_setAlignItems:(CSSAlign)alignItems {
  [[self css_layout] setAlignItems:alignItems];
}

- (void)css_setAlignSelf:(CSSAlign)alignSelf {
  [[self css_layout] setAlignSelf:alignSelf];
}

- (void)css_setPositionType:(CSSPositionType)positionType {
  [[self css_layout] setPositionType:positionType];
}

- (void)css_setFlexWrap:(CSSWrap)flexWrap {
  [[self css_layout] setFlexWrap:flexWrap];
}

- (void)css_setFlexGrow:(CGFloat)flexGrow {
  [[self css_layout] setFlexGrow:flexGrow];
}

- (void)css_setFlexShrink:(CGFloat)flexShrink {
  [[self css_layout] setFlexShrink:flexShrink];
}

- (void)css_setFlexBasis:(CGFloat)flexBasis {
  [[self css_layout] setFlexBasis:flexBasis];
}

- (void)css_setPosition:(CGFloat)position forEdge:(CSSEdge)edge {
  [[self css_layout] setPosition:position forEdge:edge];
}

- (void)css_setMargin:(CGFloat)margin forEdge:(CSSEdge)edge {
  [[self css_layout] setMargin:margin forEdge:edge];
}

- (void)css_setPadding:(CGFloat)padding forEdge:(CSSEdge)edge {
  [[self css_layout] setPadding:padding forEdge:edge];
}

- (void)css_setWidth:(CGFloat)width {
  [[self css_layout] setWidth:width];
}

- (void)css_setHeight:(CGFloat)height {
  [[self css_layout] setHeight:height];
}

- (void)css_setSize:(CGSize)size {
  [[self css_layout] setSize:size];
}

- (void)css_setMinWidth:(CGFloat)minWidth {
  [[self css_layout] setMinWidth:minWidth];
}

- (void)css_setMinHeight:(CGFloat)minHeight {
  [[self css_layout] setMinHeight:minHeight];
}

- (void)css_setMinSize:(CGSize)minSize {
  [[self css_layout] setMinSize:minSize];
}

- (void)css_setMaxWidth:(CGFloat)maxWidth {
  [[self css_layout] setMaxWidth:maxWidth];
}

- (void)css_setMaxHeight:(CGFloat)maxHeight {
  [[self css_layout] setMaxHeight:maxHeight];
}

- (void)css_setMaxSize:(CGSize)maxSize {
  [[self css_layout] setMaxSize:maxSize];
}


- (void)css_setAspectRatio:(CGFloat)aspectRatio {
  [[self css_layout] setAspectRatio:aspectRatio];
}

- (void)css_setFlexDirection:(CSSFlexDirection)direction
              justifyContent:(CSSJustify)justifyContent
                  alignItems:(CSSAlign)alignItems
                    children:(NSArray<id<CSSLayoutProtocol>>*)children {
  
  [self css_setFlexDirection:direction];
  [self css_setJustifyContent:justifyContent];
  [self css_setAlignItems:alignItems];
  [self setCss_children:children];
  
}

- (void)css_wrapContent {
  YGSetMesure([self css_layout]);
}


- (CSSLayout *)css_layout {
  
  CSSLayout *layout = objc_getAssociatedObject(self, _cmd);
  if (!layout) {
    layout = [CSSLayout new];
    layout.context = self;
    objc_setAssociatedObject(self, _cmd, layout, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
  }
  
  return layout;
  
}


#pragma mark - layout

- (void)css_applyLayouWithSize:(CGSize)size {
  [[self css_layout] calculateLayoutWithSize:size];
  self.frame = [self css_layout].frame;
  [self css_applyLayoutToViewHierachy];
}


- (void)css_asyApplyLayoutWithSize:(CGSize)size {
  [CSSAsyLayoutTransaction addCalculateTransaction:^{
    [[self css_layout] calculateLayoutWithSize:size];
  } complete:^{
     self.frame = [self css_layout].frame;
    [self css_applyLayoutToViewHierachy];

  }];
}


- (void)css_applyLayoutToViewHierachy {
  for (id<CSSLayoutProtocol> layoutElement in [self css_children]) {
    
    layoutElement.frame = layoutElement.css_layout.frame;
    
    [layoutElement css_applyLayoutToViewHierachy];
  }
  
}


@end
