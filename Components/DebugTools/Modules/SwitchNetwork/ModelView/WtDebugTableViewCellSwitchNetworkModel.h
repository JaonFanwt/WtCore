//
//  WtDebugTableViewCellSwitchNetworkModel
//  WtDebugTools
//
//  Created by wtfan on 2017/5/22.
//

#import <Foundation/Foundation.h>

#import "WtDebugSwitchNetworkItem.h"

#import "WtCellGlue.h"

@interface WtDebugTableViewCellSwitchNetworkModel : WtCellGlue
@property (nonatomic, strong) WtDebugSwitchNetworkItem *model;
@end
