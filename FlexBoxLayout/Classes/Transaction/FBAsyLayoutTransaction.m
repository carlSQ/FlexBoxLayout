//
//  FBAsyLayoutTransaction.m
//  CSJSView
//
//  Created by 沈强 on 2016/8/31.
//  Copyright © 2016年 沈强. All rights reserved.
//

#import "FBAsyLayoutTransaction.h"
#import <objc/message.h>
#import <libkern/OSSpinLockDeprecated.h>
#import <os/lock.h>

static NSMutableArray *messageQueue = nil;

static CFRunLoopSourceRef _runLoopSource = nil;

static dispatch_queue_t calculate_creation_queue() {
  static dispatch_queue_t calculate_creation_queue;
  static dispatch_once_t creationOnceToken;
  dispatch_once(&creationOnceToken, ^{
    calculate_creation_queue = dispatch_queue_create("flexbox.calculateLayout", DISPATCH_QUEUE_SERIAL);
  });
  
  return calculate_creation_queue;
}

static void display_Locked(dispatch_block_t block) {
  
  if ([UIDevice currentDevice].systemVersion.floatValue >= 10.0) {
    
    static os_unfair_lock lockToken = OS_UNFAIR_LOCK_INIT;
    
    os_unfair_lock_lock(&lockToken);
    
    block();
    
    os_unfair_lock_unlock(&lockToken);
    
  } else {
    
#pragma clang diagnostic push
    
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    
    static OSSpinLock lockToken = OS_SPINLOCK_INIT;
    
    OSSpinLockLock(&lockToken);
    
    block();
    
    OSSpinLockUnlock(&lockToken);
    
#pragma clang diagnostic pop
  }

}


static void enqueue(dispatch_block_t block) {
  display_Locked(^() {
    if (!messageQueue) {
      messageQueue = [NSMutableArray array];
    }
    [messageQueue addObject:block];
    CFRunLoopSourceSignal(_runLoopSource);
    CFRunLoopWakeUp(CFRunLoopGetMain());
  });
}

static void processQueue() {
  display_Locked(^{
    for (dispatch_block_t block in messageQueue) {
      block();
    }
    [messageQueue removeAllObjects];
  });
}


static void calculate_create_task_safely(dispatch_block_t block, dispatch_block_t complete) {
  dispatch_async(calculate_creation_queue(), ^ {
    block();
    enqueue(complete);
  });
}

static void sourceContextCallBackLog(void *info) {
  
#if DEBUG
  
  NSLog(@"applay FlexBox layout");
  
#endif
  
}


static void _messageGroupRunLoopObserverCallback(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info) {
  
  processQueue();
  
}

#define MAX_CONCURRENT_COUNT 8

static dispatch_semaphore_t FBConcurrentSemaphore;

static dispatch_queue_t display_creation_queue() {
  static dispatch_queue_t dispalyQueue = NULL;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    dispalyQueue = dispatch_queue_create("flexbox.display", DISPATCH_QUEUE_CONCURRENT);
    dispatch_set_target_queue(dispalyQueue, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0));
  });
  return dispalyQueue;
}

static void display_create_task_safely(dispatch_block_t displayBlock, dispatch_block_t complete) {
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    NSUInteger processorCount = [NSProcessInfo processInfo].activeProcessorCount;
    NSUInteger maxConcurrentCount = processorCount <= MAX_CONCURRENT_COUNT ? processorCount : MAX_CONCURRENT_COUNT;
    FBConcurrentSemaphore = dispatch_semaphore_create(maxConcurrentCount);
  });
  
  dispatch_async(display_creation_queue(), ^{
    dispatch_semaphore_wait(FBConcurrentSemaphore, DISPATCH_TIME_FOREVER);
    displayBlock();
    enqueue(complete);
    dispatch_semaphore_signal(FBConcurrentSemaphore);
  });
}


@implementation FBAsyLayoutTransaction

+ (void)load {
  
  CFRunLoopObserverRef observer;
  
  CFRunLoopRef runLoop = CFRunLoopGetMain();
  
  CFOptionFlags activities = (kCFRunLoopBeforeWaiting | kCFRunLoopExit);
  
  observer = CFRunLoopObserverCreate(NULL,
                                     activities,
                                     YES,
                                     INT_MAX,
                                     &_messageGroupRunLoopObserverCallback,
                                     NULL);
  
  if (observer) {
    CFRunLoopAddObserver(runLoop, observer, kCFRunLoopCommonModes);
    CFRelease(observer);
  }
  
  CFRunLoopSourceContext  *sourceContext = calloc(1, sizeof(CFRunLoopSourceContext));
  
  sourceContext->perform = &sourceContextCallBackLog;
  
   _runLoopSource = CFRunLoopSourceCreate(NULL, 0, sourceContext);
  
  if (_runLoopSource) {
    CFRunLoopAddSource(runLoop, _runLoopSource, kCFRunLoopCommonModes);
  }
  
}

+ (void)addCalculateTransaction:(dispatch_block_t)transaction
                       complete:(dispatch_block_t)complete {
  calculate_create_task_safely(transaction, complete);
}

+ (void)addDisplayTransaction:(dispatch_block_t)transaction
                     complete:(dispatch_block_t)complete {
  display_create_task_safely(transaction, complete);
}

@end
