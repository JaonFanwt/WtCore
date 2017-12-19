//
// Created by wtfan on 2017/5/19.
//

#import <Foundation/Foundation.h>

#import "WtCellGlue.h"

@interface WtDebugTableViewCellBasicSwitchGlue : WtCellGlue
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *detailDescription;
@property (nonatomic, assign) BOOL on;
@end
