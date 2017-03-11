//
//  UIView+CSJSLayout.m
//  CSJSView
//
//  Created by 沈强 on 16/8/31.
//  Copyright © 2016年 沈强. All rights reserved.
//

#import "UIView+FBLayout.h"
#import <objc/runtime.h>
#import "FBAsyLayoutTransaction.h"

extern void YGSetMesure(FBLayout *layout);

const CGSize fb_undefinedSize = {
  .width = YGUndefined,
  .height = YGUndefined,
};

const CGFloat fb_undefined = YGUndefined;

@implementation UIView (FBLayout)

- (void)setFbStyles:(NSDictionary *)fbStyles {
  [self fb_layout].fbStyles = fbStyles;
}

- (NSDictionary *)fbStyles {
  return [self fb_layout].fbStyles;
}

- (void)setFb_children:(NSArray<id<FBLayoutProtocol>> *)children {
  
  if ([self fb_children] == children) {
    return;
  }
  
  objc_setAssociatedObject(self, @selector(fb_children), children, OBJC_ASSOCIATION_COPY_NONATOMIC);
  
  [[self fb_layout] removeAllChildren];
  
  for (id<FBLayoutProtocol> layoutElement in children) {
    NSAssert([layoutElement conformsToProtocol:NSProtocolFromString(@"FBLayoutProtocol")], @"child %@ has no conformsToProtocol FBLayoutProtocol", self);
    [[self fb_layout] addChild:layoutElement.fb_layout];
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
  return objc_getAssociatedObject(self, _cmd) ?:[NSMutableArray array];
}

- (void)fb_setFlexDirection:(FBFlexDirection)direction
              justifyContent:(FBJustify)justifyContent
                  alignItems:(FBAlign)alignItems
                    children:(NSArray<id<FBLayoutProtocol>>*)children {
  
  [self fb_makeLayout:^(FBLayout *layout) {
    [layout setFlexDirection:direction];
    [layout setJustifyContent:justifyContent];
    [layout setAlignItems:alignItems];
  }];
  [self setFb_children:children];
}

- (void)fb_wrapContent {
  [self fb_layout].mesureSize = [self sizeThatFits:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)];
  YGSetMesure([self fb_layout]);
}

- (void)setFb_drawsAsynchronously:(BOOL)fb_drawsAsynchronously {
  self.layer.drawsAsynchronously = fb_drawsAsynchronously;
}

- (BOOL)fb_drawsAsynchronously {
  return self.layer.drawsAsynchronously;
}


- (FBLayout *)fb_layout {
  
  FBLayout *layout = objc_getAssociatedObject(self, _cmd);
  if (!layout) {
    layout = [FBLayout new];
    layout.context = self;
    objc_setAssociatedObject(self, _cmd, layout, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
  }
  
  return layout;
  
}


#pragma mark - layout

- (void)fb_applyLayouWithSize:(CGSize)size {
  [[self fb_layout] calculateLayoutWithSize:size];
  self.frame = [self fb_layout].frame;
  [self fb_applyLayoutToViewHierachy];
}


- (void)fb_asyApplyLayoutWithSize:(CGSize)size {
  [FBAsyLayoutTransaction addCalculateTransaction:^{
    [[self fb_layout] calculateLayoutWithSize:size];
  } complete:^{
     self.frame = [self fb_layout].frame;
    [self fb_applyLayoutToViewHierachy];

  }];
}


- (void)fb_applyLayoutToViewHierachy {
  for (id<FBLayoutProtocol> layoutElement in [self fb_children]) {
    
    layoutElement.frame = layoutElement.fb_layout.frame;
    
    [layoutElement fb_applyLayoutToViewHierachy];
  }
  
}

- (FBLayout *)fb_makeLayout:(void(^)(FBLayout *layout))layout {
  if (layout) {
    layout([self fb_layout]);
  }
  return [self fb_layout];
}


@end
