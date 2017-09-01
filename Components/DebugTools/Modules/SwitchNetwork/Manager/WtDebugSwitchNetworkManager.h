//
//  WtDebugSwitchNetworkManager.h
//  Pods
//
//  Created by wtfan on 2017/5/24.
//
//

#import <Foundation/Foundation.h>

#import "WtDebugSwitchNetworkGroup.h"

@interface WtDebugSwitchNetworkManager : NSObject
@property (nonatomic, readonly) NSArray<WtDebugSwitchNetworkGroup *> *networkGroups;
@property (nonatomic, copy) NSArray<WtDebugSwitchNetworkGroup *> * (^initialNetworkGroupsIfNecessary)();
+ (instancetype)sharedManager;
- (WtDebugSwitchNetworkGroup *)networkGroup:(NSString *)key;
@end
