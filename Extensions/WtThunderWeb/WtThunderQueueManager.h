//
//  WtThunderQueueManager.h
//  Pods
//
//  Created by wtfan on 2017/8/29.
//
//

#import <Foundation/Foundation.h>

@interface WtThunderQueueManager : NSObject
+ (NSOperationQueue *)connectionQueue;
+ (void)dispatchInConnectionQueue:(dispatch_block_t)block;
@end
