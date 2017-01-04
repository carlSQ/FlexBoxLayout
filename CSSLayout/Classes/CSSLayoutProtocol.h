//
//  CSSLayoutProtocol.h
//  CSJSView
//
//  Created by 沈强 on 2016/12/23.
//  Copyright © 2016年 沈强. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CSSLayout.h"

UIKIT_EXTERN NSString *CSSDirectiontAttributeName;

UIKIT_EXTERN NSString *CSSFlexDirectionAttributeName;

UIKIT_EXTERN NSString *CSSJustifyContentAttributeName;

UIKIT_EXTERN NSString *CSSAlignContentAttributeName;

UIKIT_EXTERN NSString *CSSAlignItemsAttributeName;

UIKIT_EXTERN NSString *CSSAlignSelfAttributeName;

UIKIT_EXTERN NSString *CSSPositionTypeAttributeName;

UIKIT_EXTERN NSString *CSSFlexWrapAttributeName;

UIKIT_EXTERN NSString *CSSFlexGrowAttributeName;

UIKIT_EXTERN NSString *CSSFlexShrinkAttributeName;

UIKIT_EXTERN NSString *CSSFlexBasisAttributeName;

UIKIT_EXTERN NSString *CSSPositionAttributeName; // UIEdge

UIKIT_EXTERN NSString *CSSMarginAttributeName; // UIEdge

UIKIT_EXTERN NSString *CSSPaddingAttributeName; //UIEdge

UIKIT_EXTERN NSString *CSSWidthAttributeName;

UIKIT_EXTERN NSString *CSSHeightAttributeName;

UIKIT_EXTERN NSString *CSSMinWidthAttributeName;

UIKIT_EXTERN NSString *CSSMinHeightAttributeName;

UIKIT_EXTERN NSString *CSSMaxWidthAttributeName;

UIKIT_EXTERN NSString *CSSMaxHeightAttributeName;

UIKIT_EXTERN NSString *CSSAspectRatioAttributeName;

@protocol CSSLayoutProtocol <NSObject>

@required

@property(nonatomic, strong, readonly) CSSLayout *layout;

@property(nonatomic, assign ) CGRect frame;

@property(nonatomic, copy) NSArray<id<CSSLayoutProtocol>> *children;

@property(nonatomic, copy) NSDictionary *CSSStyles;

- (void)addChild:(id<CSSLayoutProtocol>)layout;

- (void)addChildren:(NSArray<id<CSSLayoutProtocol>> *)children;

- (void)insertChild:(id<CSSLayoutProtocol>)layout atIndex:(NSInteger)index;

- (id<CSSLayoutProtocol>)childLayoutAtIndex:(NSUInteger)index;

- (void)removeChild:(id<CSSLayoutProtocol>)layout;

- (void)removeAllChildren;

- (void)applyLayoutToViewHierachy;

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

- (void)setMinWidth:(CGFloat)minWidth;

- (void)setMinHeight:(CGFloat)minHeight;

- (void)setMaxWidth:(CGFloat)maxWidth;

- (void)setMaxHeight:(CGFloat)maxHeight;

- (void)setAspectRatio:(CGFloat)aspectRatio;

@end
