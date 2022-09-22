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

#import "WtSwizzle.h"
#import "WtEXTScope.h"
#import "WtKVOProxy.h"
#import "WtDeallocWatcher.h"

typedef void (^WtKVOHookBeforePrepareForReuseBlock)(void);

@interface WtKVOHookBeforePrepareForReuse : NSObject
@property (nonatomic, copy) WtKVOHookBeforePrepareForReuseBlock block;
@end

@implementation WtKVOHookBeforePrepareForReuse

@end

@interface UITableViewCell (WtKVO)
- (NSMutableArray<WtKVOHookBeforePrepareForReuse *> *)wtKVOHookBeforePrepareForReuseBlocks;
- (void)insertWtKvoHookBeforePrepareForReuseBlock:(WtKVOHookBeforePrepareForReuse *)block;
@end

@implementation UITableViewCell (WtKVO)

+ (void)load {
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    wt_swizzleSelector(self.class, @selector(prepareForReuse), @selector(swizzle_wtkvo_prepareForReuse));
  });
}

- (NSMutableArray<WtKVOHookBeforePrepareForReuse *> *)wtKVOHookBeforePrepareForReuseBlocks {
  NSMutableArray<WtKVOHookBeforePrepareForReuse *> *blocks = objc_getAssociatedObject(self, _cmd);
  if (!blocks) {
    blocks = @[].mutableCopy;
    objc_setAssociatedObject(self, _cmd, blocks, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
  }
  return blocks;
}

- (void)insertWtKvoHookBeforePrepareForReuseBlock:(WtKVOHookBeforePrepareForReuse *)block {
  [[self wtKVOHookBeforePrepareForReuseBlocks] addObject:block];
}

- (void)swizzle_wtkvo_prepareForReuse {
  for (WtKVOHookBeforePrepareForReuse *block in [self wtKVOHookBeforePrepareForReuseBlocks]) {
    if (block.block) {
      block.block();
    }
  }
  [[self wtKVOHookBeforePrepareForReuseBlocks] removeAllObjects];
  [self swizzle_wtkvo_prepareForReuse];
}

@end

@interface UICollectionReusableView (WtKVO)
- (NSMutableArray<WtKVOHookBeforePrepareForReuse *> *)wtKVOHookBeforePrepareForReuseBlocks;
- (void)insertWtKvoHookBeforePrepareForReuseBlock:(WtKVOHookBeforePrepareForReuse *)block;
@end

@implementation UICollectionReusableView (WtKVO)

+ (void)load {
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    wt_swizzleSelector(self.class, @selector(prepareForReuse), @selector(swizzle_wtkvo_prepareForReuse));
  });
}

- (NSMutableArray<WtKVOHookBeforePrepareForReuse *> *)wtKVOHookBeforePrepareForReuseBlocks {
  NSMutableArray<WtKVOHookBeforePrepareForReuse *> *blocks = objc_getAssociatedObject(self, _cmd);
  if (!blocks) {
    blocks = @[].mutableCopy;
    objc_setAssociatedObject(self, _cmd, blocks, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
  }
  return blocks;
}

- (void)insertWtKvoHookBeforePrepareForReuseBlock:(WtKVOHookBeforePrepareForReuse *)block {
  [[self wtKVOHookBeforePrepareForReuseBlocks] addObject:block];
}

- (void)swizzle_wtkvo_prepareForReuse {
  for (WtKVOHookBeforePrepareForReuse *block in [self wtKVOHookBeforePrepareForReuseBlocks]) {
    if (block.block) {
      block.block();
    }
  }
  [self swizzle_wtkvo_prepareForReuse];
}

@end


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

- (void)wtClearAllDelegateProxyWithKVOKeyPath:(NSString *)keyPath {
  NSMutableDictionary *mapping = [self wtKVOContextMapping];
  [mapping removeObjectForKey:keyPath];
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

- (WtKVOValueChangedBlock _Nonnull)wtObserveValueForKeyPath:(NSString *_Nonnull)keyPath
                                          valueChangedBlock:(WtKVOValueChangedBlock _Nonnull)valueChangedBlock
                                     takeUntilTargetDealloc:(id _Nullable)target {
  dispatch_semaphore_t _lock = [self wtKVOLock];
  dispatch_semaphore_wait(_lock, DISPATCH_TIME_FOREVER);
  
  NSMutableDictionary *mapping = [self wtKVOContextMapping];
  NSMutableDictionary<id, id> *keyPathContextMapping = mapping[keyPath];
  if (!keyPathContextMapping) {
    keyPathContextMapping = mapping[keyPath] = @{}.mutableCopy;
  }
  NSMutableDictionary<NSValue *, WtDelegateProxy<WtKVODelegate> *> *delegateProxies = keyPathContextMapping[@"proxies"];
  
  if (!delegateProxies) {
    [self addObserver:WtKVOProxy.shared forKeyPath:keyPath options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:(__bridge void *)self];
  } else {
  }
  
  WtDelegateProxy<WtKVODelegate> *kvoDelegate = (WtDelegateProxy<WtKVODelegate> *)[[WtDelegateProxy alloc] initWithProtocol:@protocol(WtKVODelegate)];
  [kvoDelegate selector:@selector(valueChanged:) block:valueChangedBlock];
  [self wtEnqueueKVOKeyPath:keyPath delegateProxy:kvoDelegate];
  
  dispatch_semaphore_signal(_lock);
  
  [[WtKVOProxy shared] wtAddObserver:[self wtKVODelegateProxy] keyPath:keyPath forContext:(__bridge void *)self];
  if (target) {
    @weakify(self);
    WtDeallocWatcher *deallocWatcher = [WtDeallocWatcher watcher:^() {
      @strongify(self);
      if (!self) {
        return;
      }
      dispatch_semaphore_t _lock = [self wtKVOLock];
      dispatch_semaphore_wait(_lock, DISPATCH_TIME_FOREVER);
      
      [self wtDequeueKVOKeyPath:keyPath delegateProxy:kvoDelegate];
      
      dispatch_semaphore_signal(_lock);
    }];
    objc_setAssociatedObject(target, [NSString stringWithFormat:@"%.0f_dealloc_watcher", CFAbsoluteTimeGetCurrent() * 1000].UTF8String, deallocWatcher, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
  }
  
  [self wtAutoRemoveObserver];
  
  return valueChangedBlock;
}

- (WtKVOValueChangedBlock _Nonnull)wtObserveValueForKeyPath:(NSString *_Nonnull)keyPath
                                          valueChangedBlock:(WtKVOValueChangedBlock _Nonnull)valueChangedBlock
                          takeUntilTableCellPrepareForReuse:(UITableViewCell *_Nonnull)cell {
  dispatch_semaphore_t _lock = [self wtKVOLock];
  dispatch_semaphore_wait(_lock, DISPATCH_TIME_FOREVER);
  
  NSMutableDictionary *mapping = [self wtKVOContextMapping];
  NSMutableDictionary<id, id> *keyPathContextMapping = mapping[keyPath];
  if (!keyPathContextMapping) {
    keyPathContextMapping = mapping[keyPath] = @{}.mutableCopy;
  }
  NSMutableDictionary<NSValue *, WtDelegateProxy<WtKVODelegate> *> *delegateProxies = keyPathContextMapping[@"proxies"];
  
  if (!delegateProxies) {
    [self addObserver:WtKVOProxy.shared forKeyPath:keyPath options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:(__bridge void *)self];
  } else {
  }
  
  WtDelegateProxy<WtKVODelegate> *kvoDelegate = (WtDelegateProxy<WtKVODelegate> *)[[WtDelegateProxy alloc] initWithProtocol:@protocol(WtKVODelegate)];
  [kvoDelegate selector:@selector(valueChanged:) block:valueChangedBlock];
  [self wtEnqueueKVOKeyPath:keyPath delegateProxy:kvoDelegate];
  
  dispatch_semaphore_signal(_lock);
  
  [[WtKVOProxy shared] wtAddObserver:[self wtKVODelegateProxy] keyPath:keyPath forContext:(__bridge void *)self];
  
  @weakify(self);
  WtKVOHookBeforePrepareForReuse *hookBlock = [[WtKVOHookBeforePrepareForReuse alloc] init];
  hookBlock.block = ^(){
    @strongify(self);
    if (!self) {
      return;
    }
    dispatch_semaphore_t _lock = [self wtKVOLock];
    dispatch_semaphore_wait(_lock, DISPATCH_TIME_FOREVER);
    
    [self wtDequeueKVOKeyPath:keyPath delegateProxy:kvoDelegate];
    
    dispatch_semaphore_signal(_lock);
  };
  [cell insertWtKvoHookBeforePrepareForReuseBlock:hookBlock];
  
  [self wtAutoRemoveObserver];
  
  return valueChangedBlock;
}

- (WtKVOValueChangedBlock _Nonnull)wtObserveValueForKeyPath:(NSString *_Nonnull)keyPath
                                          valueChangedBlock:(WtKVOValueChangedBlock _Nonnull)valueChangedBlock
             takeUntilCollectionReusableViewPrepareForReuse:(UICollectionReusableView *_Nonnull)collectionReusableView {
  dispatch_semaphore_t _lock = [self wtKVOLock];
  dispatch_semaphore_wait(_lock, DISPATCH_TIME_FOREVER);
  
  NSMutableDictionary *mapping = [self wtKVOContextMapping];
  NSMutableDictionary<id, id> *keyPathContextMapping = mapping[keyPath];
  if (!keyPathContextMapping) {
    keyPathContextMapping = mapping[keyPath] = @{}.mutableCopy;
  }
  NSMutableDictionary<NSValue *, WtDelegateProxy<WtKVODelegate> *> *delegateProxies = keyPathContextMapping[@"proxies"];
  
  if (!delegateProxies) {
    [self addObserver:WtKVOProxy.shared forKeyPath:keyPath options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:(__bridge void *)self];
  } else {
  }
  
  WtDelegateProxy<WtKVODelegate> *kvoDelegate = (WtDelegateProxy<WtKVODelegate> *)[[WtDelegateProxy alloc] initWithProtocol:@protocol(WtKVODelegate)];
  [kvoDelegate selector:@selector(valueChanged:) block:valueChangedBlock];
  [self wtEnqueueKVOKeyPath:keyPath delegateProxy:kvoDelegate];
  
  dispatch_semaphore_signal(_lock);
  
  [[WtKVOProxy shared] wtAddObserver:[self wtKVODelegateProxy] keyPath:keyPath forContext:(__bridge void *)self];
  
  @weakify(self);
  WtKVOHookBeforePrepareForReuse *hookBlock = [[WtKVOHookBeforePrepareForReuse alloc] init];
  hookBlock.block = ^(){
    @strongify(self);
    if (!self) {
      return;
    }
    dispatch_semaphore_t _lock = [self wtKVOLock];
    dispatch_semaphore_wait(_lock, DISPATCH_TIME_FOREVER);
    
    [self wtDequeueKVOKeyPath:keyPath delegateProxy:kvoDelegate];
    
    dispatch_semaphore_signal(_lock);
  };
  [collectionReusableView insertWtKvoHookBeforePrepareForReuseBlock:hookBlock];
  
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
