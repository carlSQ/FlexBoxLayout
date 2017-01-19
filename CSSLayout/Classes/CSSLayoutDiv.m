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
  
  NSMutableArray *_css_children;
  NSDictionary *_CSSStyles;
  
}

@property(nonatomic, strong) CSSLayout *css_layout;

@end

@implementation CSSLayoutDiv

@dynamic css_children;

- (instancetype)init {
  if (self = [super init]) {
    _css_layout = [CSSLayout new];
    _css_layout.context = self;
  }
  return self;
}

- (void)setCSSStyles:(NSDictionary *)CSSStyles {
  _CSSStyles = CSSStyles;
  _css_layout.CSSStyles = CSSStyles;
}

- (NSDictionary *)CSSStyles {
  return _CSSStyles;
}

+ (instancetype)layoutDivWithFlexDirection:(CSSFlexDirection)direction {
  CSSLayoutDiv *layoutDiv = [self new];
  [layoutDiv css_makeLayout:^(CSSLayout *layout) {
    [layout setFlexDirection:direction];
  }];
  return layoutDiv;
}

+ (instancetype)layoutDivWithFlexDirection:(CSSFlexDirection)direction
                            justifyContent:(CSSJustify)justifyContent
                                alignItems:(CSSAlign)alignItems
                                  children:(NSArray <id<CSSLayoutProtocol>>*)children {
  CSSLayoutDiv *layoutDiv = [self new];
  [layoutDiv css_makeLayout:^(CSSLayout *layout) {
    [layout setFlexDirection:direction];
    [layout setJustifyContent:justifyContent];
    [layout setAlignItems:alignItems];
  }];
  [layoutDiv setCss_children:children];
  return layoutDiv;
}

#pragma mark - children

- (void)setCss_children:(NSArray <id<CSSLayoutProtocol>>*)children {
  if (_css_children == children) {
    return;
  }
  _css_children = [children mutableCopy];
  [_css_layout removeAllChildren];
  for (id<CSSLayoutProtocol> layoutElement in _css_children) {
    NSAssert([layoutElement conformsToProtocol:NSProtocolFromString(@"CSSLayoutProtocol")], @"child %@ has no conformsToProtocol CSSLayoutProtocol", self);
    [_css_layout addChild:layoutElement.css_layout];
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
  return [_css_children copy];
}

- (CGRect)frame {
  return _frame;
}

- (CSSLayout *)css_makeLayout:(void(^)(CSSLayout *layout))layout {
  if (layout) {
    layout([self css_layout]);
  }
  return [self css_layout];
}

#pragma mark - layout

- (void)css_applyLayouWithSize:(CGSize)size {
  [_css_layout calculateLayoutWithSize:size];
  _frame = _css_layout.frame;
  [self css_applyLayoutToViewHierachy];
}


- (void)css_asyApplyLayoutWithSize:(CGSize)size {
  [CSSAsyLayoutTransaction addCalculateTransaction:^{
    [_css_layout calculateLayoutWithSize:size];
  } complete:^{
    _frame = _css_layout.frame;
    [self css_applyLayoutToViewHierachy];
  }];
}


- (void)css_applyLayoutToViewHierachy {
  
  for (id<CSSLayoutProtocol> layoutElement in _css_children) {
    
    layoutElement.frame = (CGRect) {
      .origin = {
        .x = _frame.origin.x + layoutElement.css_layout.frame.origin.x,
        .y = _frame.origin.y + layoutElement.css_layout.frame.origin.y,
      },
      .size = {
        .width = layoutElement.css_layout.frame.size.width,
        .height = layoutElement.css_layout.frame.size.height,
      },
    };
    
    [layoutElement css_applyLayoutToViewHierachy];
  }
  
}

@end
