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
@property (nonatomic, strong) NSArray *privateCellGlues;
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

  _privateCellGlues = nil;
}

- (void)selectModel:(WtDebugSwitchNetworkItem *)model {
  for (WtDebugSwitchNetworkItem *item in _privateModels) {
    item.isSelected = NO;
  }
  model.isSelected = YES;

  _privateCellGlues = nil;
}

- (NSArray<WtDebugSwitchNetworkItem *> *)models {
  return _privateModels.copy;
}

- (NSArray<WtDebugTableViewCellSwitchNetworkModel *> *)cellGlues {
  if (_privateCellGlues) return _privateCellGlues;

  NSMutableArray *results = @[].mutableCopy;
  for (WtDebugSwitchNetworkItem *model in _privateModels) {
    WtDebugTableViewCellSwitchNetworkModel *cellGlue = [[WtDebugTableViewCellSwitchNetworkModel alloc] init];
    cellGlue.model = model;
    [cellGlue.tableViewDelegate selector:@selector(tableView:heightForRowAtIndexPath:) block:^(UITableView *tableView, NSIndexPath *indexPath) {
      return UITableViewAutomaticDimension;
    }];
    [results addObject:cellGlue];
  }
  _privateCellGlues = results;
  return _privateCellGlues;
}
@end
