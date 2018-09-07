//
//  WtDeallocWatcher.h
//  WtCore
//
//  Created by fan weitian on 2018/8/27.
//

#import <Foundation/Foundation.h>

@interface WtDeallocWatcher : NSObject
@property (nonatomic, assign) id owner;
@property (nonatomic, copy) void (^whenDeallocBlock)(id owner);
+(instancetype)watcher:(void (^)(id owner))whenDeallocBlock owner:(id)owner;
@end
