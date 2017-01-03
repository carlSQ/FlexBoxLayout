//
//  CSSLayoutSpec.m
//  CSJSView
//
//  Created by 沈强 on 2016/12/23.
//  Copyright © 2016年 沈强. All rights reserved.
//

#import "CSSLayoutDiv.h"
#import "CSSAsyLayoutTransaction.h"

@interface CSSLayoutDiv(){
  
  NSMutableArray *_children;
  NSDictionary *_CSSStyles;
  
}

@property(nonatomic, strong) CSSLayout *layout;

@end

@implementation CSSLayoutDiv

@dynamic children;


- (instancetype)init {
  if (self = [super init]) {
    _layout = [CSSLayout new];
    _layout.context = self;
  }
  return self;
}

- (void)setCSSStyles:(NSDictionary *)CSSStyles {
  _CSSStyles = CSSStyles;
  _layout.CSSStyles = CSSStyles;
}

- (NSDictionary *)CSSStyles {
  return _CSSStyles;
}

+ (instancetype)layoutDivWithFlexDirection:(CSSFlexDirection)direction {
  CSSLayoutDiv *layoutDiv = [self new];
  [layoutDiv setFlexDirection:direction];
  return layoutDiv;
}

+ (instancetype)layoutDivWithFlexDirection:(CSSFlexDirection)direction
                            justifyContent:(CSSJustify)justifyContent
                                alignItems:(CSSAlign)alignItems
                                  children:(NSArray <id<CSSLayoutProtocol>>*)children {
  CSSLayoutDiv *layoutDiv = [self new];
  [layoutDiv setFlexDirection:direction];
  [layoutDiv setJustifyContent:justifyContent];
  [layoutDiv setAlignItems:alignItems];
  [layoutDiv setChildren:children];
  return layoutDiv;
}

- (void)setChildren:(NSArray <id<CSSLayoutProtocol>>*)children {
  if (_children == children) {
    return;
  }
  _children = [children mutableCopy];
  for (id<CSSLayoutProtocol> layoutElement in _children) {
    NSAssert([layoutElement conformsToProtocol:NSProtocolFromString(@"CSSLayoutProtocol")], @"child %@ has no conformsToProtocol CSSLayoutProtocol", self);
    [_layout addChild:layoutElement.layout];
  }
}

- (NSArray *)children {
  return [_children copy];
}

- (CGRect)frame {
  return _frame;
}
#pragma mark - layout

- (void)applyLayouWithSize:(CGRect)frame {
  _frame = frame;
  [_layout calculateLayoutWithSize:frame.size];
  [self applyLayoutToViewHierachy];
}


- (void)asyApplyLayoutWithSize:(CGRect)frame {
  _frame = frame;
  [CSSAsyLayoutTransaction addCalculateTransaction:^{
     [_layout calculateLayoutWithSize:frame.size];
  } complete:^{
    [self applyLayoutToViewHierachy];
  }];
}


- (void)applyLayoutToViewHierachy {
  
  for (id<CSSLayoutProtocol> layoutElement in _children) {
    
    layoutElement.frame = (CGRect) {
      .origin = {
        .x = _frame.origin.x + layoutElement.layout.frame.origin.x,
        .y = _frame.origin.y + layoutElement.layout.frame.origin.y,
      },
      .size = {
        .width = layoutElement.layout.frame.size.width,
        .height = layoutElement.layout.frame.size.height,
      },
    };
    
    [layoutElement applyLayoutToViewHierachy];
  }
  
}

#pragma mark - CSSStyle

- (void)setDirection:(CSSDirection)direction {
  [_layout setDirection:direction];
}

- (void)setFlexDirection:(CSSFlexDirection)flexDirection {
  [_layout setFlexDirection:flexDirection];
}

- (void)setJustifyContent:(CSSJustify)justifyContent {
  [_layout setJustifyContent:justifyContent];
}

- (void)setAlignContent:(CSSAlign)alignContent {
  [_layout setAlignContent:alignContent];
}

- (void)setAlignItems:(CSSAlign)alignItems {
  [_layout setAlignItems:alignItems];
}

- (void)setAlignSelf:(CSSAlign)alignSelf {
  [_layout setAlignSelf:alignSelf];
}

- (void)setPositionType:(CSSPositionType)positionType {
  [_layout setPositionType:positionType];
}

- (void)setFlexWrap:(CSSWrap)flexWrap {
  [_layout setFlexWrap:flexWrap];
}

- (void)setFlexGrow:(CGFloat)flexGrow {
  [_layout setFlexGrow:flexGrow];
}

- (void)setFlexShrink:(CGFloat)flexShrink {
  [_layout setFlexShrink:flexShrink];
}

- (void)setFlexBasis:(CGFloat)flexBasis {
  [_layout setFlexBasis:flexBasis];
}

- (void)setPosition:(CGFloat)position forEdge:(CSSEdge)edge {
  [_layout setPosition:position forEdge:edge];
}

- (void)setMargin:(CGFloat)margin forEdge:(CSSEdge)edge {
  [_layout setMargin:margin forEdge:edge];
}

- (void)setPadding:(CGFloat)padding forEdge:(CSSEdge)edge {
  [_layout setPadding:padding forEdge:edge];
}

- (void)setWidth:(CGFloat)width {
  [_layout setWidth:width];
}

- (void)setHeight:(CGFloat)height {
  [_layout setHeight:height];
}

- (void)setMinWidth:(CGFloat)minWidth {
  [_layout setMinWidth:minWidth];
}

- (void)setMinHeight:(CGFloat)minHeight {
  [_layout setMinHeight:minHeight];
}

- (void)setMaxWidth:(CGFloat)maxWidth {
  [_layout setMaxWidth:maxWidth];
}

- (void)setMaxHeight:(CGFloat)maxHeight {
  [_layout setMaxHeight:maxHeight];
}

- (void)setAspectRatio:(CGFloat)aspectRatio {
  [[self layout] setAspectRatio:aspectRatio];
}


@end
