//
//  WtDebugSwitchNetworkGroup.h
//  WtDebugTools
//
//  Created by wtfan on 2017/5/23.
//
//

#import <Foundation/Foundation.h>

#import "WtDebugSwitchNetworkItem.h"
#import "WtDebugTableViewCellSwitchNetworkModel.h"

@interface WtDebugSwitchNetworkGroup : NSObject
@property (nonatomic, copy) NSString *key;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, readonly) WtDebugSwitchNetworkItem *selectedModel;

- (void)addModel:(WtDebugSwitchNetworkItem *)model;
- (void)selectModel:(WtDebugSwitchNetworkItem *)model;
- (NSArray <WtDebugSwitchNetworkItem *> *)models;
- (NSArray <WtDebugTableViewCellSwitchNetworkModel *> *)cellGlues;
@end
