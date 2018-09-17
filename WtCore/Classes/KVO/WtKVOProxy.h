//
//  WtKVOProxy.h
//  Pods
//
//  Created by wtfan on 2017/11/23.
//

#import <Foundation/Foundation.h>

#import "WtDelegateProxy.h"

@protocol WtKVOProxyDelegate <NSObject>
- (void)wtKVOObserveValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context;
@end


@interface WtKVOProxy : NSObject
+ (instancetype)shared;
- (void)wtAddObserver:(WtDelegateProxy<WtKVOProxyDelegate> *)delegateProxy keyPath:(NSString *)keyPath forContext:(void *)context;
- (void)wtRemoveObserverForContext:(void *)context;
@end
