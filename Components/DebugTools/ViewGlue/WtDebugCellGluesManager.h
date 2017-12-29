//
//  WtDebugCellGluesManager.h
//  WtCore
//
//  Created by fanwt on 2017/12/29.
//

#import <Foundation/Foundation.h>

#import "WtCellGlue.h"

@interface WtDebugCellGluesManager : NSObject
@property (nonatomic, strong) NSMutableArray<WtCellGlue *> *cellGlues;
+ (instancetype)shared;
- (void)installDefault;
@end
