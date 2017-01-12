//
//  UITableView+CSSLayout.h
//  Pods
//
//  Created by 沈强 on 2017/1/11.
//
//

#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

typedef UIView *_Nonnull (^CSSCellBlock)(NSIndexPath * _Nonnull indexPath);

@interface UITableView (CSSLayout)

@property(nonatomic) CGFloat css_constrainedWidth;

- (CGFloat)css_heightForIndexPath:(NSIndexPath *)indexPath;

- (UITableViewCell *)css_cellForIndexPath:(NSIndexPath *)indexPath;

- (void)css_cellBlockForIndexPath:(CSSCellBlock)cellBlock;

@end

NS_ASSUME_NONNULL_END
