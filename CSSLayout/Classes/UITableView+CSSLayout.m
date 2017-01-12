//
//  UITableView+CSSLayout.m
//  Pods
//
//  Created by 沈强 on 2017/1/11.
//
//

#import "UITableView+CSSLayout.h"
#import <objc/runtime.h>
#import "UIView+CellStyle.h"
#import "UIView+CSSLayout.h"

static NSString *kCellIdentifier = @"css_kCellIdentifier";

@implementation UITableView (CSSLayout)

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
    SEL swizzledSelector = NSSelectorFromString([@"css_" stringByAppendingString:NSStringFromSelector(originalSelector)]);
    Method originalMethod = class_getInstanceMethod(self, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(self, swizzledSelector);
    method_exchangeImplementations(originalMethod, swizzledMethod);
  }
  
}

- (void)setCss_constrainedWidth:(CGFloat)css_constrainedWidth {
  objc_setAssociatedObject(self, _cmd, @(css_constrainedWidth), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat)css_constrainedWidth {
  return [objc_getAssociatedObject(self, @selector(setCss_constrainedWidth:)) doubleValue];;
}

- (CGFloat)css_heightForIndexPath:(NSIndexPath *)indexPath {
  return [self css_cacheContentView:indexPath].frame.size.height;
}

- (UITableViewCell *)css_cellForIndexPath:(NSIndexPath *)indexPath {
  return [self css_cacheCellForIndexPath:indexPath];
}

- (void)css_cellBlockForIndexPath:(CSSCellBlock)cellBlock {
  static dispatch_once_t token;
  dispatch_once(&token, ^{
    [self registerClass:[UITableViewCell class] forCellReuseIdentifier:kCellIdentifier];
  });
  objc_setAssociatedObject(self, _cmd, cellBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}


#pragma mark - caches

- (UITableViewCell *)css_cacheCellForIndexPath:(NSIndexPath *)indexPath {
  
  UITableViewCell *cell = [self dequeueReusableCellWithIdentifier:kCellIdentifier forIndexPath:indexPath];
  UIView *cellContentView = [self css_cacheContentView:indexPath];
  
  cell.selectionStyle = cellContentView.css_selectionStyle;
  cell.backgroundColor = cellContentView.backgroundColor;
  cell.clipsToBounds = cellContentView.clipsToBounds;
  [self css_configContentView:cellContentView forCell:cell];
  
  return cell;
}

#define CACHE_CONTENT_VIEW objc_getAssociatedObject(self, @selector(cacheContentView:))

- (UIView *)css_cacheContentView:(NSIndexPath *)indexPath {
  
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
    
    CSSCellBlock cellBlock = objc_getAssociatedObject(self, @selector(css_cellBlockForIndexPath:));
    
    if (cellBlock) {
      cellContentView = cellBlock(indexPath);
      [cellContentView css_applyLayouWithSize:CGSizeMake(self.css_constrainedWidth?:self.frame.size.width, css_undefined)];
    } else {
      cellContentView = [UIView new];
    }
    
    [cacheContentViews[indexPath.section] insertObject:cellContentView atIndex:indexPath.row];
    
  }
  
  return cellContentView;
}


- (void)css_removeAllCacheContentViews {
  NSMutableArray *cacheContentViews = CACHE_CONTENT_VIEW;
  [cacheContentViews removeAllObjects];
}

- (void)css_removeCacheContentViewsAtSection:(NSUInteger)section {
  NSMutableArray *cacheContentViews = CACHE_CONTENT_VIEW;
  [cacheContentViews removeObjectAtIndex:section];
}

- (void)css_removeCacheContentViewAtIndexPath:(NSIndexPath *)indexPath {
  NSMutableArray *cacheContentViews = CACHE_CONTENT_VIEW;
  [cacheContentViews[indexPath.section] removeObjectAtIndex:indexPath.row];
}

- (void)css_addCacheContentViewsAtSection:(NSUInteger)section {
  NSMutableArray *cacheContentViews = CACHE_CONTENT_VIEW;
  [cacheContentViews insertObject:[NSMutableArray array] atIndex:section];
}

- (void)css_addCacheContentViewsAtIndexPath:(NSIndexPath *)indexPath {
  NSMutableArray *cacheContentViews = CACHE_CONTENT_VIEW;
  [cacheContentViews[indexPath.section] insertObject:[NSNull null] atIndex:indexPath.row];
}

- (void)css_reloadCacheContentViewsAtSection:(NSUInteger)section {
  NSMutableArray *cacheContentViews = CACHE_CONTENT_VIEW;
  [cacheContentViews[section] removeAllObjects];
}

- (void)css_reloadCacheContentViewsAtIndexPath:(NSIndexPath *)indexPath {
  NSMutableArray *cacheContentViews = CACHE_CONTENT_VIEW;
  [cacheContentViews[indexPath.section] replaceObjectAtIndex:indexPath.row withObject:[NSNull null]];
}

- (void)css_moveCacheContentViewsSection:(NSInteger)section toSection:(NSInteger)newSection {
  NSMutableArray *cacheContentViews = CACHE_CONTENT_VIEW;
  [cacheContentViews exchangeObjectAtIndex:section withObjectAtIndex:newSection];
}

- (void)css_moveCacheContentViewsAtIndexPath:(NSIndexPath *)indexPath toIndexPath:(NSIndexPath *)newIndexPath {
  NSMutableArray *cacheContentViews = CACHE_CONTENT_VIEW;
  
  UIView *view1 = cacheContentViews[indexPath.section][indexPath.row];
  
  UIView *view2 = cacheContentViews[newIndexPath.section][newIndexPath.row];
  
  cacheContentViews[indexPath.section][indexPath.row] = view2;
  cacheContentViews[newIndexPath.section][newIndexPath.row] = view1;
}

- (void)css_configContentView:(UIView *)contentView forCell:(UITableViewCell *)cell{
  for (UIView *view in cell.contentView.subviews) {
    [view removeFromSuperview];
  }
  [cell.contentView addSubview:contentView];
}

#pragma mark - interceptedSelectors

- (void)css_reloadData {
  [self css_removeAllCacheContentViews];
  [self css_reloadData];
}

- (void)css_insertSections:(NSIndexSet *)sections withRowAnimation:(UITableViewRowAnimation)animation{
  
  [sections enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL * _Nonnull stop) {
    [self css_addCacheContentViewsAtSection:idx];
  }];
  
  [self css_insertSections:sections withRowAnimation:animation];
  
}

- (void)css_deleteSections:(NSIndexSet *)sections withRowAnimation:(UITableViewRowAnimation)animation {
  
  [sections enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL * _Nonnull stop) {
    [self css_removeCacheContentViewsAtSection:idx];
  }];
  
  [self css_deleteSections:sections withRowAnimation:animation];
  
}

- (void)css_reloadSections:(NSIndexSet *)sections withRowAnimation:(UITableViewRowAnimation)animation {
  [sections enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL * _Nonnull stop) {
    [self css_reloadCacheContentViewsAtSection:idx];
  }];
  [self css_reloadSections:sections withRowAnimation:animation];
}

- (void)css_moveSection:(NSInteger)section toSection:(NSInteger)newSection {
  [self css_moveCacheContentViewsSection:section toSection:newSection];
  [self css_moveSection:section toSection:newSection];
}

- (void)css_insertRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation {
  
  [indexPaths enumerateObjectsUsingBlock:^(NSIndexPath * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
    [self css_addCacheContentViewsAtIndexPath:obj];
  }];
  [self css_insertRowsAtIndexPaths:indexPaths withRowAnimation:animation];
}

- (void)css_deleteRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation {
  
  [indexPaths enumerateObjectsUsingBlock:^(NSIndexPath * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
    [self css_removeCacheContentViewAtIndexPath:obj];
  }];
  
  [self css_deleteRowsAtIndexPaths:indexPaths withRowAnimation:animation];
  
}

- (void)css_reloadRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation {
  [indexPaths enumerateObjectsUsingBlock:^(NSIndexPath * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
    [self css_reloadCacheContentViewsAtIndexPath:obj];
  }];
  [self css_reloadRowsAtIndexPaths:indexPaths withRowAnimation:animation];
}

- (void)css_moveRowAtIndexPath:(NSIndexPath *)indexPath toIndexPath:(NSIndexPath *)newIndexPath {
  [self moveRowAtIndexPath:indexPath toIndexPath:newIndexPath];
  [self css_moveRowAtIndexPath:indexPath toIndexPath:newIndexPath];
}

@end
