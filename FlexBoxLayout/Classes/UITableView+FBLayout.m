//
//  UITableView+fbLayout.m
//  Pods
//
//  Created by 沈强 on 2017/1/11.
//
//

#import "UITableView+FBLayout.h"
#import <objc/runtime.h>
#import "UIView+CellStyle.h"
#import "UIView+FBLayout.h"

static NSString *kCellIdentifier = @"fb_kCellIdentifier";

@implementation UITableView (FBLayout)

+ (void)load {
  
  SEL interceptedSelectors[] = {
    @selector(reloadData),
    @selector(insertSections:withRowAnimation:),
    @selector(deleteSections:withRowAnimation:),
    @selector(reloadSections:withRowAnimation:),
    @selector(moveSection:toSection:),
    @selector(insertRowsAtIndexPaths:withRowAnimation:),
    @selector(deleteRowsAtIndexPaths:withRowAnimation:),
    @selector(reloadRowsAtIndexPaths:withRowAnimation:),
    @selector(moveRowAtIndexPath:toIndexPath:)
  };
  
  for (NSUInteger index = 0; index < sizeof(interceptedSelectors) / sizeof(SEL); ++index) {
    SEL originalSelector = interceptedSelectors[index];
    SEL swizzledSelector = NSSelectorFromString([@"fb_" stringByAppendingString:NSStringFromSelector(originalSelector)]);
    Method originalMethod = class_getInstanceMethod(self, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(self, swizzledSelector);
    method_exchangeImplementations(originalMethod, swizzledMethod);
  }
  
}

- (void)setFb_constrainedWidth:(CGFloat)fb_constrainedWidth {
  objc_setAssociatedObject(self, _cmd, @(fb_constrainedWidth), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat)fb_constrainedWidth {
  return [objc_getAssociatedObject(self, @selector(setFb_constrainedWidth:)) doubleValue];;
}

- (CGFloat)fb_heightForIndexPath:(NSIndexPath *)indexPath {
  return [self fb_cacheContentView:indexPath].frame.size.height;
}

- (UITableViewCell *)fb_cellForIndexPath:(NSIndexPath *)indexPath {
  return [self fb_cacheCellForIndexPath:indexPath];
}

- (void)fb_setCellContnetViewBlockForIndexPath:(FBCellBlock)cellBlock {
  static dispatch_once_t token;
  dispatch_once(&token, ^{
    [self registerClass:[UITableViewCell class] forCellReuseIdentifier:kCellIdentifier];
  });
  objc_setAssociatedObject(self, _cmd, cellBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}


#pragma mark - caches

- (UITableViewCell *)fb_cacheCellForIndexPath:(NSIndexPath *)indexPath {
  
  UITableViewCell *cell = [self dequeueReusableCellWithIdentifier:kCellIdentifier forIndexPath:indexPath];
  UIView *cellContentView = [self fb_cacheContentView:indexPath];
  
  cell.selectionStyle = cellContentView.fb_selectionStyle;
  cell.backgroundColor = cellContentView.backgroundColor;
  cell.clipsToBounds = cellContentView.clipsToBounds;
  [self fb_configContentView:cellContentView forCell:cell];
  
  return cell;
}

#define CACHE_CONTENT_VIEW objc_getAssociatedObject(self, @selector(fb_cacheContentView:))

- (UIView *)fb_cacheContentView:(NSIndexPath *)indexPath {
  
  NSMutableArray <NSMutableArray *>*cacheContentViews = CACHE_CONTENT_VIEW;
  
  if (!cacheContentViews) {
    cacheContentViews = [NSMutableArray array];
    objc_setAssociatedObject(self, _cmd, cacheContentViews, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
  }
  
  UIView * cellContentView = nil;
  NSMutableArray* sectionContentViews = nil;
  
  if (cacheContentViews.count > indexPath.section) {
    
    sectionContentViews = cacheContentViews[indexPath.section];
    
    if (sectionContentViews.count > indexPath.row) {
      cellContentView = sectionContentViews[indexPath.row];
    }
    
  } else {
    
    NSAssert(cacheContentViews.count == indexPath.section, @"%@ section is error",@(indexPath.section));
    
    cacheContentViews[indexPath.section] = [NSMutableArray array];
    
  }
  
  if (!cellContentView || [cellContentView isEqual:[NSNull null]]) {
    
    FBCellBlock cellBlock = objc_getAssociatedObject(self, @selector(fb_setCellContnetViewBlockForIndexPath:));
    
    if (cellBlock) {
      cellContentView = cellBlock(indexPath);
      [cellContentView fb_applyLayouWithSize:CGSizeMake(self.fb_constrainedWidth?:self.frame.size.width, fb_undefined)];
    } else {
      cellContentView = [UIView new];
    }
    
    [cacheContentViews[indexPath.section] insertObject:cellContentView atIndex:indexPath.row];
    
  }
  
  return cellContentView;
}


- (void)fb_removeAllCacheContentViews {
  NSMutableArray *cacheContentViews = CACHE_CONTENT_VIEW;
  [cacheContentViews removeAllObjects];
}

- (void)fb_removeCacheContentViewsAtSection:(NSUInteger)section {
  NSMutableArray *cacheContentViews = CACHE_CONTENT_VIEW;
  [cacheContentViews removeObjectAtIndex:section];
}

- (void)fb_removeCacheContentViewAtIndexPath:(NSIndexPath *)indexPath {
  NSMutableArray *cacheContentViews = CACHE_CONTENT_VIEW;
  [cacheContentViews[indexPath.section] removeObjectAtIndex:indexPath.row];
}

- (void)fb_addCacheContentViewsAtSection:(NSUInteger)section {
  NSMutableArray *cacheContentViews = CACHE_CONTENT_VIEW;
  [cacheContentViews insertObject:[NSMutableArray array] atIndex:section];
}

- (void)fb_addCacheContentViewsAtIndexPath:(NSIndexPath *)indexPath {
  NSMutableArray *cacheContentViews = CACHE_CONTENT_VIEW;
  [cacheContentViews[indexPath.section] insertObject:[NSNull null] atIndex:indexPath.row];
}

- (void)fb_reloadCacheContentViewsAtSection:(NSUInteger)section {
  NSMutableArray *cacheContentViews = CACHE_CONTENT_VIEW;
  [cacheContentViews[section] removeAllObjects];
}

- (void)fb_reloadCacheContentViewsAtIndexPath:(NSIndexPath *)indexPath {
  NSMutableArray *cacheContentViews = CACHE_CONTENT_VIEW;
  [cacheContentViews[indexPath.section] replaceObjectAtIndex:indexPath.row withObject:[NSNull null]];
}

- (void)fb_moveCacheContentViewsSection:(NSInteger)section toSection:(NSInteger)newSection {
  NSMutableArray *cacheContentViews = CACHE_CONTENT_VIEW;
  [cacheContentViews exchangeObjectAtIndex:section withObjectAtIndex:newSection];
}

- (void)fb_moveCacheContentViewsAtIndexPath:(NSIndexPath *)indexPath toIndexPath:(NSIndexPath *)newIndexPath {
  
  NSMutableArray *cacheContentViews = CACHE_CONTENT_VIEW;
  
  UIView *view1 = cacheContentViews[indexPath.section][indexPath.row];
  
  UIView *view2 = cacheContentViews[newIndexPath.section][newIndexPath.row];
  
  cacheContentViews[indexPath.section][indexPath.row] = view2;
  
  cacheContentViews[newIndexPath.section][newIndexPath.row] = view1;
  
}

- (void)fb_configContentView:(UIView *)contentView forCell:(UITableViewCell *)cell{
  for (UIView *view in cell.contentView.subviews) {
    [view removeFromSuperview];
  }
  [cell.contentView addSubview:contentView];
}

#pragma mark - interceptedSelectors

- (void)fb_reloadData {
  [self fb_removeAllCacheContentViews];
  [self fb_reloadData];
}

- (void)fb_insertSections:(NSIndexSet *)sections withRowAnimation:(UITableViewRowAnimation)animation{
  
  [sections enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL * _Nonnull stop) {
    [self fb_addCacheContentViewsAtSection:idx];
  }];
  
  [self fb_insertSections:sections withRowAnimation:animation];
  
}

- (void)fb_deleteSections:(NSIndexSet *)sections withRowAnimation:(UITableViewRowAnimation)animation {
  
  [sections enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL * _Nonnull stop) {
    [self fb_removeCacheContentViewsAtSection:idx];
  }];
  
  [self fb_deleteSections:sections withRowAnimation:animation];
  
}

- (void)fb_reloadSections:(NSIndexSet *)sections withRowAnimation:(UITableViewRowAnimation)animation {
  [sections enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL * _Nonnull stop) {
    [self fb_reloadCacheContentViewsAtSection:idx];
  }];
  [self fb_reloadSections:sections withRowAnimation:animation];
}

- (void)fb_moveSection:(NSInteger)section toSection:(NSInteger)newSection {
  [self fb_moveCacheContentViewsSection:section toSection:newSection];
  [self fb_moveSection:section toSection:newSection];
}

- (void)fb_insertRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation {
  
  [indexPaths enumerateObjectsUsingBlock:^(NSIndexPath * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
    [self fb_addCacheContentViewsAtIndexPath:obj];
  }];
  [self fb_insertRowsAtIndexPaths:indexPaths withRowAnimation:animation];
}

- (void)fb_deleteRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation {
  
  [indexPaths enumerateObjectsUsingBlock:^(NSIndexPath * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
    [self fb_removeCacheContentViewAtIndexPath:obj];
  }];
  
  [self fb_deleteRowsAtIndexPaths:indexPaths withRowAnimation:animation];
  
}

- (void)fb_reloadRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation {
  [indexPaths enumerateObjectsUsingBlock:^(NSIndexPath * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
    [self fb_reloadCacheContentViewsAtIndexPath:obj];
  }];
  [self fb_reloadRowsAtIndexPaths:indexPaths withRowAnimation:animation];
}

- (void)fb_moveRowAtIndexPath:(NSIndexPath *)indexPath toIndexPath:(NSIndexPath *)newIndexPath {
  [self fb_moveCacheContentViewsAtIndexPath:indexPath toIndexPath:newIndexPath];
  [self fb_moveRowAtIndexPath:indexPath toIndexPath:newIndexPath];
}

@end
