//
//  FBLayoutProtocol.h
//  CSJSView
//
//  Created by 沈强 on 2016/12/23.
//  Copyright © 2016年 沈强. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FBLayout.h"

UIKIT_EXTERN NSString *FBDirectiontAttributeName;

UIKIT_EXTERN NSString *FBFlexDirectionAttributeName;

UIKIT_EXTERN NSString *FBJustifyContentAttributeName;

UIKIT_EXTERN NSString *FBAlignContentAttributeName;

UIKIT_EXTERN NSString *FBAlignItemsAttributeName;

UIKIT_EXTERN NSString *FBAlignSelfAttributeName;

UIKIT_EXTERN NSString *FBPositionTypeAttributeName;

UIKIT_EXTERN NSString *FBFlexWrapAttributeName;

UIKIT_EXTERN NSString *FBFlexGrowAttributeName;

UIKIT_EXTERN NSString *FBFlexShrinkAttributeName;

UIKIT_EXTERN NSString *FBFlexBasisAttributeName;

UIKIT_EXTERN NSString *FBPositionAttributeName; // UIEdge

UIKIT_EXTERN NSString *FBMarginAttributeName; // UIEdge

UIKIT_EXTERN NSString *FBPaddingAttributeName; //UIEdge

UIKIT_EXTERN NSString *FBWidthAttributeName;

UIKIT_EXTERN NSString *FBHeightAttributeName;

UIKIT_EXTERN NSString *FBMinWidthAttributeName;

UIKIT_EXTERN NSString *FBMinHeightAttributeName;

UIKIT_EXTERN NSString *FBMaxWidthAttributeName;

UIKIT_EXTERN NSString *FBMaxHeightAttributeName;

UIKIT_EXTERN NSString *FBAspectRatioAttributeName;

extern const CGSize fb_undefinedSize;

extern const CGFloat fb_undefined;

@protocol FBLayoutProtocol <NSObject>

@required

@property(nonatomic, strong, readonly) FBLayout *fb_layout;

@property(nonatomic, assign ) CGRect frame;

@property(nonatomic, copy) NSArray<id<FBLayoutProtocol>> *fb_children;

@property(nonatomic, copy) NSDictionary *fbStyles;

- (void)fb_addChild:(id<FBLayoutProtocol>)layout;

- (void)fb_addChildren:(NSArray<id<FBLayoutProtocol>> *)children;

- (void)fb_insertChild:(id<FBLayoutProtocol>)layout atIndex:(NSInteger)index;

- (id<FBLayoutProtocol>)fb_childLayoutAtIndex:(NSUInteger)index;

- (void)fb_removeChild:(id<FBLayoutProtocol>)layout;

- (void)fb_removeAllChildren;

- (void)fb_applyLayoutToViewHierachy;

- (void)fb_applyLayouWithSize:(CGSize)size;

- (void)fb_asyApplyLayoutWithSize:(CGSize)size;

- (FBLayout *)fb_makeLayout:(void(^)(FBLayout *layout))layout;

@end
