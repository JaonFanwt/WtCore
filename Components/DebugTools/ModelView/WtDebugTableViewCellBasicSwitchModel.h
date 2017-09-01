//
// Created by wtfan on 2017/5/19.
//

#import <Foundation/Foundation.h>

#import <WtCore/WtTableViewCellModel.h>

@interface WtDebugTableViewCellBasicSwitchModel : WtTableViewCellModel
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *detailDescription;
@property (nonatomic, assign) BOOL on;
@end
