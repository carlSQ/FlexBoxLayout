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

extern const CGSize css_undefinedSize;

extern const CGFloat css_undefined;

@protocol CSSLayoutProtocol <NSObject>

@required

@property(nonatomic, strong, readonly) CSSLayout *css_layout;

@property(nonatomic, assign ) CGRect frame;

@property(nonatomic, copy) NSArray<id<CSSLayoutProtocol>> *css_children;

@property(nonatomic, copy) NSDictionary *CSSStyles;

- (void)css_addChild:(id<CSSLayoutProtocol>)layout;

- (void)css_addChildren:(NSArray<id<CSSLayoutProtocol>> *)children;

- (void)css_insertChild:(id<CSSLayoutProtocol>)layout atIndex:(NSInteger)index;

- (id<CSSLayoutProtocol>)css_childLayoutAtIndex:(NSUInteger)index;

- (void)css_removeChild:(id<CSSLayoutProtocol>)layout;

- (void)css_removeAllChildren;

- (void)css_applyLayoutToViewHierachy;

- (void)css_applyLayouWithSize:(CGSize)size;

- (void)css_asyApplyLayoutWithSize:(CGSize)size;

- (CSSLayout *)css_makeLayout:(void(^)(CSSLayout *layout))layout;

@end
