//
//  FBLayer.m
//  Pods
//
//  Created by 沈强 on 2017/2/26.
//
//

#import "FBLayer.h"
#import "FBAsyLayoutTransaction.h"
#import "FBSentinel.h"

typedef UIImage * _Nonnull(^FBDisplayBlock)(CGRect bounds, BOOL(^isCancelled)(void));

@implementation FBLayer {
  FBSentinel *_sentinel;
}

- (void)display {
  [self _displayAsync:YES];
}

- (void)_displayAsync:(BOOL)async {
  
  CGRect displayBounds = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
  FBDisplayBlock displayBlock = ^UIImage* (CGRect bounds, BOOL(^isCancelled)(void)) {
    if (isCancelled()) {
      return nil;
    }
    
    BOOL opaque = self.opaque && CGColorGetAlpha(self.backgroundColor) == 1.0f;
    
    UIGraphicsBeginImageContextWithOptions(bounds.size, opaque, 0.0);
    
    if (isCancelled()) {
      UIGraphicsEndImageContext();
      return nil;
    }
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
  };
  
  if (async) {
    
    FBSentinel *sentinel = _sentinel;
    int32_t value = sentinel.value;
    
    BOOL (^isCancelled)() = ^BOOL() {
      return value != sentinel.value;
    };
     __block UIImage *image = nil;
    [FBAsyLayoutTransaction addDisplayTransaction:^{
      if (isCancelled()) {
        return ;
      }
     image = displayBlock(displayBounds, isCancelled);
    } complete:^{
      if (isCancelled()) {
        return;
      }
      self.contents = (id)(image.CGImage);
    }];
  } else {
    UIImage *image = displayBlock(displayBounds, ^BOOL(){
      return NO;
    });
    
    self.contents = (id)image.CGImage;
  }
}


@end
