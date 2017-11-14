//
//  WtDebugSwitchNetworkGroup.m
//  WtDebugTools
//
//  Created by wtfan on 2017/5/23.
//
//

#import "WtDebugSwitchNetworkGroup.h"

#import "WtDebugTableViewCellSwitchNetworkModel.h"

@interface WtDebugSwitchNetworkGroup ()
@property (nonatomic, strong, readonly) NSMutableArray<WtDebugSwitchNetworkItem *> *privateModels;
@property (nonatomic, strong) NSArray *privateCellModels;
@end

@implementation WtDebugSwitchNetworkGroup
- (void)dealloc {
    NSLog(@"%s", __func__);
}

- (instancetype)init {
    if (self = [super init]) {
        _privateModels = @[].mutableCopy;
    }
    return self;
}

- (WtDebugSwitchNetworkItem *)selectedModel {
    for (WtDebugSwitchNetworkItem *model in _privateModels) {
        if (model.isSelected) {
            return model;
        }
    }
    return nil;
}

#pragma mark - public

- (void)addModel:(WtDebugSwitchNetworkItem *)model {
    [_privateModels addObject:model];

    _privateCellModels = nil;
}

- (void)selectModel:(WtDebugSwitchNetworkItem *)model {
    for (WtDebugSwitchNetworkItem *item in _privateModels) {
        item.isSelected = NO;
    }
    model.isSelected = YES;

    _privateCellModels = nil;
}

- (NSArray <WtDebugSwitchNetworkItem *>*)models {
    return _privateModels.copy;
}

- (NSArray <WtDebugTableViewCellSwitchNetworkModel *>*)cellModels {
    if (_privateCellModels) return _privateCellModels;

    NSMutableArray *results = @[].mutableCopy;
    for (WtDebugSwitchNetworkItem *model in _privateModels) {
        WtDebugTableViewCellSwitchNetworkModel *cellModel = [[WtDebugTableViewCellSwitchNetworkModel alloc] init];
        cellModel.model = model;
        [cellModel.tableViewDelegate selector:@selector(tableView:heightForRowAtIndexPath:) block:^(UITableView *tableView, NSIndexPath *indexPath){
            return UITableViewAutomaticDimension;
        }];
        [results addObject:cellModel];
    }
    _privateCellModels = results;
    return _privateCellModels;
}
@end
