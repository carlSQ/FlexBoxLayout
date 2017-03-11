//
//  FBLayout.h
//
//  Created by 沈强 on 16/8/28.
//  Copyright © 2016年 沈强. All rights reserved.
//

#import <UIKit/UIKit.h>

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


typedef enum FBAlign {
  FBAlignAuto,
  FBAlignFlexStart,
  FBAlignCenter,
  FBAlignFlexEnd,
  FBAlignStretch,
} FBAlign;

NS_ASSUME_NONNULL_BEGIN

@interface FBLayout : NSObject

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

- (FBLayout * (^)())wrapContent;

- (FBLayout * (^)(NSArray*))children;

@end

NS_ASSUME_NONNULL_END
