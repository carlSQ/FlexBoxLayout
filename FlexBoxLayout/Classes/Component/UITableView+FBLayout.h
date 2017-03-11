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
 cache layout
 */
@property(nonatomic) BOOL fb_cacheLayout;



/**
 cache content view cannot be together with fb_CacheLayout at the same time

 */
@property(nonatomic) BOOL fb_cacheContentView;


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


/**
 content view
 @param indexPath indexPath
 @return nil if cell is not visible or index path is out of range
 */
- (UIView *)fb_contentViewForIndexPath:(NSIndexPath *)indexPath;


/**
 remove all cache
 */
- (void)fb_removeAllCache;

@end

NS_ASSUME_NONNULL_END
