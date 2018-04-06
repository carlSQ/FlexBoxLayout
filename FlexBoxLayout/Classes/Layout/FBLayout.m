//
//  FBLayout.m
//
//  Created by 沈强 on 16/8/28.
//  Copyright © 2016年 沈强. All rights reserved.
//

#import "FBLayout.h"
#import "FBLayout+Private.h"
#import "FBLayoutProtocol.h"
#import "Yoga.h"
#import "FBLayoutDiv.h"

static CGFloat FBRoundPixelValue(CGFloat value)
{
  static CGFloat scale;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^(){
    scale = [UIScreen mainScreen].scale;
  });
  
  return round(value * scale) / scale;
}

static CGFloat YGSanitizeMeasurement(
                                     CGFloat constrainedSize,
                                     CGFloat measuredSize,
                                     YGMeasureMode measureMode)
{
  CGFloat result;
  if (measureMode == YGMeasureModeExactly) {
    result = constrainedSize;
  } else if (measureMode == YGMeasureModeAtMost) {
    result = MIN(constrainedSize, measuredSize);
  } else {
    result = measuredSize;
  }
  
  return result;
}


static YGSize YGMeasureView(
                            YGNodeRef node,
                            float width,
                            YGMeasureMode widthMode,
                            float height,
                            YGMeasureMode heightMode)
{
  const CGFloat constrainedWidth = (widthMode == YGMeasureModeUndefined) ? CGFLOAT_MAX : width;
  const CGFloat constrainedHeight = (heightMode == YGMeasureModeUndefined) ? CGFLOAT_MAX: height;
  
  UIView *view = (__bridge UIView*) YGNodeGetContext(node);
  __block CGSize sizeThatFits;
  if ([[NSThread currentThread] isMainThread]) {
    sizeThatFits = [view sizeThatFits:(CGSize) {
      .width = constrainedWidth,
      .height = constrainedHeight,
    }];
  } else {
    dispatch_sync(dispatch_get_main_queue(), ^{
      sizeThatFits = [view sizeThatFits:(CGSize) {
        .width = constrainedWidth,
        .height = constrainedHeight,
      }];
    });
  }
  return (YGSize) {
    .width = YGSanitizeMeasurement(constrainedWidth, sizeThatFits.width, widthMode),
    .height = YGSanitizeMeasurement(constrainedHeight, sizeThatFits.height, heightMode),
  };
}

void YGSetMesure(FBLayout *layout) {
  if ([layout.context isKindOfClass:[UIView class]] && layout.allChildren.count == 0) {
    YGNodeSetMeasureFunc(layout.fbNode, YGMeasureView);
  } else {
    YGNodeSetMeasureFunc(layout.fbNode, NULL);
  }
}

@interface FBLayout() {
   NSMutableArray *_children;
}

@property(nonatomic, strong) NSMutableArray *styleNames;

@property(nonatomic, weak) id context;

@property(nonatomic, weak) FBLayout *parent;

@property(nonatomic, copy)NSDictionary *fbStyles;

@property(nonatomic, readonly, assign) YGNodeRef fbNode;

@property(nonatomic, readonly, assign) CGRect frame;

@property(nonatomic, assign) CGSize mesureSize;

@end

@implementation FBLayout

- (instancetype)init {
  if (self = [super init]) {
    _fbNode = YGNodeNew();
    _children = [NSMutableArray array];
    _styleNames = [NSMutableArray array];
  }
  return self;
}

- (void)setContext:(id)context {
  _context = context;
  YGNodeSetContext(_fbNode, (__bridge void *)(context));
}

- (void)dealloc {
   YGNodeFree(_fbNode);
}

- (CGRect)frame {

  return CGRectMake(FBRoundPixelValue(YGNodeLayoutGetLeft(_fbNode)),
                    FBRoundPixelValue(YGNodeLayoutGetTop(_fbNode)),
                    FBRoundPixelValue(YGNodeLayoutGetWidth(_fbNode)),
                    FBRoundPixelValue(YGNodeLayoutGetHeight(_fbNode)));
}

- (FBViewLayoutCache *)layoutCache {
  
  FBViewLayoutCache *layoutCache = [FBViewLayoutCache new];
  layoutCache.frame = ((id<FBLayoutProtocol>)self.context).frame;
  NSMutableArray *childrenLayoutCache = [NSMutableArray arrayWithCapacity:self.allChildren.count];
  for (FBLayout *childLayout in self.allChildren) {
    [childrenLayoutCache addObject:[childLayout layoutCache]];
  }
  layoutCache.childrenCache = [childrenLayoutCache copy];
  return layoutCache;
}


- (void)applyLayoutCache:(FBViewLayoutCache *)layoutCache {
  id<FBLayoutProtocol> view = self.context;
  view.frame = layoutCache.frame;
  if (view.fb_children.count != layoutCache.childrenCache.count) {
    return;
  }
  
  for (int i = 0; i < layoutCache.childrenCache.count; i++) {
    FBViewLayoutCache* childLayoutCache = layoutCache.childrenCache[i];
    id<FBLayoutProtocol> childView = view.fb_children[i];
    [childView.fb_layout applyLayoutCache:childLayoutCache];
  }
  
}

#pragma mark - children

- (NSArray *)allChildren {
  return [_children copy];
}

- (FBLayout *)childLayoutAtIndex:(NSUInteger)index {
  return [_children objectAtIndex:index];
}

- (void)addChild:(FBLayout *)layout {
  
  [_children addObject:layout];
  layout.parent = self;
  
  YGNodeInsertChild(_fbNode, layout.fbNode, YGNodeGetChildCount(_fbNode));
  
}

- (void)addChildren:(NSArray *)children {
  for (FBLayout *layout in children) {
    [self addChild:layout];
  }
}

- (void)insertChild:(FBLayout *)layout atIndex:(NSInteger)index {
  [_children insertObject:layout atIndex:index];
  layout.parent = self;
  YGNodeInsertChild(_fbNode, layout.fbNode, (uint32_t)index);
}

- (void)removeChild:(FBLayout *)layout {
  [_children removeObject:layout];
  YGNodeRemoveChild(_fbNode, layout.fbNode);
}

- (void)removeAllChildren {
  [_children removeAllObjects];
  if (_fbNode == NULL) {
    return;
  }
  
  while (YGNodeGetChildCount(_fbNode) > 0) {
    YGNodeRemoveChild(_fbNode, YGNodeGetChild(_fbNode, YGNodeGetChildCount(_fbNode) - 1));
  }
}


#pragma mark - calculate

- (void)calculateLayoutWithSize:(CGSize)size {

  YGNodeCalculateLayout(_fbNode,
                        size.width,
                        size.height,
                        YGNodeStyleGetDirection(_fbNode));
}


#pragma mark - FB styles

#define FB_STYLE_FILL(key)\
do {\
id value = _fbStyles[@"FB"#key"AttributeName"];\
if (value) {\
  [self set##key:[(NSNumber *)value floatValue]];\
}\
} while(0);

#define FB_STYLE_FILL_ALL_DIRECTION(key) \
do {\
id value = _fbStyles[@"FB"#key"AttributeName"];\
if (value) {\
[self set##key:[(NSValue *)value UIEdgeInsetsValue].left forEdge:FBEdgeLeft];\
[self set##key:[(NSValue *)value UIEdgeInsetsValue].top forEdge:FBEdgeTop];\
[self set##key:[(NSValue *)value UIEdgeInsetsValue].right forEdge:FBEdgeRight];\
[self set##key:[(NSValue *)value UIEdgeInsetsValue].bottom forEdge:FBEdgeBottom];\
}\
} while(0);

#define FB_STYLE_FILL_ALL_SIZE(key) \
do {\
  id value = _fbStyles[@"FB"#key"AttributeName"];\
  if (value) {\
    [self set##key:[(NSValue *)value CGSizeValue]];\
  }\
} while(0);

- (void)setFbStyles:(NSDictionary *)fbStyles {
  
  if (_fbStyles == fbStyles) {
    return;
  }
  _fbStyles = fbStyles;
  FB_STYLE_FILL(Direction)
  FB_STYLE_FILL(FlexDirection)
  FB_STYLE_FILL(JustifyContent)
  FB_STYLE_FILL(AlignContent)
  FB_STYLE_FILL(AlignItems)
  FB_STYLE_FILL(AlignSelf)
  FB_STYLE_FILL(PositionType)
  FB_STYLE_FILL(FlexWrap)
  FB_STYLE_FILL(FlexGrow)
  FB_STYLE_FILL(FlexShrink)
  FB_STYLE_FILL(FlexBasis)
  FB_STYLE_FILL_ALL_DIRECTION(Position)
  FB_STYLE_FILL_ALL_DIRECTION(Margin)
  FB_STYLE_FILL_ALL_DIRECTION(Padding)
  FB_STYLE_FILL(Width)
  FB_STYLE_FILL(Height)
  FB_STYLE_FILL(MinWidth)
  FB_STYLE_FILL(MinHeight)
  FB_STYLE_FILL(MaxWidth)
  FB_STYLE_FILL(MaxHeight)
  FB_STYLE_FILL(AspectRatio)
  FB_STYLE_FILL_ALL_SIZE(Size)
  FB_STYLE_FILL_ALL_SIZE(MinSize)
  FB_STYLE_FILL_ALL_SIZE(MaxSize)
}


- (void)setDirection:(FBDirection)direction
{
  YGNodeStyleSetDirection(_fbNode, (YGDirection)direction);
}

- (void)setFlexDirection:(FBFlexDirection)flexDirection
{
  YGNodeStyleSetFlexDirection(_fbNode, (YGFlexDirection)flexDirection);
}

- (void)setJustifyContent:(FBJustify)justifyContent
{
  YGNodeStyleSetJustifyContent(_fbNode, (YGJustify)justifyContent);
}

- (void)setAlignContent:(FBAlign)alignContent
{
  YGNodeStyleSetAlignContent(_fbNode, (YGAlign)alignContent);
}

- (void)setAlignItems:(FBAlign)alignItems
{
  YGNodeStyleSetAlignItems(_fbNode, (YGAlign)alignItems);
}

- (void)setAlignSelf:(FBAlign)alignSelf
{
  YGNodeStyleSetAlignSelf(_fbNode, (YGAlign)alignSelf);
}

- (void)setPositionType:(FBPositionType)positionType
{
  YGNodeStyleSetPositionType(_fbNode, (YGPositionType)positionType);
}

- (void)setFlexWrap:(FBWrap)flexWrap
{
  YGNodeStyleSetFlexWrap(_fbNode, (YGWrap)flexWrap);
}

- (void)setFlexGrow:(CGFloat)flexGrow
{
  YGNodeStyleSetFlexGrow(_fbNode, flexGrow);
}

- (void)setFlexShrink:(CGFloat)flexShrink
{
  YGNodeStyleSetFlexShrink(_fbNode, flexShrink);
}

- (void)setFlexBasis:(CGFloat)flexBasis
{
  YGNodeStyleSetFlexBasis(_fbNode, flexBasis);
}

- (void)setPosition:(CGFloat)position forEdge:(FBEdge)edge
{
  YGNodeStyleSetPosition(_fbNode, (YGEdge)edge, position);
}

- (void)setMargin:(CGFloat)margin forEdge:(FBEdge)edge
{
  YGNodeStyleSetMargin(_fbNode, (YGEdge)edge, margin);
}

- (void)setPadding:(CGFloat)padding forEdge:(FBEdge)edge
{
  YGNodeStyleSetPadding(_fbNode, (YGEdge)edge, padding);
}

- (void)setWidth:(CGFloat)width
{
  YGNodeStyleSetWidth(_fbNode, width);
}

- (void)setHeight:(CGFloat)height
{
  YGNodeStyleSetHeight(_fbNode, height);
}

- (void)setSize:(CGSize)size {
  YGNodeStyleSetWidth(_fbNode, size.width);
  YGNodeStyleSetHeight(_fbNode, size.height);
}

- (void)setMinWidth:(CGFloat)minWidth
{
  YGNodeStyleSetMinWidth(_fbNode, minWidth);
}

- (void)setMinHeight:(CGFloat)minHeight
{
  YGNodeStyleSetMinHeight(_fbNode, minHeight);
}

- (void)setMinSize:(CGSize)minSize {
  YGNodeStyleSetMinWidth(_fbNode, minSize.width);
  YGNodeStyleSetMinHeight(_fbNode, minSize.height);
}

- (void)setMaxWidth:(CGFloat)maxWidth
{
  YGNodeStyleSetMaxWidth(_fbNode, maxWidth);
}

- (void)setMaxHeight:(CGFloat)maxHeight
{
  YGNodeStyleSetMaxHeight(_fbNode, maxHeight);
}

- (void)setMaxSize:(CGSize)maxSize {
  YGNodeStyleSetMaxWidth(_fbNode, maxSize.width);
  YGNodeStyleSetMaxHeight(_fbNode, maxSize.height);
}

- (void)setAspectRatio:(CGFloat)aspectRatio
{
  YGNodeStyleSetAspectRatio(_fbNode, aspectRatio);
}

#define CACHE_STYLES_NAME(name)  [_styleNames addObject:@""#name]; \
return self;

- (FBLayout *)flexDirection {
  CACHE_STYLES_NAME(FlexDirection)
}

- (FBLayout *)justifyContent {
  CACHE_STYLES_NAME(JustifyContent)
}

- (FBLayout *)alignContent {
   CACHE_STYLES_NAME(AlignContent)
}

- (FBLayout *)alignItems {
  CACHE_STYLES_NAME(AlignItems)
}

- (FBLayout *)alignSelf {
  CACHE_STYLES_NAME(AlignSelf)
}

- (FBLayout *)positionType {
  CACHE_STYLES_NAME(PositionType)
}

- (FBLayout *)flexWrap {
  CACHE_STYLES_NAME(FlexWrap)
}

- (FBLayout *)flexGrow {
  CACHE_STYLES_NAME(FlexGrow)
}

- (FBLayout *)flexShrink {
  CACHE_STYLES_NAME(FlexShrink)
}

- (FBLayout *)flexBasiss {
  CACHE_STYLES_NAME(FlexBasiss)
}

- (FBLayout *)position {
  CACHE_STYLES_NAME(Position)
}

- (FBLayout *)margin {
  CACHE_STYLES_NAME(Margin)
}

- (FBLayout *)padding {
  CACHE_STYLES_NAME(Padding)
}

- (FBLayout *)width {
  CACHE_STYLES_NAME(Width)
}

- (FBLayout *)height {
  CACHE_STYLES_NAME(Height)
}

- (FBLayout *)minWidth {
  CACHE_STYLES_NAME(MinWidth)
}

- (FBLayout *)minHeight {
  CACHE_STYLES_NAME(MinHeight)
}

- (FBLayout *)maxWidth {
  CACHE_STYLES_NAME(MaxWidth)
}

- (FBLayout *)maxHeight {
  CACHE_STYLES_NAME(MaxHeight)
}

- (FBLayout *)maxSize {
  CACHE_STYLES_NAME(MaxSize)
}

- (FBLayout *)minSize {
  CACHE_STYLES_NAME(MinSize)
}

- (FBLayout *)aspectRatio {
  CACHE_STYLES_NAME(AspectRatio)
}

- (FBLayout *)size {
  CACHE_STYLES_NAME(Size)
}

#define FB_STYLE(key, value)\
do {\
if ([_styleNames containsObject:@""#key]) {\
[self set##key:[(NSNumber *)value floatValue]];\
}\
} while(0);

#define FB_STYLE_ALL_DIRECTION(key, value) \
do {\
if ([_styleNames containsObject:@""#key]) {\
[self set##key:value.left forEdge:FBEdgeLeft];\
[self set##key:value.top forEdge:FBEdgeTop];\
[self set##key:value.right forEdge:FBEdgeRight];\
[self set##key:value.bottom forEdge:FBEdgeBottom];\
}\
} while(0);

#define FB_STYLE_ALL_SIZE(key, value) \
do {\
  if ([_styleNames containsObject:@""#key]) {\
    [self set##key:value];\
  }\
} while(0);

- (FBLayout * (^)(id attr))equalTo {
  return ^FBLayout* (id attr) {
    if ([attr conformsToProtocol:NSProtocolFromString(@"FBLayoutProtocol")]) {
      YGNodeCopyStyle(self.fbNode, [(id<FBLayoutProtocol>)attr fb_layout].fbNode);
      return self;
    }
    FB_STYLE(Direction,attr)
    FB_STYLE(FlexDirection,attr)
    FB_STYLE(JustifyContent,attr)
    FB_STYLE(AlignContent,attr)
    FB_STYLE(AlignItems,attr)
    FB_STYLE(AlignSelf,attr)
    FB_STYLE(PositionType,attr)
    FB_STYLE(FlexWrap,attr)
    FB_STYLE(FlexGrow,attr)
    FB_STYLE(FlexShrink,attr)
    FB_STYLE(FlexBasis,attr)
    FB_STYLE(Width,attr)
    FB_STYLE(Height,attr)
    FB_STYLE(MinWidth,attr)
    FB_STYLE(MinHeight,attr)
    FB_STYLE(MaxWidth,attr)
    FB_STYLE(MaxHeight,attr)
    FB_STYLE(AspectRatio,attr)
    [self.styleNames removeAllObjects];
    return self;
  };
}

- (FBLayout * (^)(CGSize attr))equalToSize {
  return ^FBLayout* (CGSize attr) {
    FB_STYLE_ALL_SIZE(Size,attr)
    FB_STYLE_ALL_SIZE(MinSize,attr)
    FB_STYLE_ALL_SIZE(MaxSize,attr)
    [self.styleNames removeAllObjects];
    return self;
  };
}

- (FBLayout * (^)(UIEdgeInsets attr))equalToEdgeInsets {
  return ^FBLayout* (UIEdgeInsets attr) {
    FB_STYLE_ALL_DIRECTION(Position,attr)
    FB_STYLE_ALL_DIRECTION(Margin,attr)
    FB_STYLE_ALL_DIRECTION(Padding,attr)
    [self.styleNames removeAllObjects];
    return self;
  };
}

- (FBLayout * (^)())wrapContent {
  return ^FBLayout* () {
    YGSetMesure(self);
    return self;
  };

}

- (FBLayout * (^)(NSArray* children))children {
  return ^FBLayout* (NSArray* children) {
    [((id<FBLayoutProtocol>)self.context) fb_addChildren:children];
    return self;
  };
}

@end
