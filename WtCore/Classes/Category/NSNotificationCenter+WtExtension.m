//
//  NSNotificationCenter+WtExtension.m
//  WtCore
//
//  Created by wtfan on 2022/8/9.
//

#import "NSNotificationCenter+WtExtension.h"

#import <objc/runtime.h>
#import <objc/message.h>

#import "WtEXTScope.h"
#import "WtKVOProxy.h"
#import "WtDeallocWatcher.h"


@implementation NSNotificationCenter (WtExtension)

- (WtNotificationBlock _Nonnull)wtAddObserverForName:(NSString *_Nonnull)name
                                              object:(id _Nullable)object
                                               block:(WtNotificationBlock _Nonnull)block
                              takeUntilTargetDealloc:(id _Nonnull)target {
    return [self wtAddObserverForName:name
                               object:object
                                queue:NSOperationQueue.currentQueue
                                block:block
               takeUntilTargetDealloc:target];
}

- (WtNotificationBlock _Nonnull)wtAddObserverForName:(NSString *_Nonnull)name
                                              object:(id _Nullable)object
                                               queue:(nullable NSOperationQueue *)queue
                                               block:(WtNotificationBlock _Nonnull)block
                              takeUntilTargetDealloc:(id _Nonnull)target {
    @autoreleasepool {
        __block id observer;
        observer = [self addObserverForName:name object:object queue:queue usingBlock:^(NSNotification * _Nonnull note) {
            block(note, observer);
        }];
        
        WtDeallocWatcher *deallocWatcher = [WtDeallocWatcher watcher:^{
            if (observer) {
                [self removeObserver:observer];
            }
        }];
        objc_setAssociatedObject(target, [NSString stringWithFormat:@"%.0f_note_dealloc_watcher", CFAbsoluteTimeGetCurrent() * 1000].UTF8String, deallocWatcher, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return block;
}

@end
