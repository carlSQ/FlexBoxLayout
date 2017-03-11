//
//  FBLayoutSpec.m
//  CSJSView
//
//  Created by 沈强 on 2016/12/23.
//  Copyright © 2016年 沈强. All rights reserved.
//

#import "FBLayoutDiv.h"
#import "FBAsyLayoutTransaction.h"

@interface FBLayoutDiv(){
  
  NSMutableArray *_fb_children;
  NSDictionary *_fbStyles;
  
}

@property(nonatomic, strong) FBLayout *fb_layout;

@end

@implementation FBLayoutDiv

@dynamic fb_children;

- (instancetype)init {
  if (self = [super init]) {
    _fb_layout = [FBLayout new];
    _fb_layout.context = self;
    _fb_children = [NSMutableArray array];
  }
  return self;
}

- (void)setFbStyles:(NSDictionary *)fbStyles {
  _fbStyles = fbStyles;
  _fb_layout.fbStyles = fbStyles;
}

- (NSDictionary *)fbStyles {
  return _fbStyles;
}

+ (instancetype)layoutDivWithFlexDirection:(FBFlexDirection)direction {
  FBLayoutDiv *layoutDiv = [self new];
  [layoutDiv fb_makeLayout:^(FBLayout *layout) {
    [layout setFlexDirection:direction];
  }];
  return layoutDiv;
}

+ (instancetype)layoutDivWithFlexDirection:(FBFlexDirection)direction
                            justifyContent:(FBJustify)justifyContent
                                alignItems:(FBAlign)alignItems
                                  children:(NSArray <id<FBLayoutProtocol>>*)children {
  FBLayoutDiv *layoutDiv = [self new];
  [layoutDiv fb_makeLayout:^(FBLayout *layout) {
    [layout setFlexDirection:direction];
    [layout setJustifyContent:justifyContent];
    [layout setAlignItems:alignItems];
  }];
  [layoutDiv setFb_children:children];
  return layoutDiv;
}

#pragma mark - children

- (void)setFb_children:(NSArray <id<FBLayoutProtocol>>*)children {
  if (_fb_children == children) {
    return;
  }
  _fb_children = [children mutableCopy];
  [_fb_layout removeAllChildren];
  for (id<FBLayoutProtocol> layoutElement in _fb_children) {
    NSAssert([layoutElement conformsToProtocol:NSProtocolFromString(@"FBLayoutProtocol")], @"child %@ has no conformsToProtocol FBLayoutProtocol", self);
    [_fb_layout addChild:layoutElement.fb_layout];
  }
}

- (void)fb_addChild:(id<FBLayoutProtocol>)layout {
  NSAssert([layout conformsToProtocol:NSProtocolFromString(@"FBLayoutProtocol")], @"child %@ has no conformsToProtocol FBLayoutProtocol", self);
  NSMutableArray *newChildren = [[self fb_children] mutableCopy];
  [newChildren addObject:layout];
  self.fb_children = newChildren;
}

- (void)fb_addChildren:(NSArray<id<FBLayoutProtocol>> *)children {
  NSMutableArray *newChildren = [[self fb_children] mutableCopy];
  [newChildren addObjectsFromArray:children];
  self.fb_children = newChildren;
}

- (void)fb_insertChild:(id<FBLayoutProtocol>)layout atIndex:(NSInteger)index {
  NSAssert([layout conformsToProtocol:NSProtocolFromString(@"FBLayoutProtocol")], @"child %@ has no conformsToProtocol FBLayoutProtocol", self);
  NSMutableArray *newChildren = [[self fb_children] mutableCopy];
  [newChildren insertObject:layout atIndex:index];
  self.fb_children = newChildren;
}

- (id<FBLayoutProtocol>)fb_childLayoutAtIndex:(NSUInteger)index {
  return [self.fb_children objectAtIndex:index];
}

- (void)fb_removeChild:(id<FBLayoutProtocol>)layout {
  NSMutableArray *newChildren = [[self fb_children] mutableCopy];
  [newChildren removeObject:layout];
  self.fb_children = newChildren;
}

- (void)fb_removeAllChildren {
  self.fb_children = nil;
}

- (NSArray *)fb_children {
  return [_fb_children copy];
}

- (CGRect)frame {
  return _frame;
}

- (FBLayout *)fb_makeLayout:(void(^)(FBLayout *layout))layout {
  if (layout) {
    layout([self fb_layout]);
  }
  return [self fb_layout];
}

#pragma mark - layout

- (void)fb_applyLayouWithSize:(CGSize)size {
  [_fb_layout calculateLayoutWithSize:size];
  _frame = _fb_layout.frame;
  [self fb_applyLayoutToViewHierachy];
}


- (void)fb_asyApplyLayoutWithSize:(CGSize)size {
  [FBAsyLayoutTransaction addCalculateTransaction:^{

    [_fb_layout calculateLayoutWithSize:size];
  } complete:^{
    _frame = _fb_layout.frame;
    [self fb_applyLayoutToViewHierachy];
  }];
}


- (void)fb_applyLayoutToViewHierachy {
  
  for (id<FBLayoutProtocol> layoutElement in _fb_children) {
    
    layoutElement.frame = (CGRect) {
      .origin = {
        .x = _frame.origin.x + layoutElement.fb_layout.frame.origin.x,
        .y = _frame.origin.y + layoutElement.fb_layout.frame.origin.y,
      },
      .size = {
        .width = layoutElement.fb_layout.frame.size.width,
        .height = layoutElement.fb_layout.frame.size.height,
      },
    };
    
    [layoutElement fb_applyLayoutToViewHierachy];
  }
  
}

@end
