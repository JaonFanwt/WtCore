//
//  WtDeallocWatcher.h
//  WtCore
//
//  Created by fan weitian on 2018/8/27.
//

#import <Foundation/Foundation.h>

@interface WtDeallocWatcher : NSObject
@property (nonatomic, copy) void (^whenDeallocBlock)(void);
+ (instancetype)watcher:(void (^)(void))whenDeallocBlock;
@end
