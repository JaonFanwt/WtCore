//
// NSObject+WtKVO.m
// WtCore
//
// Created by wtfan on 2017/11/23.
// Copyright © 2017 wtfan.
//
// This source code is licensed under the MIT-style license found in the
// LICENSE file in the root directory of this source tree.
//

#import "NSObject+WtKVO.h"

#import <objc/runtime.h>
#import <objc/message.h>

#import "WtEXTScope.h"
#import "WtKVOProxy.h"
#import "WtDeallocWatcher.h"


@protocol WtKVODelegate <NSObject>

/// Callback returns the changed value.
/// @param value The changed value.
- (void)valueChanged:(id)value;

@end

@implementation NSObject (WtKVO)

- (void)wtRemoveAllObserves {
  [[WtKVOProxy shared] wtRemoveObserverForContext:(__bridge void *)self];
  objc_setAssociatedObject(self, @selector(wtKVOLock), nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
  objc_setAssociatedObject(self, @selector(wtKVOContextMapping), nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (dispatch_semaphore_t)wtKVOLock {
  dispatch_semaphore_t _lock = objc_getAssociatedObject(self, _cmd);
  if (!_lock) {
    _lock = dispatch_semaphore_create(1);
    objc_setAssociatedObject(self, _cmd, _lock, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
  }
  return _lock;
}

- (NSMutableDictionary *)wtKVOContextMapping {
  NSMutableDictionary *mapping = objc_getAssociatedObject(self, _cmd);
  if (!mapping) {
    mapping = @{}.mutableCopy;
    objc_setAssociatedObject(self, _cmd, mapping, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
  }
  return mapping;
}

- (void)wtEnqueueKVOKeyPath:(NSString *)keyPath delegateProxy:(WtDelegateProxy<WtKVODelegate> *)delegateProxy {
  if (!delegateProxy) return;
  
  NSMutableDictionary *mapping = [self wtKVOContextMapping];
  NSMutableDictionary<id, id> *keyPathContextMapping = mapping[keyPath];
  if (!keyPathContextMapping) {
    keyPathContextMapping = [[NSMutableDictionary alloc] initWithCapacity:3];
    mapping[keyPath] = keyPathContextMapping;
  }
  NSMutableDictionary<NSValue *, WtDelegateProxy<WtKVODelegate> *> *delegateProxies = keyPathContextMapping[@"proxies"];
  if (!delegateProxies) {
    delegateProxies = [[NSMutableDictionary alloc] initWithCapacity:3];
    keyPathContextMapping[@"proxies"] = delegateProxies;
  }
  NSValue *pointValue = [NSValue valueWithPointer:(__bridge void *)(delegateProxy)];
  delegateProxies[pointValue] = delegateProxy;
}

- (void)wtDequeueKVOKeyPath:(NSString *)keyPath delegateProxy:(WtDelegateProxy<WtKVODelegate> *)delegateProxy {
  if (!delegateProxy) return;
  
  NSMutableDictionary *mapping = [self wtKVOContextMapping];
  NSMutableDictionary<id, id> *keyPathContextMapping = mapping[keyPath];
  if (!keyPathContextMapping) {
    return;
  }
  NSMutableDictionary<NSValue *, WtDelegateProxy<WtKVODelegate> *> *delegateProxies = keyPathContextMapping[@"proxies"];
  if (!delegateProxies) {
    return;
  }
  NSValue *pointValue = [NSValue valueWithPointer:(__bridge void *)(delegateProxy)];
  [delegateProxies removeObjectForKey:pointValue];
}

- (WtDelegateProxy<WtKVOProxyDelegate> *)wtKVODelegateProxy {
  WtDelegateProxy<WtKVOProxyDelegate> *delegateProxy = objc_getAssociatedObject(self, _cmd);
  if (!delegateProxy) {
    delegateProxy = (WtDelegateProxy<WtKVOProxyDelegate> *)[[WtDelegateProxy alloc] initWithProtocol:@protocol(WtKVOProxyDelegate)];
    objc_setAssociatedObject(self, _cmd, delegateProxy, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    @weakify(self);
    [delegateProxy selector:@selector(wtKVOObserveValueForKeyPath:ofObject:change:context:) block:^(NSString *keyPath, id object, NSDictionary *change, void *context) {
      @strongify(self);
      @autoreleasepool {
        dispatch_semaphore_t _lock = [self wtKVOLock];
        dispatch_semaphore_wait(_lock, DISPATCH_TIME_FOREVER);
        NSMutableDictionary *mapping = [self wtKVOContextMapping];
        NSMutableDictionary<id, id> *keyPathContextMapping = mapping[keyPath];
        NSArray<WtDelegateProxy<WtKVODelegate> *> *delegateProxies = [keyPathContextMapping[@"proxies"] allValues];
        dispatch_semaphore_signal(_lock);
        [delegateProxies enumerateObjectsUsingBlock:^(WtDelegateProxy<WtKVODelegate> * _Nonnull kvoDelegate, NSUInteger idx, BOOL * _Nonnull stop) {
          [kvoDelegate valueChanged:change[@"new"]];
        }];
      }
    }];
  }
  return delegateProxy;
}

- (WtKVOValueChangedBlock _Nonnull)wtObserveValueForKeyPath:(NSString *)keyPath
                                          valueChangedBlock:(WtKVOValueChangedBlock _Nonnull)valueChangedBlock {
  return [self wtObserveValueForKeyPath:keyPath valueChangedBlock:valueChangedBlock takeUntilTargetDealloc:nil];
}

- (WtKVOValueChangedBlock _Nonnull)wtObserveValueForKeyPath:(NSString *)keyPath
                                          valueChangedBlock:(WtKVOValueChangedBlock _Nonnull)valueChangedBlock
                                     takeUntilTargetDealloc:(id)target {
  return [self wtObserveValueForKeyPath:keyPath valueChangedBlock:valueChangedBlock takeUntilTargetDealloc:target replace:NO];
}

- (WtKVOValueChangedBlock _Nonnull)wtObserveValueForKeyPath:(NSString *_Nonnull)keyPath
                                          valueChangedBlock:(WtKVOValueChangedBlock _Nonnull)valueChangedBlock
                                     takeUntilTargetDealloc:(id _Nullable)target
                                                    replace:(BOOL)replace {
  dispatch_semaphore_t _lock = [self wtKVOLock];
  dispatch_semaphore_wait(_lock, DISPATCH_TIME_FOREVER);
  
  NSMutableDictionary *mapping = [self wtKVOContextMapping];
  NSMutableDictionary<id, id> *keyPathContextMapping = mapping[keyPath];
  NSMutableDictionary<NSValue *, WtDelegateProxy<WtKVODelegate> *> *delegateProxies = keyPathContextMapping[@"proxies"];
  
  if (!delegateProxies) {
    [self addObserver:WtKVOProxy.shared forKeyPath:keyPath options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:(__bridge void *)self];
  } else {
  }
  
  if (replace) {
    NSString *reuseKeyPath = [NSString stringWithFormat:@"%@_%p", keyPath, target];
    NSMutableDictionary<NSString *, id> *mapping = keyPathContextMapping[@"target_proxies"];
    WtDelegateProxy<WtKVODelegate> *kvoDelegate = mapping[reuseKeyPath];
    if (kvoDelegate) {
      [self wtDequeueKVOKeyPath:keyPath delegateProxy:kvoDelegate];
      [mapping removeObjectForKey:reuseKeyPath];
    }
  }
  
  WtDelegateProxy<WtKVODelegate> *kvoDelegate = (WtDelegateProxy<WtKVODelegate> *)[[WtDelegateProxy alloc] initWithProtocol:@protocol(WtKVODelegate)];
  [kvoDelegate selector:@selector(valueChanged:) block:valueChangedBlock];
  [self wtEnqueueKVOKeyPath:keyPath delegateProxy:kvoDelegate];
  
  if (replace) {
    NSString *reuseKeyPath = [NSString stringWithFormat:@"%@_%p", keyPath, target];
    NSMutableDictionary<NSString *, id> *mapping = keyPathContextMapping[@"target_proxies"];
    if (!mapping) {
      mapping = @{}.mutableCopy;
      keyPathContextMapping[@"target_proxies"] = mapping;
    }
    mapping[reuseKeyPath] = kvoDelegate;
  }
  dispatch_semaphore_signal(_lock);
  
  [[WtKVOProxy shared] wtAddObserver:[self wtKVODelegateProxy] keyPath:keyPath forContext:(__bridge void *)self];
  if (target) {
    NSString *reuseKeyPath = [NSString stringWithFormat:@"%@_%p", keyPath, target];
    @weakify(self);
    WtDeallocWatcher *deallocWatcher = [WtDeallocWatcher watcher:^() {
      @strongify(self);
      if (!self) {
        return;
      }
      dispatch_semaphore_t _lock = [self wtKVOLock];
      dispatch_semaphore_wait(_lock, DISPATCH_TIME_FOREVER);
      
      [self wtDequeueKVOKeyPath:keyPath delegateProxy:kvoDelegate];
      
      if (replace) {
        NSMutableDictionary<NSString *, id> *mapping = keyPathContextMapping[@"target_proxies"];
        mapping[reuseKeyPath] = nil;
      }
      
      dispatch_semaphore_signal(_lock);
    }];
    objc_setAssociatedObject(target, [NSString stringWithFormat:@"%.0f_dealloc_watcher", CFAbsoluteTimeGetCurrent() * 1000].UTF8String, deallocWatcher, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
  }
  
  [self wtAutoRemoveObserver];
  
  return valueChangedBlock;
}

- (void)wtAutoRemoveObserver {
  WtDeallocWatcher *deallocWatcher = objc_getAssociatedObject(self, _cmd);
  if (!deallocWatcher) {
    void *selfPointer = (__bridge void *)self;
    deallocWatcher = [WtDeallocWatcher watcher:^() {
      [[WtKVOProxy shared] wtRemoveObserverForContext:selfPointer];
    }];
    objc_setAssociatedObject(self, _cmd, deallocWatcher, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
  }
}

@end
