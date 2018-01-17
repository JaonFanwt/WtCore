//
//  WtKVOProxy.m
//  Pods
//
//  Created by wtfan on 2017/11/23.
//

#import "WtKVOProxy.h"

@interface WtKVOProxy ()
@property (nonatomic, strong) NSMapTable *delegateProxyMapping;
@property (nonatomic, strong) dispatch_queue_t queue;
@end

@implementation WtKVOProxy
+ (instancetype)shared {
    static WtKVOProxy *proxy;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        proxy = [[WtKVOProxy alloc] init];
    });
    return proxy;
}

- (instancetype)init {
    if (self = [super init]) {
        _queue = dispatch_queue_create("com.fanwt.www.WtCore.WtKVOProxy", DISPATCH_QUEUE_SERIAL);
        _delegateProxyMapping = [NSMapTable strongToStrongObjectsMapTable];
    }
    return self;
}

- (void)wtAddObserver:(WtDelegateProxy<WtKVOProxyDelegate> *)delegateProxy forContext:(void *)context {
    NSValue *valueContext = [NSValue valueWithPointer:context];
    dispatch_sync(_queue, ^{
        [self.delegateProxyMapping setObject:delegateProxy forKey:valueContext];
    });
}

- (void)wtRemoveObserverForContext:(void *)context {
    NSValue *valueContext = [NSValue valueWithPointer:context];
    dispatch_sync(_queue, ^{
        [self.delegateProxyMapping removeObjectForKey:valueContext];
    });
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    NSValue *valueContext = [NSValue valueWithPointer:context];
    __block WtDelegateProxy<WtKVOProxyDelegate> *delegateProxy;
    
    dispatch_sync(_queue, ^{
        delegateProxy = [self.delegateProxyMapping objectForKey:valueContext];
    });
    
    [delegateProxy wtKVOObserveValueForKeyPath:keyPath ofObject:object change:change context:context];
}
@end
