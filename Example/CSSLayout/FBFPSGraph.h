//
//  CSSFPSGraph.h
//  CSSLayout
//
//  Created by 沈强 on 2017/1/11.
//  Copyright © 2017年 qiang.shen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FBFPSGraph : UIView

@property (nonatomic, assign, readonly) NSUInteger FPS;
@property (nonatomic, assign, readonly) NSUInteger maxFPS;
@property (nonatomic, assign, readonly) NSUInteger minFPS;

- (instancetype)initWithFrame:(CGRect)frame
                        color:(UIColor *)color;

@end
