//
// NSTimer+WtExtension.m
// WtCore
//
// Created by wtfan on 2020/2/4.
// Copyright © 2020 wtfan.
//
// This source code is licensed under the MIT-style license found in the
// LICENSE file in the root directory of this source tree.
//

#import "NSTimer+WtExtension.h"

#import <objc/runtime.h>

#import "WtEXTScope.h"
#import "WtDeallocWatcher.h"
#import "WtDelegateProxy.h"


@protocol _WtTimerProtocol <NSObject>
- (void)wtTimer:(NSTimer *)timer;
@end

@implementation NSTimer (WtAutoInvalidate)

- (void)wtAutoInvalidateWhenOwnerDealloc:(id)owner {
  NSParameterAssert(owner);
  WtDeallocWatcher *deallocWatcher = objc_getAssociatedObject(owner, _cmd);
  if (!deallocWatcher) {
    deallocWatcher = [WtDeallocWatcher watcher:^(id _) {
      [self invalidate];
    } owner:owner];
    objc_setAssociatedObject(owner, _cmd, deallocWatcher, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
  }
}

+ (NSTimer *)wtTimerWithTimeInterval:(NSTimeInterval)interval target:(id)aTarget selector:(SEL)aSelector userInfo:(nullable id)userInfo repeats:(BOOL)repeats {
  @weakify(aTarget);
  return [NSTimer wtTimerWithTimeInterval:interval repeats:repeats autoInvalidateWhenOwnerDealloc:aTarget block:^(NSTimer * _Nullable timer) {
    @strongify(aTarget);
    if (aTarget && [aTarget respondsToSelector:aSelector]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
      [aTarget performSelector:aSelector withObject:timer];
#pragma clang diagnostic pop
    }
  }];
}

+ (NSTimer *)wtScheduledTimerWithTimeInterval:(NSTimeInterval)interval target:(id)aTarget selector:(SEL)aSelector userInfo:(nullable id)userInfo repeats:(BOOL)repeats {
  @weakify(aTarget);
  return [NSTimer wtScheduledTimerWithTimeInterval:interval repeats:repeats autoInvalidateWhenOwnerDealloc:aTarget block:^(NSTimer * _Nonnull timer) {
    @strongify(aTarget);
    if (aTarget && [aTarget respondsToSelector:aSelector]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
      [aTarget performSelector:aSelector withObject:timer];
#pragma clang diagnostic pop
    }
  }];
}

+ (NSTimer *_Nonnull)wtTimerWithTimeInterval:(NSTimeInterval)interval repeats:(BOOL)repeats autoInvalidateWhenOwnerDealloc:(_Nonnull id)owner block:(void (^_Nullable)(NSTimer * _Nullable timer))block {
  // avoiding cyclical references.
  WtDelegateProxy<_WtTimerProtocol> *proxy = (WtDelegateProxy<_WtTimerProtocol> *)[[WtDelegateProxy alloc] initWithProtocol:@protocol(_WtTimerProtocol)];
  [proxy selector:@selector(wtTimer:) block:^(NSTimer *timer) {
    if (block) {
      block(timer);
    }
  }];
  NSTimer *timer = [NSTimer timerWithTimeInterval:interval target:proxy selector:@selector(wtTimer:) userInfo:nil repeats:repeats];
  [timer wtAutoInvalidateWhenOwnerDealloc:owner];
  return timer;
}

+ (NSTimer *_Nonnull)wtScheduledTimerWithTimeInterval:(NSTimeInterval)interval repeats:(BOOL)repeats autoInvalidateWhenOwnerDealloc:(_Nonnull id)owner block:(void (^_Nullable)(NSTimer * _Nonnull timer))block {
  // avoiding cyclical references.
  WtDelegateProxy<_WtTimerProtocol> *proxy = (WtDelegateProxy<_WtTimerProtocol> *)[[WtDelegateProxy alloc] initWithProtocol:@protocol(_WtTimerProtocol)];
  [proxy selector:@selector(wtTimer:) block:^(NSTimer *timer) {
    if (block) {
      block(timer);
    }
  }];
  NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:interval target:proxy selector:@selector(wtTimer:) userInfo:nil repeats:repeats];
  [timer wtAutoInvalidateWhenOwnerDealloc:owner];
  return timer;
}
@end
