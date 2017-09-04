//
//  WtThunderQueueManager.m
//  Pods
//
//  Created by wtfan on 2017/8/29.
//
//

#import "WtThunderQueueManager.h"

void wtDispatchInConnectionQueue(dispatch_block_t block) {
    [WtThunderQueueManager dispatchInConnectionQueue:block];
}

void wtDispatchInMainQueue(dispatch_block_t block) {
    [WtThunderQueueManager dispatchInMainQueue:block];
}

@implementation WtThunderQueueManager
+ (NSOperationQueue *)connectionQueue {
    static NSOperationQueue *_connectionQueue = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _connectionQueue = [[NSOperationQueue alloc] init];
        _connectionQueue.name = @"com.wtfan.WtThunderQueue.Connection";
        _connectionQueue.qualityOfService = NSQualityOfServiceUserInitiated;
    });
    
    return _connectionQueue;
}

+ (void)dispatchInConnectionQueue:(dispatch_block_t)block {
    if (!block) return;
    
    if ([[NSThread currentThread].name isEqualToString:[self connectionQueue].name]) {
        block();
    }else {
        NSBlockOperation *blkOP = [NSBlockOperation blockOperationWithBlock:block];
        [[self connectionQueue] addOperation:blkOP];
    }
}

+ (void)dispatchInMainQueue:(dispatch_block_t)block {
    if (!block) return;
    
    if ([NSThread isMainThread]) {
        block();
    }else {
        dispatch_async(dispatch_get_main_queue(), block);
    }
}
@end
