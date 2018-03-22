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

#define CACHE_CONTENT_VIEW objc_getAssociatedObject(self, @selector(fb_cacheContentView:))

#define CACHE_LAYOUT objc_getAssociatedObject(self, @"fb_cacheLayout")

static NSInteger contentViewTag = 6868;

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

- (void)setFb_cacheLayout:(BOOL)fb_cacheLayout {
  
  if (fb_cacheLayout) {
    self.fb_cacheContentView = NO;
  } else {
    NSMutableArray <NSMutableArray *>*cacheLayout = CACHE_LAYOUT;
    [cacheLayout removeAllObjects];
  }
  objc_setAssociatedObject(self, _cmd, @(fb_cacheLayout), OBJC_ASSOCIATION_RETAIN_NONATOMIC);

}

- (BOOL)fb_cacheLayout {
  return [objc_getAssociatedObject(self, @selector(setFb_cacheLayout:)) boolValue];;

}


- (void)setFb_cacheContentView:(BOOL)fb_cacheContentView {
  if (fb_cacheContentView) {
    self.fb_cacheLayout = NO;
  } else {
     NSMutableArray <NSMutableArray *>*cacheContentViews = CACHE_CONTENT_VIEW;
    [cacheContentViews removeAllObjects];
  }
  objc_setAssociatedObject(self, _cmd, @(fb_cacheContentView), OBJC_ASSOCIATION_RETAIN_NONATOMIC);

}

- (BOOL)fb_cacheContentView {
  return objc_getAssociatedObject(self, @selector(setFb_cacheContentView:)) ? [ objc_getAssociatedObject(self, @selector(setFb_cacheContentView:)) boolValue] :YES;
}

- (CGFloat)fb_heightForIndexPath:(NSIndexPath *)indexPath {
  NSMutableArray <NSMutableArray *>*cacheLayout = CACHE_LAYOUT;
  FBViewLayoutCache *viewLayoutCache = nil;
  if (self.fb_cacheLayout) {
    if (cacheLayout.count > indexPath.section) {
      NSArray* sectionCacheViews = cacheLayout[indexPath.section];
      
      if (sectionCacheViews.count > indexPath.row) {
        viewLayoutCache = sectionCacheViews[indexPath.row];
      }
      
    }
    if (viewLayoutCache) {
     return viewLayoutCache.frame.size.height;
    }
  }

  return [self fb_cacheContentView:indexPath].frame.size.height;
}

- (UITableViewCell *)fb_cellForIndexPath:(NSIndexPath *)indexPath {
  return [self fb_cacheCellForIndexPath:indexPath];
}

- (UIView *)fb_contentViewForIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell = [self cellForRowAtIndexPath:indexPath];
  return [cell.contentView viewWithTag:contentViewTag];
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
  cell.fb_drawsAsynchronously = YES;
  cellContentView.fb_drawsAsynchronously = YES;
  cell.selectionStyle = cellContentView.fb_selectionStyle;
  cell.backgroundColor = cellContentView.backgroundColor;
  cell.clipsToBounds = cellContentView.clipsToBounds;
  [self fb_configContentView:cellContentView forCell:cell];
  
  return cell;
}


- (UIView *)fb_cacheContentView:(NSIndexPath *)indexPath {
  
  NSMutableArray <NSMutableArray *>*cacheContentViews = CACHE_CONTENT_VIEW;
  NSMutableArray <NSMutableArray *>*cacheLayout = CACHE_LAYOUT;
  
  if (!cacheContentViews) {
    cacheContentViews = [NSMutableArray array];
    objc_setAssociatedObject(self, _cmd, cacheContentViews, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fb_removeAllCache) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
  }
  
  if (!cacheLayout) {
    cacheLayout = [NSMutableArray array];
    objc_setAssociatedObject(self, @"fb_cacheLayout", cacheLayout, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
  }
  
  UIView * cellContentView = nil;
  NSMutableArray* sectionContentViews = nil;
  
  if (self.fb_cacheContentView) {
    if (cacheContentViews.count > indexPath.section) {
      
      sectionContentViews = cacheContentViews[indexPath.section];
      
      if (sectionContentViews.count > indexPath.row) {
        cellContentView = sectionContentViews[indexPath.row];
      }
      
    } else {
      
      NSAssert(cacheContentViews.count == indexPath.section, @"%@ section is error",@(indexPath.section));
      
      cacheContentViews[indexPath.section] = [NSMutableArray array];
      
    }
  }
  

  if (!cellContentView || [cellContentView isEqual:[NSNull null]]) {
    
    FBCellBlock cellBlock = objc_getAssociatedObject(self, @selector(fb_setCellContnetViewBlockForIndexPath:));
    
    if (cellBlock) {
      cellContentView = cellBlock(indexPath);
      FBViewLayoutCache *viewLayoutCache = nil;
      if (self.fb_cacheLayout) {
        if (cacheLayout.count > indexPath.section) {
          NSArray* sectionCacheViews = cacheLayout[indexPath.section];
          
          if (sectionCacheViews.count > indexPath.row) {
            viewLayoutCache = sectionCacheViews[indexPath.row];
          }
          
        } else {
          
          NSAssert(cacheLayout.count == indexPath.section, @"%@ section is error",@(indexPath.section));
          
          cacheLayout[indexPath.section] = [NSMutableArray array];
          
        }
      }
      if (viewLayoutCache) {
        [cellContentView.fb_layout applyLayoutCache:viewLayoutCache];
      } else {
        [cellContentView fb_applyLayouWithSize:CGSizeMake(self.fb_constrainedWidth?:self.frame.size.width, fb_undefined)];
        if (self.fb_cacheLayout) {
          [cacheLayout[indexPath.section] insertObject:[cellContentView.fb_layout layoutCache] atIndex:indexPath.row];
        }
      }

    } else {
      cellContentView = [UIView new];
    }
    
    
    if (self.fb_cacheContentView) {
      [cacheContentViews[indexPath.section] insertObject:cellContentView atIndex:indexPath.row];
    }
    
  }
  
  cellContentView.tag = contentViewTag;
  
  return cellContentView;
}

- (void)fb_removeAllCache {
  [self fb_removeAllCacheContentViews];
}


- (void)fb_removeAllCacheContentViews {
  [CACHE_CONTENT_VIEW removeAllObjects];
  [CACHE_LAYOUT removeAllObjects];
}

- (void)fb_removeCacheContentViewsAtSection:(NSUInteger)section {
  if (self.fb_cacheContentView) {
    [CACHE_CONTENT_VIEW removeObjectAtIndex:section];
  } else if (self.fb_cacheLayout) {
    [CACHE_LAYOUT removeObjectAtIndex:section];
  }
}

- (void)fb_removeCacheContentViewAtIndexPath:(NSIndexPath *)indexPath {
  if (self.fb_cacheContentView) {
    [CACHE_CONTENT_VIEW[indexPath.section] removeObjectAtIndex:indexPath.row];
  } else if(self.fb_cacheLayout) {
    [CACHE_LAYOUT[indexPath.section] removeObjectAtIndex:indexPath.row];
  }
}

- (void)fb_addCacheContentViewsAtSection:(NSUInteger)section {
  
  if (self.fb_cacheContentView) {
    [CACHE_CONTENT_VIEW insertObject:[NSMutableArray array] atIndex:section];
  } else if(self.fb_cacheLayout) {
    [CACHE_LAYOUT insertObject:[NSMutableArray array] atIndex:section];
  }
  
}

- (void)fb_addCacheContentViewsAtIndexPath:(NSIndexPath *)indexPath {
  if (self.fb_cacheContentView) {
    [CACHE_CONTENT_VIEW[indexPath.section] insertObject:[NSNull null] atIndex:indexPath.row];
  } else if(self.fb_cacheLayout) {
    [CACHE_LAYOUT[indexPath.section] insertObject:[NSNull null] atIndex:indexPath.row];
  }

}

- (void)fb_reloadCacheContentViewsAtSection:(NSUInteger)section {
  if (self.fb_cacheContentView) {
    [CACHE_CONTENT_VIEW[section] removeAllObjects];
  } else if (self.fb_cacheLayout) {
    [CACHE_LAYOUT[section] removeAllObjects];
  }
}

- (void)fb_reloadCacheContentViewsAtIndexPath:(NSIndexPath *)indexPath {
  if (self.fb_cacheContentView) {
    [CACHE_CONTENT_VIEW[indexPath.section] replaceObjectAtIndex:indexPath.row withObject:[NSNull null]];
  } else if (self.fb_cacheLayout) {
    [CACHE_LAYOUT[indexPath.section] replaceObjectAtIndex:indexPath.row withObject:[NSNull null]];
  }
}

- (void)fb_moveCacheContentViewsSection:(NSInteger)section toSection:(NSInteger)newSection {
  if (self.fb_cacheContentView) {
    [CACHE_CONTENT_VIEW exchangeObjectAtIndex:section withObjectAtIndex:newSection];
  } else if(self.fb_cacheLayout) {
    [CACHE_LAYOUT exchangeObjectAtIndex:section withObjectAtIndex:newSection];
  }
}

- (void)fb_moveCacheContentViewsAtIndexPath:(NSIndexPath *)indexPath toIndexPath:(NSIndexPath *)newIndexPath {
  
  if (self.fb_cacheContentView) {
    
    UIView *view1 = CACHE_CONTENT_VIEW[indexPath.section][indexPath.row];
    
    UIView *view2 = CACHE_CONTENT_VIEW[newIndexPath.section][newIndexPath.row];
    
    CACHE_CONTENT_VIEW[indexPath.section][indexPath.row] = view2;
    
    CACHE_CONTENT_VIEW[newIndexPath.section][newIndexPath.row] = view1;
    
  } else if (self.fb_cacheLayout) {
    
    UIView *view1 = CACHE_LAYOUT[indexPath.section][indexPath.row];
    
    UIView *view2 = CACHE_LAYOUT[newIndexPath.section][newIndexPath.row];
    
    CACHE_LAYOUT[indexPath.section][indexPath.row] = view2;
    
    CACHE_LAYOUT[newIndexPath.section][newIndexPath.row] = view1;
  }
  

  
}

- (void)fb_configContentView:(UIView *)contentView forCell:(UITableViewCell *)cell{
  UIView *removedView = [cell.contentView viewWithTag:contentViewTag];
  [removedView removeFromSuperview];
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

- (void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
