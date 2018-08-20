//
//  NSObject+WtKVO.m
//  WtCore
//
//  Created by wtfan on 2017/11/23.
//

#import "NSObject+WtKVO.h"

#import <objc/runtime.h>
#import <objc/message.h>

@import ReactiveCocoa;

#import "WtKVOProxy.h"


@implementation NSObject (WtKVO)

- (NSMutableDictionary *)wtKVOKeyPathDelegateProxyMapping {
  NSMutableDictionary *mapping = objc_getAssociatedObject(self, _cmd);
  if (!mapping) {
    mapping = [[NSMutableDictionary alloc] initWithCapacity:3];
    objc_setAssociatedObject(self, _cmd, mapping, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
  }
  return mapping;
}

- (void)wtEnqueueKVOKeyPath:(NSString *)keyPath delegateProxy:(WtDelegateProxy<WtKVODelegate> *)delegateProxy {
  if (!delegateProxy) return;
  NSMutableDictionary *mapping = [self wtKVOKeyPathDelegateProxyMapping];
  NSMutableArray *delegateProxies = mapping[keyPath];
  if (!delegateProxies) {
    delegateProxies = [[NSMutableArray alloc] initWithCapacity:3];
    mapping[keyPath] = delegateProxies;
  }
  [delegateProxies addObject:delegateProxy];
}

- (NSArray *)wtKVODelegateProxiesWithKeyPath:(NSString *)keyPath {
  NSMutableDictionary *mapping = [self wtKVOKeyPathDelegateProxyMapping];
  return mapping[keyPath];
}

- (WtDelegateProxy<WtKVOProxyDelegate> *)wtKVODelegateProxy {
  WtDelegateProxy<WtKVOProxyDelegate> *delegateProxy = objc_getAssociatedObject(self, _cmd);
  if (!delegateProxy) {
    delegateProxy = (WtDelegateProxy<WtKVOProxyDelegate> *)[[WtDelegateProxy alloc] initWithProtocol:@protocol(WtKVOProxyDelegate)];
    objc_setAssociatedObject(self, _cmd, delegateProxy, OBJC_ASSOCIATION_RETAIN_NONATOMIC);

    @weakify(self);
    [delegateProxy selector:@selector(wtKVOObserveValueForKeyPath:ofObject:change:context:) block:^(NSString *keyPath, id object, NSDictionary *change, void *context) {
      @strongify(self);
      for (WtDelegateProxy<WtKVODelegate> *kvoDelegate in [self wtKVODelegateProxiesWithKeyPath:keyPath]) {
        [kvoDelegate valueChanged:object];
      }
    }];
  }
  return delegateProxy;
}

- (void)wtObserveValueForKeyPath:(NSString *)keyPath valueChangedBlock:(void (^)(id newValue))valueChangedBlock {
  if (![self wtKVODelegateProxiesWithKeyPath:keyPath]) {
    [self addObserver:WtKVOProxy.shared forKeyPath:keyPath options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:(__bridge void *)self];
  } else {
  }

  WtDelegateProxy<WtKVODelegate> *kvoDelegate = (WtDelegateProxy<WtKVODelegate> *)[[WtDelegateProxy alloc] initWithProtocol:@protocol(WtKVODelegate)];
  [kvoDelegate selector:@selector(valueChanged:) block:valueChangedBlock];
  [self wtEnqueueKVOKeyPath:keyPath delegateProxy:kvoDelegate];

  [[WtKVOProxy shared] wtAddObserver:[self wtKVODelegateProxy] forContext:(__bridge void *)self];
}
@end
