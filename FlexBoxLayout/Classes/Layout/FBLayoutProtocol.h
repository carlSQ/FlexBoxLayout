//
//  FBLayoutProtocol.h
//  CSJSView
//
//  Created by 沈强 on 2016/12/23.
//  Copyright © 2016年 沈强. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FBLayout.h"
#import "FBLayout+Private.h"

extern const CGSize fb_undefinedSize; 

extern const CGFloat fb_undefined;

@protocol FBLayoutProtocol <NSObject>

@required

@property(nonatomic, strong, readonly) FBLayout *fb_layout;

/**
  the frame after calculates the layout
 */
@property(nonatomic, assign ) CGRect frame;


/**
 children layout node
 */
@property(nonatomic, copy) NSArray<id<FBLayoutProtocol>> *fb_children;


/**
 styles of layout
 */
@property(nonatomic, copy) NSDictionary *fbStyles;

- (void)fb_addChild:(id<FBLayoutProtocol>)layout;

- (void)fb_addChildren:(NSArray<id<FBLayoutProtocol>> *)children;

- (void)fb_insertChild:(id<FBLayoutProtocol>)layout atIndex:(NSInteger)index;

- (id<FBLayoutProtocol>)fb_childLayoutAtIndex:(NSUInteger)index;

- (void)fb_removeChild:(id<FBLayoutProtocol>)layout;

- (void)fb_removeAllChildren;


- (void)fb_applyLayoutToViewHierachy;


/**
 calculates the layout

 @param root layout size
 */
- (void)fb_applyLayouWithSize:(CGSize)size;


/**
 calculates the layout asynchronously

 @param root layout size
 */
- (void)fb_asyApplyLayoutWithSize:(CGSize)size;


/**
 setting layout properties
 @param layout
 @return  chained calls are supported
 */
- (FBLayout *)fb_makeLayout:(void(^)(FBLayout *layout))layout;

@end
