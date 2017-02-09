//
//  UITableView+fbLayout.h
//  Pods
//
//  Created by 沈强 on 2017/1/11.
//
//

#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

typedef UIView *_Nonnull (^FBCellBlock)(NSIndexPath *indexPath);

@interface UITableView (FBLayout)


/**
 setting the cell contentView Size, defalut width of UITableView
 */
@property(nonatomic) CGFloat fb_constrainedWidth;


/**
 get the height of cell
 @param indexPath
 @return
 */
- (CGFloat)fb_heightForIndexPath:(NSIndexPath *)indexPath;


/**
 get the cell of indexPath

 @param indexPath
 @return
 */
- (UITableViewCell *)fb_cellForIndexPath:(NSIndexPath *)indexPath;


/**
 set the cell content view
 @param cellBlock
 */
- (void)fb_setCellContnetViewBlockForIndexPath:(FBCellBlock)cellBlock;

@end

NS_ASSUME_NONNULL_END
