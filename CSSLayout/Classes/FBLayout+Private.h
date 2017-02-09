//
//  FBLayout+Private.h
//  Pods
//
//  Created by 沈强 on 2017/2/9.
//
//

#import "FBLayout.h"
#import "Yoga.h"

@interface FBLayout (Private)

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
