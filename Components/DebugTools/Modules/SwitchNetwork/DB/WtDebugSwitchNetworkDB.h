//
//  WtDebugSwitchNetworkDB.h
//  WtDebugTools
//
//  Created by wtfan on 2017/5/23.
//
//

#import <Foundation/Foundation.h>

#import "WtDebugSwitchNetworkGroup.h"

@interface WtDebugSwitchNetworkDB : NSObject
+ (NSArray <WtDebugSwitchNetworkGroup *> *)loadFromCache;
+ (void)cacheToCache:(NSArray <WtDebugSwitchNetworkGroup *>*)array;
@end
