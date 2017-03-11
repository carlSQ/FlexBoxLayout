//
//  FBLayout+Private.h
//  Pods
//
//  Created by 沈强 on 2017/2/9.
//
//

#import "FBLayout.h"
#import "Yoga.h"
#import "FBViewLayoutCache.h"

@interface FBLayout (Private)

@property(nonatomic, weak) id context;

@property(nonatomic, weak) FBLayout *parent;

@property(nonatomic, copy)NSDictionary *fbStyles;

@property(nonatomic, readonly, assign) YGNodeRef fbNode;

@property(nonatomic, readonly, assign) CGRect frame;

@property(nonatomic, assign) CGSize mesureSize;

- (FBViewLayoutCache *)layouCache;

- (void)applyLayoutCache:(FBViewLayoutCache *)layoutCache;

- (NSArray *)allChildren;

- (void)addChild:(FBLayout *)layout;

- (void)addChildren:(NSArray *)children;

- (void)insertChild:(FBLayout *)layout atIndex:(NSInteger)index;

- (FBLayout *)childLayoutAtIndex:(NSUInteger)index;

- (void)removeChild:(FBLayout *)layout;

- (void)removeAllChildren;

- (void)calculateLayoutWithSize:(CGSize)size;

- (void)setDirection:(FBDirection)direction;

- (void)setFlexDirection:(FBFlexDirection)flexDirection;

- (void)setJustifyContent:(FBJustify)justifyContent;

- (void)setAlignContent:(FBAlign)alignContent;

- (void)setAlignItems:(FBAlign)alignItems;

- (void)setAlignSelf:(FBAlign)alignSelf;

- (void)setPositionType:(FBPositionType)positionType;

- (void)setFlexWrap:(FBWrap)flexWrap;

- (void)setFlexGrow:(CGFloat)flexGrow;

- (void)setFlexShrink:(CGFloat)flexShrink;

- (void)setFlexBasis:(CGFloat)flexBasis;

- (void)setPosition:(CGFloat)position forEdge:(FBEdge)edge;

- (void)setMargin:(CGFloat)margin forEdge:(FBEdge)edge;

- (void)setPadding:(CGFloat)padding forEdge:(FBEdge)edge;

- (void)setWidth:(CGFloat)width;

- (void)setHeight:(CGFloat)height;

- (void)setSize:(CGSize)size;

- (void)setMinWidth:(CGFloat)minWidth;

- (void)setMinHeight:(CGFloat)minHeight;

- (void)setMinSize:(CGSize)minSize;

- (void)setMaxWidth:(CGFloat)maxWidth;

- (void)setMaxHeight:(CGFloat)maxHeight;

- (void)setMaxSize:(CGSize)maxSize;

- (void)setAspectRatio:(CGFloat)aspectRatio;

@end
