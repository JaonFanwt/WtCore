//
//  WtThunderQueueManager.h
//  WtThunderWeb
//
//  Created by wtfan on 2017/8/29.
//
//

#import <Foundation/Foundation.h>

void wtDispatchInConnectionQueue(dispatch_block_t block);
void wtDispatchInMainQueue(dispatch_block_t block);


@interface WtThunderQueueManager : NSObject
+ (NSOperationQueue *)connectionQueue;
+ (void)dispatchInConnectionQueue:(dispatch_block_t)block;
+ (void)dispatchInMainQueue:(dispatch_block_t)block;
@end
