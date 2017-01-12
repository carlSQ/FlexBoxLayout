//
//  CSSLayout.m
//
//  Created by 沈强 on 16/8/28.
//  Copyright © 2016年 沈强. All rights reserved.
//

#import "CSSLayout.h"


NSString *CSSDirectiontAttributeName = @"CSSDirectiontAttributeName";

NSString *CSSFlexDirectionAttributeName = @"CSSFlexDirectionAttributeName";

NSString *CSSJustifyContentAttributeName = @"CSSJustifyContentAttributeName";

NSString *CSSAlignContentAttributeName = @"CSSAlignContentAttributeName";

NSString *CSSAlignItemsAttributeName = @"CSSAlignItemsAttributeName";

NSString *CSSAlignSelfAttributeName = @"CSSAlignSelfAttributeName";

NSString *CSSPositionTypeAttributeName = @"CSSPositionTypeAttributeName";

NSString *CSSFlexWrapAttributeName = @"CSSFlexWrapAttributeName";

NSString *CSSFlexGrowAttributeName = @"CSSFlexGrowAttributeName";

NSString *CSSFlexShrinkAttributeName = @"CSSFlexShrinkAttributeName";

NSString *CSSFlexBasisAttributeName = @"CSSFlexBasisAttributeName";

NSString *CSSPositionAttributeName = @"CSSPositionAttributeName";

NSString *CSSMarginAttributeName = @"CSSMarginAttributeName";

NSString *CSSPaddingAttributeName = @"CSSPaddingAttributeName";

NSString *CSSWidthAttributeName = @"CSSWidthAttributeName";

NSString *CSSHeightAttributeName = @"CSSHeightAttributeName";

NSString *CSSMinWidthAttributeName = @"CSSMinWidthAttributeName";

NSString *CSSMinHeightAttributeName = @"CSSMinHeightAttributeName";

NSString *CSSMaxWidthAttributeName = @"CSSMaxWidthAttributeName";

NSString *CSSMaxHeightAttributeName = @"CSSMaxHeightAttributeName";

NSString *CSSAspectRatioAttributeName = @"CSSAspectRatioAttributeName";

static CGFloat CSSRoundPixelValue(CGFloat value)
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
  const CGSize sizeThatFits = [view sizeThatFits:(CGSize) {
    .width = constrainedWidth,
    .height = constrainedHeight,
  }];
  
  return (YGSize) {
    .width = YGSanitizeMeasurement(constrainedWidth, sizeThatFits.width, widthMode),
    .height = YGSanitizeMeasurement(constrainedHeight, sizeThatFits.height, heightMode),
  };
}

void YGSetMesure(CSSLayout *layout) {
  if ([layout.context isKindOfClass:[UIView class]] && layout.allChildren.count == 0) {
    YGNodeSetMeasureFunc(layout.cssNode, YGMeasureView);
  } else {
    YGNodeSetMeasureFunc(layout.cssNode, NULL);
  }
}

@interface CSSLayout()

@property(nonatomic, strong) NSMutableArray *children;

@end

@implementation CSSLayout

- (instancetype)init {
  if (self = [super init]) {
    _cssNode = YGNodeNew();
    _children = [NSMutableArray array];
  }
  return self;
}

- (void)setContext:(id)context {
  _context = context;
  YGNodeSetContext(_cssNode, (__bridge void *)(context));
}

- (void)dealloc {
   YGNodeFree(_cssNode);
}

- (CGRect)frame {

  return CGRectMake(CSSRoundPixelValue(YGNodeLayoutGetLeft(_cssNode)),
                    CSSRoundPixelValue(YGNodeLayoutGetTop(_cssNode)),
                    CSSRoundPixelValue(YGNodeLayoutGetWidth(_cssNode)),
                    CSSRoundPixelValue(YGNodeLayoutGetHeight(_cssNode)));
}

#pragma mark - children

- (NSArray *)allChildren {
  return [_children copy];
}

- (CSSLayout *)childLayoutAtIndex:(NSUInteger)index {
  return [_children objectAtIndex:index];
}

- (void)addChild:(CSSLayout *)layout {
  
  [_children addObject:layout];
  layout.parent = self;
  
  YGNodeInsertChild(_cssNode, layout.cssNode, YGNodeGetChildCount(_cssNode));
  
}

- (void)addChildren:(NSArray *)children {
  for (CSSLayout *layout in children) {
    [self addChild:layout];
  }
}

- (void)insertChild:(CSSLayout *)layout atIndex:(NSInteger)index {
  [_children insertObject:layout atIndex:index];
  layout.parent = self;
  YGNodeInsertChild(_cssNode, layout.cssNode, (uint32_t)index);
}

- (void)removeChild:(CSSLayout *)layout {
  [_children removeObject:layout];
  YGNodeRemoveChild(_cssNode, layout.cssNode);
}

- (void)removeAllChildren {
  [_children removeAllObjects];
  if (_cssNode == NULL) {
    return;
  }
  
  while (YGNodeGetChildCount(_cssNode) > 0) {
    YGNodeRemoveChild(_cssNode, YGNodeGetChild(_cssNode, YGNodeGetChildCount(_cssNode) - 1));
  }
}


#pragma mark - calculate

- (void)calculateLayoutWithSize:(CGSize)size {

  YGNodeCalculateLayout(_cssNode,
                        size.width,
                        size.height,
                        YGNodeStyleGetDirection(_cssNode));
}

#pragma mark - css styles

#define CSS_STYLE_FILL(key)\
do {\
id value = _CSSStyles[@"CSS"#key"AttributeName"];\
if (value) {\
  [self set##key:[(NSNumber *)value floatValue]];\
}\
} while(0);

#define CSS_STYLE_FILL_ALL_DIRECTION(key) \
do {\
id value = _CSSStyles[@"CSS"#key"AttributeName"];\
if (value) {\
[self set##key:[(NSValue *)value UIEdgeInsetsValue].left forEdge:CSSEdgeLeft];\
[self set##key:[(NSValue *)value UIEdgeInsetsValue].top forEdge:CSSEdgeTop];\
[self set##key:[(NSValue *)value UIEdgeInsetsValue].right forEdge:CSSEdgeRight];\
[self set##key:[(NSValue *)value UIEdgeInsetsValue].bottom forEdge:CSSEdgeBottom];\
}\
} while(0);


- (void)setCSSStyles:(NSDictionary *)CSSStyles {
  
  if (_CSSStyles == CSSStyles) {
    return;
  }
  _CSSStyles = CSSStyles;
  CSS_STYLE_FILL(Direction)
  CSS_STYLE_FILL(FlexDirection)
  CSS_STYLE_FILL(JustifyContent)
  CSS_STYLE_FILL(AlignContent)
  CSS_STYLE_FILL(AlignItems)
  CSS_STYLE_FILL(AlignSelf)
  CSS_STYLE_FILL(PositionType)
  CSS_STYLE_FILL(FlexWrap)
  CSS_STYLE_FILL(FlexGrow)
  CSS_STYLE_FILL(FlexShrink)
  CSS_STYLE_FILL(FlexBasis)
  CSS_STYLE_FILL_ALL_DIRECTION(Position)
  CSS_STYLE_FILL_ALL_DIRECTION(Margin)
  CSS_STYLE_FILL_ALL_DIRECTION(Padding)
  CSS_STYLE_FILL(Width)
  CSS_STYLE_FILL(Height)
  CSS_STYLE_FILL(MinWidth)
  CSS_STYLE_FILL(MinHeight)
  CSS_STYLE_FILL(MaxWidth)
  CSS_STYLE_FILL(MaxHeight)
  CSS_STYLE_FILL(AspectRatio)
  
}


- (void)setDirection:(CSSDirection)direction
{
  YGNodeStyleSetDirection(_cssNode, (YGDirection)direction);
}

- (void)setFlexDirection:(CSSFlexDirection)flexDirection
{
  YGNodeStyleSetFlexDirection(_cssNode, (YGFlexDirection)flexDirection);
}

- (void)setJustifyContent:(CSSJustify)justifyContent
{
  YGNodeStyleSetJustifyContent(_cssNode, (YGJustify)justifyContent);
}

- (void)setAlignContent:(CSSAlign)alignContent
{
  YGNodeStyleSetAlignContent(_cssNode, (YGAlign)alignContent);
}

- (void)setAlignItems:(CSSAlign)alignItems
{
  YGNodeStyleSetAlignItems(_cssNode, (YGAlign)alignItems);
}

- (void)setAlignSelf:(CSSAlign)alignSelf
{
  YGNodeStyleSetAlignSelf(_cssNode, (YGAlign)alignSelf);
}

- (void)setPositionType:(CSSPositionType)positionType
{
  YGNodeStyleSetPositionType(_cssNode, (YGPositionType)positionType);
}

- (void)setFlexWrap:(CSSWrap)flexWrap
{
  YGNodeStyleSetFlexWrap(_cssNode, (YGWrap)flexWrap);
}

- (void)setFlexGrow:(CGFloat)flexGrow
{
  YGNodeStyleSetFlexGrow(_cssNode, flexGrow);
}

- (void)setFlexShrink:(CGFloat)flexShrink
{
  YGNodeStyleSetFlexShrink(_cssNode, flexShrink);
}

- (void)setFlexBasis:(CGFloat)flexBasis
{
  YGNodeStyleSetFlexBasis(_cssNode, flexBasis);
}

- (void)setPosition:(CGFloat)position forEdge:(CSSEdge)edge
{
  YGNodeStyleSetPosition(_cssNode, (YGEdge)edge, position);
}

- (void)setMargin:(CGFloat)margin forEdge:(CSSEdge)edge
{
  YGNodeStyleSetMargin(_cssNode, (YGEdge)edge, margin);
}

- (void)setPadding:(CGFloat)padding forEdge:(CSSEdge)edge
{
  YGNodeStyleSetPadding(_cssNode, (YGEdge)edge, padding);
}

- (void)setWidth:(CGFloat)width
{
  YGNodeStyleSetWidth(_cssNode, width);
}

- (void)setHeight:(CGFloat)height
{
  YGNodeStyleSetHeight(_cssNode, height);
}

- (void)setSize:(CGSize)size {
  YGNodeStyleSetWidth(_cssNode, size.width);
  YGNodeStyleSetHeight(_cssNode, size.height);
}

- (void)setMinWidth:(CGFloat)minWidth
{
  YGNodeStyleSetMinWidth(_cssNode, minWidth);
}

- (void)setMinHeight:(CGFloat)minHeight
{
  YGNodeStyleSetMinHeight(_cssNode, minHeight);
}

- (void)setMinSize:(CGSize)minSize {
  YGNodeStyleSetMinWidth(_cssNode, minSize.width);
  YGNodeStyleSetMinHeight(_cssNode, minSize.height);
}

- (void)setMaxWidth:(CGFloat)maxWidth
{
  YGNodeStyleSetMaxWidth(_cssNode, maxWidth);
}

- (void)setMaxHeight:(CGFloat)maxHeight
{
  YGNodeStyleSetMaxHeight(_cssNode, maxHeight);
}

- (void)setMaxSize:(CGSize)maxSize {
  YGNodeStyleSetMaxWidth(_cssNode, maxSize.width);
  YGNodeStyleSetMaxHeight(_cssNode, maxSize.height);
}

- (void)setAspectRatio:(CGFloat)aspectRatio
{
  YGNodeStyleSetAspectRatio(_cssNode, aspectRatio);
}


@end
