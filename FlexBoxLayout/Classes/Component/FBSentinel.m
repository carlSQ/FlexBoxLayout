//
//  FBSentinel.m
//  Pods
//
//  Created by 沈强 on 2017/3/1.
//
//

#import "FBSentinel.h"
#import <libkern/OSAtomic.h>

@implementation FBSentinel {
  int32_t _value;
}

- (int32_t)value
{
  return _value;
}

- (int32_t)increase {
  return OSAtomicIncrement32(&_value);
}


@end
