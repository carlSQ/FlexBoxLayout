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

@implementation UIView (CSSLayout)

- (void)setCSSStyles:(NSDictionary *)CSSStyles {
  [self layout].CSSStyles = CSSStyles;
}

- (NSDictionary *)CSSStyles {
  return [self layout].CSSStyles;
}

- (void)setChildren:(NSArray<id<CSSLayoutProtocol>> *)children {
  
  if ([self children] == children) {
    return;
  }
  objc_setAssociatedObject(self, @selector(children), children, OBJC_ASSOCIATION_COPY_NONATOMIC);
  for (id<CSSLayoutProtocol> layoutElement in children) {
    NSAssert([layoutElement conformsToProtocol:NSProtocolFromString(@"CSSLayoutProtocol")], @"child %@ has no conformsToProtocol CSSLayoutProtocol", self);
    [[self layout] addChild:layoutElement.layout];
  }

}

- (NSArray *)children {
  return objc_getAssociatedObject(self, _cmd);
}


- (void)setDirection:(CSSDirection)direction {
  [[self layout] setDirection:direction];
}

- (void)setFlexDirection:(CSSFlexDirection)flexDirection {
  [[self layout] setFlexDirection:flexDirection];
}

- (void)setJustifyContent:(CSSJustify)justifyContent {
  [[self layout] setJustifyContent:justifyContent];
}

- (void)setAlignContent:(CSSAlign)alignContent {
  [[self layout] setAlignContent:alignContent];
}

- (void)setAlignItems:(CSSAlign)alignItems {
  [[self layout] setAlignItems:alignItems];
}

- (void)setAlignSelf:(CSSAlign)alignSelf {
  [[self layout] setAlignSelf:alignSelf];
}

- (void)setPositionType:(CSSPositionType)positionType {
  [[self layout] setPositionType:positionType];
}

- (void)setFlexWrap:(CSSWrap)flexWrap {
  [[self layout] setFlexWrap:flexWrap];
}

- (void)setFlexGrow:(CGFloat)flexGrow {
  [[self layout] setFlexGrow:flexGrow];
}

- (void)setFlexShrink:(CGFloat)flexShrink {
  [[self layout] setFlexShrink:flexShrink];
}

- (void)setFlexBasis:(CGFloat)flexBasis {
  [[self layout] setFlexBasis:flexBasis];
}

- (void)setPosition:(CGFloat)position forEdge:(CSSEdge)edge {
  [[self layout] setPosition:position forEdge:edge];
}

- (void)setMargin:(CGFloat)margin forEdge:(CSSEdge)edge {
  [[self layout] setMargin:margin forEdge:edge];
}

- (void)setPadding:(CGFloat)padding forEdge:(CSSEdge)edge {
  [[self layout] setPadding:padding forEdge:edge];
}

- (void)setWidth:(CGFloat)width {
  [[self layout] setWidth:width];
}

- (void)setHeight:(CGFloat)height {
  [[self layout] setHeight:height];
}

- (void)setMinWidth:(CGFloat)minWidth {
  [[self layout] setMinWidth:minWidth];
}

- (void)setMinHeight:(CGFloat)minHeight {
  [[self layout] setMinHeight:minHeight];
}

- (void)setMaxWidth:(CGFloat)maxWidth {
  [[self layout] setMaxWidth:maxWidth];
}

- (void)setMaxHeight:(CGFloat)maxHeight {
  [[self layout] setMaxHeight:maxHeight];
}

- (void)setAspectRatio:(CGFloat)aspectRatio {
  [[self layout] setAspectRatio:aspectRatio];
}

- (void)wrapContent {
  YGSetMesure([self layout]);
}


- (CSSLayout *)layout {
  
  CSSLayout *layout = objc_getAssociatedObject(self, _cmd);
  if (!layout) {
    layout = [CSSLayout new];
    layout.context = self;
    objc_setAssociatedObject(self, _cmd, layout, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
  }
  
  return layout;
  
}


#pragma mark - layout

- (void)applyLayouWithSize:(CGRect)frame {
  self.frame = frame;
  [[self layout] calculateLayoutWithSize:frame.size];
  [self applyLayoutToViewHierachy];
}


- (void)asyApplyLayoutWithSize:(CGRect)frame {
  self.frame = frame;
  [CSSAsyLayoutTransaction addCalculateTransaction:^{
    [[self layout] calculateLayoutWithSize:frame.size];
  } complete:^{
    [self applyLayoutToViewHierachy];
  }];
}


- (void)applyLayoutToViewHierachy {
  for (id<CSSLayoutProtocol> layoutElement in [self children]) {
    
    layoutElement.frame = layoutElement.layout.frame;
    
    [layoutElement applyLayoutToViewHierachy];
  }
  
}


@end
