//
//  FBViewLayoutCache.h
//  Pods
//
//  Created by 沈强 on 2017/3/3.
//
//

#import <Foundation/Foundation.h>

@interface FBViewLayoutCache : NSObject

@property(nonatomic, assign) CGRect frame;

@property(nonatomic, strong) NSArray<FBViewLayoutCache*> *childrenCache;

@end
