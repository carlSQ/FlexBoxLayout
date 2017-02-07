//
//  UITableView+fbLayout.h
//  Pods
//
//  Created by 沈强 on 2017/1/11.
//
//

#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

typedef UIView *_Nonnull (^FBCellBlock)(NSIndexPath * _Nonnull indexPath);

@interface UITableView (FBLayout)

@property(nonatomic) CGFloat fb_constrainedWidth;

- (CGFloat)fb_heightForIndexPath:(NSIndexPath *)indexPath;

- (UITableViewCell *)fb_cellForIndexPath:(NSIndexPath *)indexPath;

- (void)fb_setCellContnetViewBlockForIndexPath:(FBCellBlock)cellBlock;

@end

NS_ASSUME_NONNULL_END
