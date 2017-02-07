//
//  FBLayout.h
//
//  Created by 沈强 on 16/8/28.
//  Copyright © 2016年 沈强. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FBLayout.h"
#import "Yoga.h"


typedef enum FBFlexDirection {
  FBFlexDirectionColumn,
  FBFlexDirectionColumnReverse,
  FBFlexDirectionRow,
  FBFlexDirectionRowReverse,
} FBFlexDirection;

typedef enum FBMeasureMode {
  FBMeasureModeUndefined,
  FBMeasureModeExactly,
  FBMeasureModeAtMost,
} FBMeasureMode;

typedef enum FBPrintOptions {
  FBPrintOptionsLayout = 1,
  FBPrintOptionsStyle = 2,
  FBPrintOptionsChildren = 4,
} FBPrintOptions;

typedef enum FBEdge {
  FBEdgeLeft,
  FBEdgeTop,
  FBEdgeRight,
  FBEdgeBottom,
  FBEdgeStart,
  FBEdgeEnd,
  FBEdgeHorizontal,
  FBEdgeVertical,
  FBEdgeAll,
} FBEdge;

typedef enum FBPositionType {
  FBPositionTypeRelative,
  FBPositionTypeAbsolute,
} FBPositionType;

typedef enum FBDimension {
  FBDimensionWidth,
  FBDimensionHeight,
} FBDimension;

typedef enum FBJustify {
  FBJustifyFlexStart,
  FBJustifyCenter,
  FBJustifyFlexEnd,
  FBJustifySpaceBetween,
  FBJustifySpaceAround,
} FBJustify;

typedef enum FBDirection {
  FBDirectionInherit,
  FBDirectionLTR,
  FBDirectionRTL,
} FBDirection;

typedef enum FBLogLevel {
  FBLogLevelError,
  FBLogLevelWarn,
  FBLogLevelInfo,
  FBLogLevelDebug,
  FBLogLevelVerbose,
} FBLogLevel;

typedef enum FBWrap {
  FBWrapNoWrap,
  FBWrapWrap,
  FBWrapCount,
} FBWrap;

typedef enum FBOverflow {
  FBOverflowVisible,
  FBOverflowHidden,
  FBOverflowScroll,
} FBOverflow;

typedef enum FBExperimentalFeature {
  FBExperimentalFeatureRounding,
  FBExperimentalFeatureWebFlexBasis,
} FBExperimentalFeature;

typedef enum FBAlign {
  FBAlignAuto,
  FBAlignFlexStart,
  FBAlignCenter,
  FBAlignFlexEnd,
  FBAlignStretch,
} FBAlign;

NS_ASSUME_NONNULL_BEGIN

@interface FBLayout : NSObject

@property(nonatomic, weak) id context;

@property(nonatomic, weak) FBLayout *parent;

@property(nonatomic, copy)NSDictionary *fbStyles;

@property(nonatomic, readonly, assign) YGNodeRef fbNode;

@property(nonatomic, readonly, assign) CGRect frame;

- (NSArray *)allChildren;

- (void)addChild:(FBLayout *)layout;

- (void)addChildren:(NSArray *)children;

- (void)insertChild:(FBLayout *)layout atIndex:(NSInteger)index;

- (FBLayout *)childLayoutAtIndex:(NSUInteger)index;

- (void)removeChild:(FBLayout *)layout;

- (void)removeAllChildren;

- (void)calculateLayoutWithSize:(CGSize)size;

@end


@interface FBLayout (FBStyle)

- (FBLayout *)flexDirection;

- (FBLayout *)justifyContent;

- (FBLayout *)alignContent;

- (FBLayout *)alignItems;

- (FBLayout *)alignSelf;

- (FBLayout *)positionType;

- (FBLayout *)flexWrap;

- (FBLayout *)flexGrow;

- (FBLayout *)flexShrink;

- (FBLayout *)flexBasiss;

- (FBLayout *)position;

- (FBLayout *)margin;

- (FBLayout *)padding;

- (FBLayout *)width;

- (FBLayout *)height;

- (FBLayout *)minWidth;

- (FBLayout *)minHeight;

- (FBLayout *)maxWidth;

- (FBLayout *)maxHeight;

- (FBLayout *)size;

- (FBLayout *)maxSize;

- (FBLayout *)minSize;

- (FBLayout *)aspectRatio;

- (FBLayout * (^)(id attr))equalTo;

- (FBLayout * (^)(CGSize attr))equalToSize;

- (FBLayout * (^)(UIEdgeInsets attr))equalToEdgeInsets;


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

NS_ASSUME_NONNULL_END
