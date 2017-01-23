//
//  CSSLayout.h
//
//  Created by 沈强 on 16/8/28.
//  Copyright © 2016年 沈强. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSSLayout.h"
#import "Yoga.h"


typedef enum CSSFlexDirection {
  CSSFlexDirectionColumn,
  CSSFlexDirectionColumnReverse,
  CSSFlexDirectionRow,
  CSSFlexDirectionRowReverse,
} CSSFlexDirection;

typedef enum CSSMeasureMode {
  CSSMeasureModeUndefined,
  CSSMeasureModeExactly,
  CSSMeasureModeAtMost,
} CSSMeasureMode;

typedef enum CSSPrintOptions {
  CSSPrintOptionsLayout = 1,
  CSSPrintOptionsStyle = 2,
  CSSPrintOptionsChildren = 4,
} CSSPrintOptions;

typedef enum CSSEdge {
  CSSEdgeLeft,
  CSSEdgeTop,
  CSSEdgeRight,
  CSSEdgeBottom,
  CSSEdgeStart,
  CSSEdgeEnd,
  CSSEdgeHorizontal,
  CSSEdgeVertical,
  CSSEdgeAll,
} CSSEdge;

typedef enum CSSPositionType {
  CSSPositionTypeRelative,
  CSSPositionTypeAbsolute,
} CSSPositionType;

typedef enum CSSDimension {
  CSSDimensionWidth,
  CSSDimensionHeight,
} CSSDimension;

typedef enum CSSJustify {
  CSSJustifyFlexStart,
  CSSJustifyCenter,
  CSSJustifyFlexEnd,
  CSSJustifySpaceBetween,
  CSSJustifySpaceAround,
} CSSJustify;

typedef enum CSSDirection {
  CSSDirectionInherit,
  CSSDirectionLTR,
  CSSDirectionRTL,
} CSSDirection;

typedef enum CSSLogLevel {
  CSSLogLevelError,
  CSSLogLevelWarn,
  CSSLogLevelInfo,
  CSSLogLevelDebug,
  CSSLogLevelVerbose,
} CSSLogLevel;

typedef enum CSSWrap {
  CSSWrapNoWrap,
  CSSWrapWrap,
  CSSWrapCount,
} CSSWrap;

typedef enum CSSOverflow {
  CSSOverflowVisible,
  CSSOverflowHidden,
  CSSOverflowScroll,
} CSSOverflow;

typedef enum CSSExperimentalFeature {
  CSSExperimentalFeatureRounding,
  CSSExperimentalFeatureWebFlexBasis,
} CSSExperimentalFeature;

typedef enum CSSAlign {
  CSSAlignAuto,
  CSSAlignFlexStart,
  CSSAlignCenter,
  CSSAlignFlexEnd,
  CSSAlignStretch,
} CSSAlign;

NS_ASSUME_NONNULL_BEGIN

@interface CSSLayout : NSObject

@property(nonatomic, weak) id context;

@property(nonatomic, weak) CSSLayout *parent;

@property(nonatomic, copy)NSDictionary *CSSStyles;

@property(nonatomic, readonly, assign) YGNodeRef cssNode;

@property(nonatomic, readonly, assign) CGRect frame;

- (NSArray *)allChildren;

- (void)addChild:(CSSLayout *)layout;

- (void)addChildren:(NSArray *)children;

- (void)insertChild:(CSSLayout *)layout atIndex:(NSInteger)index;

- (CSSLayout *)childLayoutAtIndex:(NSUInteger)index;

- (void)removeChild:(CSSLayout *)layout;

- (void)removeAllChildren;

- (void)calculateLayoutWithSize:(CGSize)size;

@end


@interface CSSLayout (CSSStyle)

- (CSSLayout *)flexDirection;

- (CSSLayout *)justifyContent;

- (CSSLayout *)alignContent;

- (CSSLayout *)alignItems;

- (CSSLayout *)alignSelf;

- (CSSLayout *)positionType;

- (CSSLayout *)flexWrap;

- (CSSLayout *)flexGrow;

- (CSSLayout *)flexShrink;

- (CSSLayout *)flexBasiss;

- (CSSLayout *)position;

- (CSSLayout *)margin;

- (CSSLayout *)padding;

- (CSSLayout *)width;

- (CSSLayout *)height;

- (CSSLayout *)minWidth;

- (CSSLayout *)minHeight;

- (CSSLayout *)maxWidth;

- (CSSLayout *)maxHeight;

- (CSSLayout *)size;

- (CSSLayout *)maxSize;

- (CSSLayout *)minSize;

- (CSSLayout *)aspectRatio;

- (CSSLayout * (^)(id attr))equalTo;

- (CSSLayout * (^)(CGSize attr))equalToSize;

- (CSSLayout * (^)(UIEdgeInsets attr))equalToEdgeInsets;


- (void)setDirection:(CSSDirection)direction;

- (void)setFlexDirection:(CSSFlexDirection)flexDirection;

- (void)setJustifyContent:(CSSJustify)justifyContent;

- (void)setAlignContent:(CSSAlign)alignContent;

- (void)setAlignItems:(CSSAlign)alignItems;

- (void)setAlignSelf:(CSSAlign)alignSelf;

- (void)setPositionType:(CSSPositionType)positionType;

- (void)setFlexWrap:(CSSWrap)flexWrap;

- (void)setFlexGrow:(CGFloat)flexGrow;

- (void)setFlexShrink:(CGFloat)flexShrink;

- (void)setFlexBasis:(CGFloat)flexBasis;

- (void)setPosition:(CGFloat)position forEdge:(CSSEdge)edge;

- (void)setMargin:(CGFloat)margin forEdge:(CSSEdge)edge;

- (void)setPadding:(CGFloat)padding forEdge:(CSSEdge)edge;

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

NS_ASSUME_NONNULL_END
